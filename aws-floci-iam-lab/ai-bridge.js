import crypto from "node:crypto"
import fs from "node:fs"
import http from "node:http"
import path from "node:path"
import { spawn } from "node:child_process"

const port = Number(process.env.AI_BRIDGE_PORT || 18787)
const tokenFile = process.env.AI_TOKEN_FILE || path.join(process.cwd(), "data", "ai-token")
const providers = {
  codex: {
    label: "Codex Exec",
    command: "codex",
    args: prompt => ["exec", "--ephemeral", "--skip-git-repo-check", "--sandbox", "read-only", "--color", "never", prompt]
  },
  claude: {
    label: "Claude",
    command: "claude",
    args: prompt => ["-p", "--no-session-persistence", "--permission-mode", "plan", prompt]
  },
  agy: {
    label: "Agy",
    command: "agy",
    args: prompt => ["-p", prompt]
  }
}
let busy = false

function send(response, status, value) {
  response.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "cache-control": "no-store"
  })
  response.end(JSON.stringify(value))
}

function commandAvailable(command) {
  return (process.env.PATH || "").split(path.delimiter).some(directory => {
    try {
      fs.accessSync(path.join(directory, command), fs.constants.X_OK)
      return true
    } catch {
      return false
    }
  })
}

function authorized(request) {
  const expected = fs.readFileSync(tokenFile, "utf8").trim()
  const actual = String(request.headers["x-iam-forge-token"] || "")
  const expectedBytes = Buffer.from(expected)
  const actualBytes = Buffer.from(actual)
  return expectedBytes.length === actualBytes.length && crypto.timingSafeEqual(expectedBytes, actualBytes)
}

function readBody(request) {
  return new Promise((resolve, reject) => {
    const chunks = []
    request.on("data", chunk => chunks.push(chunk))
    request.on("end", () => {
      try {
        resolve(JSON.parse(Buffer.concat(chunks).toString()))
      } catch {
        reject(new Error("Invalid request"))
      }
    })
    request.on("error", reject)
  })
}

function invoke(provider, prompt) {
  return new Promise((resolve, reject) => {
    const selected = providers[provider]
    const child = spawn(selected.command, selected.args(prompt), {
      cwd: process.cwd(),
      env: process.env,
      stdio: ["ignore", "pipe", "pipe"]
    })
    const stdout = []
    const stderr = []
    let size = 0
    let settled = false
    const timer = setTimeout(() => {
      child.kill("SIGTERM")
      reject(new Error("The AI command exceeded 60 seconds"))
    }, 60_000)
    const collect = target => chunk => {
      size += chunk.length
      if (size <= 1_000_000) target.push(chunk)
    }
    child.stdout.on("data", collect(stdout))
    child.stderr.on("data", collect(stderr))
    child.on("error", error => {
      if (settled) return
      settled = true
      clearTimeout(timer)
      reject(error)
    })
    child.on("close", code => {
      if (settled) return
      settled = true
      clearTimeout(timer)
      const output = Buffer.concat(stdout).toString().trim()
      const errorOutput = Buffer.concat(stderr).toString().trim()
      if (code === 0 && output) resolve(output)
      else reject(new Error(errorOutput || `${selected.label} exited with code ${code}`))
    })
  })
}

const server = http.createServer(async (request, response) => {
  try {
    if (!authorized(request)) {
      send(response, 401, { error: "Unauthorized" })
      return
    }
    if (request.method === "GET" && request.url === "/status") {
      send(response, 200, {
        providers: Object.fromEntries(Object.entries(providers).map(([id, value]) => [
          id,
          { label: value.label, available: commandAvailable(value.command), command: id === "codex" ? "codex exec" : `${value.command} -p` }
        ]))
      })
      return
    }
    if (request.method === "POST" && request.url === "/ask") {
      if (busy) {
        send(response, 409, { error: "The AI bridge is serving another request" })
        return
      }
      const input = await readBody(request)
      const selected = providers[input.provider]
      if (!selected || !commandAvailable(selected.command)) {
        send(response, 400, { error: "The selected command is not available on this host" })
        return
      }
      const prompt = [
        "You are the IAM Forge guide.",
        "Answer the learner's AWS IAM question clearly and briefly.",
        "Do not execute commands or alter files.",
        `Current learning context:\n${input.context || "General IAM learning"}`,
        `Learner question:\n${input.prompt}`
      ].join("\n\n")
      busy = true
      try {
        send(response, 200, { answer: await invoke(input.provider, prompt), provider: input.provider })
      } finally {
        busy = false
      }
      return
    }
    send(response, 404, { error: "Not found" })
  } catch (error) {
    busy = false
    send(response, 500, { error: error.message || "AI bridge failed" })
  }
})

server.listen(port, "0.0.0.0")
