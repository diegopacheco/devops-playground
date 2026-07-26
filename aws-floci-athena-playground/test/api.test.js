import assert from "node:assert/strict";
import test from "node:test";

const baseUrl = process.env.BASE_URL || "http://localhost:3000";

const request = async (path, options) => {
  const response = await fetch(`${baseUrl}${path}`, options);
  const body = await response.json();
  assert.equal(response.ok, true, body.error);
  return body;
};

test("Floci S3 status is connected", async () => {
  const status = await request("/api/status");
  assert.equal(status.connected, true);
  assert.equal(status.database, "analytics");
  assert.equal(status.bucket, "athena-playground-lake");
});

test("Glue catalog contains related orders and customers tables", async () => {
  const catalog = await request("/api/schema");
  const analytics = catalog.databases.find(database => database.name === "analytics");
  assert.ok(analytics);
  const orders = analytics.tables.find(table => table.name === "orders");
  const customers = analytics.tables.find(table => table.name === "customers");
  assert.ok(orders);
  assert.ok(customers);
  assert.ok(orders.columns.some(column => column.name === "amount"));
  assert.ok(orders.columns.some(column => column.name === "customer_id"));
  assert.ok(customers.columns.some(column => column.name === "customer_id"));
});

test("Athena executes SQL with a trailing semicolon over Floci S3 data", async () => {
  const result = await request("/api/query", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ sql: "SELECT COUNT(*) AS order_count, ROUND(SUM(amount), 2) AS revenue FROM orders;" })
  });
  assert.equal(result.state, "SUCCEEDED");
  assert.deepEqual(result.columns.map(column => column.name), ["order_count", "revenue"]);
  assert.equal(result.rows[0][0], "12");
  assert.equal(result.rows[0][1], "16993.9");
});

test("Athena joins qualified Glue table names after Floci normalization", async () => {
  const result = await request("/api/query", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      sql: "SELECT c.customer_name, ROUND(SUM(o.amount), 2) AS total_amount, COUNT(*) AS order_count FROM analytics.orders o JOIN analytics.customers c ON o.customer_id = c.customer_id GROUP BY c.customer_name ORDER BY total_amount DESC LIMIT 3;"
    })
  });
  assert.equal(result.state, "SUCCEEDED");
  assert.deepEqual(result.columns.map(column => column.name), ["customer_name", "total_amount", "order_count"]);
  assert.deepEqual(result.rows[0], ["Acme Labs", "5340.95", "3"]);
  assert.equal(result.rows.length, 3);
});

test("unknown API routes return JSON 404", async () => {
  const response = await fetch(`${baseUrl}/api/missing`);
  const body = await response.json();
  assert.equal(response.status, 404);
  assert.equal(body.error, "Not found");
});
