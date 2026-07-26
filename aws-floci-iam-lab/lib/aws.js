import crypto from "node:crypto"
import http from "node:http"

const endpoint = new URL(process.env.FLOCI_URL || "http://floci:4566")
const region = process.env.AWS_DEFAULT_REGION || "us-east-1"
const rootCredentials = {
  accessKeyId: process.env.AWS_ACCESS_KEY_ID || "test",
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || "test"
}

function hash(value) {
  return crypto.createHash("sha256").update(value).digest("hex")
}

function hmac(key, value, encoding) {
  return crypto.createHmac("sha256", key).update(value).digest(encoding)
}

function awsEncode(value) {
  return encodeURIComponent(value).replace(/[!'()*]/g, character => `%${character.charCodeAt(0).toString(16).toUpperCase()}`)
}

function canonicalQuery(params) {
  return [...params.entries()]
    .sort(([leftKey, leftValue], [rightKey, rightValue]) => leftKey.localeCompare(rightKey) || leftValue.localeCompare(rightValue))
    .map(([key, value]) => `${awsEncode(key)}=${awsEncode(value)}`)
    .join("&")
}

function request({ method, path, query = new URLSearchParams(), body = "", service, contentType, credentials = rootCredentials }) {
  const now = new Date()
  const date = now.toISOString().replace(/[:-]|\.\d{3}/g, "")
  const day = date.slice(0, 8)
  const payload = Buffer.from(body)
  const payloadHash = hash(payload)
  const headers = {
    host: endpoint.host,
    "x-amz-content-sha256": payloadHash,
    "x-amz-date": date
  }
  if (contentType) headers["content-type"] = contentType
  const signedHeaders = Object.keys(headers).sort().join(";")
  const normalizedHeaders = Object.keys(headers).sort().map(key => `${key}:${headers[key].trim()}\n`).join("")
  const scope = `${day}/${region}/${service}/aws4_request`
  const canonical = [method, path, canonicalQuery(query), normalizedHeaders, signedHeaders, payloadHash].join("\n")
  const stringToSign = ["AWS4-HMAC-SHA256", date, scope, hash(canonical)].join("\n")
  const dateKey = hmac(`AWS4${credentials.secretAccessKey}`, day)
  const regionKey = hmac(dateKey, region)
  const serviceKey = hmac(regionKey, service)
  const signingKey = hmac(serviceKey, "aws4_request")
  const signature = hmac(signingKey, stringToSign, "hex")
  headers.authorization = `AWS4-HMAC-SHA256 Credential=${credentials.accessKeyId}/${scope}, SignedHeaders=${signedHeaders}, Signature=${signature}`
  headers["content-length"] = payload.length

  return new Promise((resolve, reject) => {
    const outgoing = http.request({
      hostname: endpoint.hostname,
      port: endpoint.port,
      method,
      path: `${path}${query.size ? `?${canonicalQuery(query)}` : ""}`,
      headers
    }, response => {
      const chunks = []
      response.on("data", chunk => chunks.push(chunk))
      response.on("end", () => {
        const text = Buffer.concat(chunks).toString()
        resolve({ status: response.statusCode, headers: response.headers, body: text })
      })
    })
    outgoing.on("error", reject)
    if (payload.length) outgoing.write(payload)
    outgoing.end()
  })
}

function decodeXml(value) {
  return value
    .replaceAll("&lt;", "<")
    .replaceAll("&gt;", ">")
    .replaceAll("&quot;", "\"")
    .replaceAll("&apos;", "'")
    .replaceAll("&amp;", "&")
}

export function xmlTag(xml, tag) {
  const match = xml.match(new RegExp(`<${tag}>([\\s\\S]*?)</${tag}>`))
  return match ? decodeXml(match[1]) : ""
}

function assertAws(response, accepted = []) {
  if (response.status >= 200 && response.status < 300) return response
  const code = xmlTag(response.body, "Code") || `HTTP${response.status}`
  if (accepted.includes(code)) return response
  const message = xmlTag(response.body, "Message") || "Floci request failed"
  throw new Error(`${code}: ${message}`)
}

export async function iam(action, fields = {}, accepted = []) {
  const params = new URLSearchParams({ Action: action, Version: "2010-05-08", ...fields })
  const response = await request({
    method: "POST",
    path: "/",
    body: params.toString(),
    service: "iam",
    contentType: "application/x-www-form-urlencoded; charset=utf-8"
  })
  return assertAws(response, accepted)
}

export async function createBucket(bucket) {
  return assertAws(await request({
    method: "PUT",
    path: `/${awsEncode(bucket)}`,
    service: "s3"
  }), ["BucketAlreadyExists", "BucketAlreadyOwnedByYou"])
}

export async function putObject(bucket, key, value) {
  return assertAws(await request({
    method: "PUT",
    path: `/${awsEncode(bucket)}/${key.split("/").map(awsEncode).join("/")}`,
    body: value,
    service: "s3",
    contentType: "text/plain; charset=utf-8"
  }))
}

export async function flociHealth() {
  return new Promise((resolve, reject) => {
    const outgoing = http.get(`${endpoint.origin}/_localstack/health`, response => {
      const chunks = []
      response.on("data", chunk => chunks.push(chunk))
      response.on("end", () => {
        try {
          resolve(JSON.parse(Buffer.concat(chunks).toString()))
        } catch (error) {
          reject(error)
        }
      })
    })
    outgoing.on("error", reject)
  })
}
