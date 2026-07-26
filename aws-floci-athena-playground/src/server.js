import { createReadStream, existsSync, statSync } from "node:fs";
import { createServer } from "node:http";
import { extname, join, normalize } from "node:path";
import { fileURLToPath } from "node:url";
import { assist } from "./ai.js";
import {
  queryResults,
  recentQueries,
  schema,
  seed,
  serviceStatus,
  startQuery,
  waitForFloci
} from "./aws.js";

const root = fileURLToPath(new URL("../public", import.meta.url));
const port = Number(process.env.PORT || 3000);
const contentTypes = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml"
};

const sendJson = (response, status, value) => {
  response.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "no-store",
    "X-Content-Type-Options": "nosniff"
  });
  response.end(JSON.stringify(value));
};

const readJson = request => new Promise((resolve, reject) => {
  let body = "";
  request.on("data", chunk => {
    body += chunk;
    if (body.length > 1000000) request.destroy();
  });
  request.on("end", () => {
    try {
      resolve(body ? JSON.parse(body) : {});
    } catch {
      reject(Object.assign(new Error("Invalid JSON body"), { status: 400 }));
    }
  });
  request.on("error", reject);
});

const routeApi = async (request, response, pathname) => {
  if (request.method === "GET" && pathname === "/api/status") {
    sendJson(response, 200, await serviceStatus());
    return true;
  }
  if (request.method === "GET" && pathname === "/api/schema") {
    sendJson(response, 200, { databases: await schema() });
    return true;
  }
  if (request.method === "GET" && pathname === "/api/history") {
    sendJson(response, 200, { queryIds: await recentQueries() });
    return true;
  }
  if (request.method === "POST" && pathname === "/api/query") {
    const { sql } = await readJson(request);
    if (!sql?.trim()) throw Object.assign(new Error("Write a query first"), { status: 400 });
    const execution = await startQuery(sql.trim());
    sendJson(response, 200, { ...execution, ...(await queryResults(execution.queryId)) });
    return true;
  }
  if (request.method === "POST" && pathname === "/api/results") {
    const { queryId, nextToken } = await readJson(request);
    if (!queryId) throw Object.assign(new Error("Query ID is required"), { status: 400 });
    sendJson(response, 200, await queryResults(queryId, nextToken));
    return true;
  }
  if (request.method === "POST" && pathname === "/api/ai") {
    const { provider, sql, request: instruction } = await readJson(request);
    if (!instruction?.trim()) throw Object.assign(new Error("Tell the assistant what to change"), { status: 400 });
    sendJson(response, 200, await assist(provider, sql || "", instruction.trim(), await schema()));
    return true;
  }
  return false;
};

const serveStatic = (response, pathname) => {
  const requested = pathname === "/" ? "index.html" : pathname.replace(/^\/+/, "");
  const safePath = normalize(requested).replace(/^(\.\.[/\\])+/, "");
  let file = join(root, safePath);
  if (!file.startsWith(root) || !existsSync(file)) {
    file = join(root, "index.html");
  }
  if (!statSync(file).isFile()) {
    sendJson(response, 404, { error: "Not found" });
    return;
  }
  response.writeHead(200, {
    "Content-Type": contentTypes[extname(file)] || "application/octet-stream",
    "Cache-Control": extname(file) === ".html" ? "no-cache" : "public, max-age=3600",
    "X-Content-Type-Options": "nosniff"
  });
  createReadStream(file).pipe(response);
};

await waitForFloci();
await seed();

createServer(async (request, response) => {
  const url = new URL(request.url, `http://${request.headers.host || "localhost"}`);
  try {
    if (url.pathname.startsWith("/api/")) {
      const handled = await routeApi(request, response, url.pathname);
      if (!handled) sendJson(response, 404, { error: "Not found" });
      return;
    }
    serveStatic(response, url.pathname);
  } catch (error) {
    sendJson(response, error.status || 500, { error: error.message || "Unexpected error" });
  }
}).listen(port, "0.0.0.0", () => {
  process.stdout.write(`Athena Playground listening on http://0.0.0.0:${port}\n`);
});
