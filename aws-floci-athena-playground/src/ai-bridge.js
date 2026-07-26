import { createServer } from "node:http";
import { runAssist } from "./ai.js";

const port = Number(process.env.AI_BRIDGE_PORT || 3031);
const token = process.env.AI_BRIDGE_TOKEN || "";

const send = (response, status, body) => {
  response.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Content-Type-Options": "nosniff"
  });
  response.end(JSON.stringify(body));
};

const readBody = request => new Promise((resolve, reject) => {
  let body = "";
  request.on("data", chunk => {
    body += chunk;
    if (body.length > 1000000) request.destroy();
  });
  request.on("end", () => {
    try {
      resolve(JSON.parse(body || "{}"));
    } catch {
      reject(Object.assign(new Error("Invalid JSON body"), { status: 400 }));
    }
  });
  request.on("error", reject);
});

createServer(async (request, response) => {
  if (request.headers.authorization !== `Bearer ${token}` || !token) {
    send(response, 401, { error: "Unauthorized" });
    return;
  }
  if (request.method === "GET" && request.url === "/health") {
    send(response, 200, { ready: true });
    return;
  }
  if (request.method !== "POST" || request.url !== "/assist") {
    send(response, 404, { error: "Not found" });
    return;
  }
  try {
    const { provider, sql, request: instruction, catalog } = await readBody(request);
    send(response, 200, await runAssist(provider, sql || "", instruction || "", catalog || []));
  } catch (error) {
    send(response, error.status || 500, { error: error.message || "AI bridge failed" });
  }
}).listen(port, "0.0.0.0", () => {
  process.stdout.write(`AI bridge listening on port ${port}\n`);
});
