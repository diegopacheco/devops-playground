import fs from "node:fs"
import http from "node:http"
import path from "node:path"
import { fileURLToPath } from "node:url"
import { flociHealth } from "./lib/aws.js"
import { applyPolicy, runLab } from "./lib/playground.js"

const root = path.dirname(fileURLToPath(import.meta.url))
const publicRoot = path.join(root, "public")
const port = Number(process.env.PORT || 8080)
const bridgeUrl = new URL(process.env.AI_BRIDGE_URL || "http://127.0.0.1:18787")
const tokenFile = process.env.AI_TOKEN_FILE || path.join(root, "data", "ai-token")
const mime = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml"
}

function sendJson(response, status, value) {
  response.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "cache-control": "no-store"
  })
  response.end(JSON.stringify(value))
}

function readBody(request) {
  return new Promise((resolve, reject) => {
    const chunks = []
    let size = 0
    request.on("data", chunk => {
      size += chunk.length
      if (size > 1_000_000) {
        reject(new Error("Request is too large"))
        request.destroy()
        return
      }
      chunks.push(chunk)
    })
    request.on("end", () => {
      try {
        resolve(chunks.length ? JSON.parse(Buffer.concat(chunks).toString()) : {})
      } catch {
        reject(new Error("Request body must be JSON"))
      }
    })
    request.on("error", reject)
  })
}

function bridgeRequest(pathname, payload) {
  const token = fs.readFileSync(tokenFile, "utf8").trim()
  const body = payload ? Buffer.from(JSON.stringify(payload)) : Buffer.alloc(0)
  return new Promise((resolve, reject) => {
    const outgoing = http.request({
      hostname: bridgeUrl.hostname,
      port: bridgeUrl.port,
      path: pathname,
      method: payload ? "POST" : "GET",
      headers: {
        "content-type": "application/json",
        "content-length": body.length,
        "x-iam-forge-token": token
      },
      timeout: 65_000
    }, incoming => {
      const chunks = []
      incoming.on("data", chunk => chunks.push(chunk))
      incoming.on("end", () => {
        const text = Buffer.concat(chunks).toString()
        try {
          resolve({ status: incoming.statusCode, body: JSON.parse(text) })
        } catch {
          reject(new Error("AI bridge returned an invalid response"))
        }
      })
    })
    outgoing.on("timeout", () => outgoing.destroy(new Error("AI bridge timed out")))
    outgoing.on("error", reject)
    if (body.length) outgoing.write(body)
    outgoing.end()
  })
}

async function api(request, response, pathname) {
  if (request.method === "GET" && pathname === "/api/health") {
    const health = await flociHealth()
    sendJson(response, 200, {
      app: "ready",
      floci: {
        version: health.version,
        iam: health.services?.iam,
        s3: health.services?.s3
      }
    })
    return true
  }
  if (request.method === "POST" && pathname.startsWith("/api/labs/")) {
    const id = pathname.split("/").at(-1)
    sendJson(response, 200, await runLab(id))
    return true
  }
  if (request.method === "POST" && pathname === "/api/policies/apply") {
    sendJson(response, 200, await applyPolicy(await readBody(request)))
    return true
  }
  if (request.method === "GET" && pathname === "/api/assistant/status") {
    const result = await bridgeRequest("/status")
    sendJson(response, result.status, result.body)
    return true
  }
  if (request.method === "POST" && pathname === "/api/assistant") {
    const input = await readBody(request)
    if (!["codex", "claude", "agy"].includes(input.provider)) {
      sendJson(response, 400, { error: "Choose a supported AI provider" })
      return true
    }
    if (!String(input.prompt || "").trim()) {
      sendJson(response, 400, { error: "Write a question first" })
      return true
    }
    const result = await bridgeRequest("/ask", {
      provider: input.provider,
      prompt: String(input.prompt).slice(0, 4000),
      context: String(input.context || "").slice(0, 8000)
    })
    sendJson(response, result.status, result.body)
    return true
  }
  return false
}

function serveStatic(request, response, pathname) {
  const requested = pathname === "/" ? "index.html" : pathname.slice(1)
  const filePath = path.resolve(publicRoot, requested)
  if (!filePath.startsWith(`${publicRoot}${path.sep}`) || !fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    sendJson(response, 404, { error: "Not found" })
    return
  }
  response.writeHead(200, {
    "content-type": mime[path.extname(filePath)] || "application/octet-stream",
    "cache-control": "no-cache"
  })
  fs.createReadStream(filePath).pipe(response)
}

const server = http.createServer(async (request, response) => {
  const pathname = new URL(request.url, `http://${request.headers.host}`).pathname
  try {
    if (pathname.startsWith("/api/")) {
      if (!await api(request, response, pathname)) sendJson(response, 404, { error: "Not found" })
      return
    }
    serveStatic(request, response, pathname)
  } catch (error) {
    sendJson(response, error.status || 500, { error: error.message || "Unexpected failure" })
  }
})

server.listen(port, "0.0.0.0")
