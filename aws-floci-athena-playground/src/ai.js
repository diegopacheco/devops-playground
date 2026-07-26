import { spawn } from "node:child_process";

const providers = {
  codex: {
    command: "codex",
    timeout: 60000,
    args: prompt => [
      "exec",
      "--ephemeral",
      "--ignore-user-config",
      "--ignore-rules",
      "--sandbox",
      "read-only",
      "--skip-git-repo-check",
      "-c",
      'model_reasoning_effort="low"',
      prompt
    ]
  },
  claude: {
    command: "claude",
    timeout: 60000,
    args: prompt => ["--safe-mode", "--tools", "", "--no-session-persistence", "-p", prompt]
  },
  agy: {
    command: "agy",
    timeout: 30000,
    args: prompt => ["--sandbox", "--print-timeout", "25s", "-p", prompt]
  }
};

const extractSql = output => {
  const fenced = output.match(/```(?:sql)?\s*([\s\S]*?)```/i);
  if (fenced) return fenced[1].trim();
  const start = output.search(/\b(?:SELECT|WITH|DESCRIBE|SHOW|EXPLAIN)\b/i);
  return start >= 0 ? output.slice(start).trim().replace(/\s*(?:Here'?s|This query)[\s\S]*$/i, "") : output.trim();
};

const normalizeSql = (sql, catalog) => {
  let normalized = sql;
  for (const item of catalog) {
    const pattern = item.name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    normalized = normalized.replace(new RegExp(`\\b${pattern}\\s*\\.\\s*`, "gi"), "");
  }
  return normalized;
};

export function runAssist(provider, sql, request, catalog) {
  const selected = providers[provider];
  if (!selected) throw Object.assign(new Error("Unknown AI provider"), { status: 400 });
  const schema = catalog.map(database => [
    `Glue database: ${database.name}`,
    ...database.tables.map(table =>
      `Table: ${table.name}(${table.columns.map(column => `${column.name} ${column.type}`).join(", ")})`
    )
  ].join("\n")).join("\n\n");
  const prompt = [
    "You are an Amazon Athena SQL assistant.",
    "The data is stored in Amazon S3 and registered in the AWS Glue Data Catalog.",
    "Queries are sent through the Athena API to Floci and executed by its DuckDB sidecar.",
    "Floci injects Glue tables as unqualified DuckDB views.",
    "Use unqualified table names such as orders and customers.",
    "Never use analytics.orders, analytics.customers, or any database-qualified table name.",
    "orders.customer_id joins customers.customer_id.",
    "Return only one executable SQL query with no markdown and no explanation.",
    "Do not access files, tools, the network, or execute commands.",
    `Glue schema:\n${schema}`,
    `Current SQL:\n${sql}`,
    `Request:\n${request}`
  ].join("\n\n");
  return new Promise((resolve, reject) => {
    const child = spawn(selected.command, selected.args(prompt), {
      cwd: process.cwd(),
      env: { ...process.env, NO_COLOR: "1" },
      stdio: ["ignore", "pipe", "pipe"]
    });
    let stdout = "";
    let stderr = "";
    let settled = false;
    const rejectOnce = error => {
      if (settled) return;
      settled = true;
      reject(error);
    };
    const timer = setTimeout(() => {
      child.kill("SIGTERM");
      rejectOnce(Object.assign(new Error(`${provider} exceeded ${selected.timeout / 1000} seconds`), { status: 408 }));
    }, selected.timeout);
    child.stdout.on("data", chunk => {
      if (stdout.length < 200000) stdout += chunk;
    });
    child.stderr.on("data", chunk => {
      if (stderr.length < 20000) stderr += chunk;
    });
    child.on("error", error => {
      clearTimeout(timer);
      const message = error.code === "ENOENT"
        ? `${selected.command} is not installed on the host`
        : error.message;
      rejectOnce(Object.assign(new Error(message), { status: 503 }));
    });
    child.on("close", code => {
      clearTimeout(timer);
      if (settled) return;
      if (code !== 0) {
        rejectOnce(Object.assign(new Error(stderr.trim() || stdout.trim() || `${provider} exited with code ${code}`), { status: 502 }));
        return;
      }
      const query = normalizeSql(extractSql(stdout), catalog);
      if (!query) {
        rejectOnce(Object.assign(new Error(`${provider} returned no SQL`), { status: 502 }));
        return;
      }
      settled = true;
      resolve({ query, provider });
    });
  });
}

export async function assist(provider, sql, request, catalog) {
  const bridgeUrl = process.env.AI_BRIDGE_URL;
  if (!bridgeUrl) return runAssist(provider, sql, request, catalog);
  const response = await fetch(`${bridgeUrl}/assist`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${process.env.AI_BRIDGE_TOKEN || ""}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ provider, sql, request, catalog }),
    signal: AbortSignal.timeout(65000)
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok) throw Object.assign(new Error(body.error || "AI bridge request failed"), { status: response.status });
  return body;
}
