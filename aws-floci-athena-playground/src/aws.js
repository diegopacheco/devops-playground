import {
  AthenaClient,
  GetQueryExecutionCommand,
  GetQueryResultsCommand,
  ListQueryExecutionsCommand,
  StartQueryExecutionCommand,
  StopQueryExecutionCommand
} from "@aws-sdk/client-athena";
import {
  CreateDatabaseCommand,
  CreateTableCommand,
  GlueClient,
  UpdateTableCommand
} from "@aws-sdk/client-glue";
import {
  CreateBucketCommand,
  HeadBucketCommand,
  ListBucketsCommand,
  PutObjectCommand,
  S3Client
} from "@aws-sdk/client-s3";

const endpoint = process.env.AWS_ENDPOINT_URL || "http://localhost:4566";
const region = process.env.AWS_DEFAULT_REGION || "us-east-1";
const credentials = {
  accessKeyId: process.env.AWS_ACCESS_KEY_ID || "flociadmin",
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || "flociadmin"
};
const config = { endpoint, region, credentials };

export const athena = new AthenaClient(config);
export const glue = new GlueClient(config);
export const s3 = new S3Client({ ...config, forcePathStyle: true });
export const dataBucket = process.env.DATA_BUCKET || "athena-playground-lake";
export const database = process.env.ATHENA_DATABASE || "analytics";

const customers = [
  { customer_id: 201, customer_name: "Acme Labs", segment: "Enterprise", country: "United States", joined_at: "2025-01-14" },
  { customer_id: 202, customer_name: "Northstar Co", segment: "Growth", country: "Ireland", joined_at: "2025-03-02" },
  { customer_id: 203, customer_name: "Sora Works", segment: "Enterprise", country: "Singapore", joined_at: "2025-05-19" },
  { customer_id: 204, customer_name: "Juniper & Co", segment: "Growth", country: "United States", joined_at: "2025-08-07" }
];

const orders = [
  { order_id: 1001, customer_id: 201, region: "us-east", category: "Compute", amount: 1840.5, ordered_at: "2026-07-18" },
  { order_id: 1002, customer_id: 202, region: "eu-west", category: "Storage", amount: 640.25, ordered_at: "2026-07-18" },
  { order_id: 1003, customer_id: 201, region: "us-east", category: "Analytics", amount: 2310, ordered_at: "2026-07-19" },
  { order_id: 1004, customer_id: 203, region: "ap-south", category: "Compute", amount: 920.75, ordered_at: "2026-07-19" },
  { order_id: 1005, customer_id: 204, region: "us-west", category: "Network", amount: 410.3, ordered_at: "2026-07-20" },
  { order_id: 1006, customer_id: 202, region: "eu-west", category: "Analytics", amount: 1530, ordered_at: "2026-07-21" },
  { order_id: 1007, customer_id: 203, region: "ap-south", category: "Storage", amount: 785.9, ordered_at: "2026-07-21" },
  { order_id: 1008, customer_id: 201, region: "us-east", category: "Network", amount: 1190.45, ordered_at: "2026-07-22" },
  { order_id: 1009, customer_id: 204, region: "us-west", category: "Compute", amount: 2680, ordered_at: "2026-07-23" },
  { order_id: 1010, customer_id: 202, region: "eu-west", category: "Storage", amount: 540.65, ordered_at: "2026-07-24" },
  { order_id: 1011, customer_id: 203, region: "ap-south", category: "Analytics", amount: 3420, ordered_at: "2026-07-24" },
  { order_id: 1012, customer_id: 204, region: "us-west", category: "Network", amount: 725.1, ordered_at: "2026-07-25" }
];

const ordersTable = {
  Name: "orders",
  TableType: "EXTERNAL_TABLE",
  Parameters: { classification: "json" },
  StorageDescriptor: {
    Location: `s3://${dataBucket}/orders/`,
    InputFormat: "org.apache.hadoop.mapred.TextInputFormat",
    OutputFormat: "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
    SerdeInfo: { SerializationLibrary: "org.openx.data.jsonserde.JsonSerDe" },
    Columns: [
      { Name: "order_id", Type: "int" },
      { Name: "customer_id", Type: "int" },
      { Name: "region", Type: "string" },
      { Name: "category", Type: "string" },
      { Name: "amount", Type: "double" },
      { Name: "ordered_at", Type: "date" }
    ]
  }
};

const customersTable = {
  Name: "customers",
  TableType: "EXTERNAL_TABLE",
  Parameters: { classification: "json" },
  StorageDescriptor: {
    Location: `s3://${dataBucket}/customers/`,
    InputFormat: "org.apache.hadoop.mapred.TextInputFormat",
    OutputFormat: "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
    SerdeInfo: { SerializationLibrary: "org.openx.data.jsonserde.JsonSerDe" },
    Columns: [
      { Name: "customer_id", Type: "int" },
      { Name: "customer_name", Type: "string" },
      { Name: "segment", Type: "string" },
      { Name: "country", Type: "string" },
      { Name: "joined_at", Type: "date" }
    ]
  }
};

const existsError = error => ["AlreadyExistsException", "BucketAlreadyOwnedByYou", "BucketAlreadyExists"].includes(error.name);

export async function waitForFloci(attempts = 60) {
  let lastError;
  for (let index = 0; index < attempts; index += 1) {
    try {
      await s3.send(new ListBucketsCommand({}));
      return;
    } catch (error) {
      lastError = error;
      await new Promise(resolve => setTimeout(resolve, 500));
    }
  }
  throw lastError;
}

export async function seed() {
  try {
    await s3.send(new CreateBucketCommand({ Bucket: dataBucket }));
  } catch (error) {
    if (!existsError(error)) throw error;
  }
  await s3.send(new PutObjectCommand({
    Bucket: dataBucket,
    Key: "orders/data.json",
    ContentType: "application/x-ndjson",
    Body: `${orders.map(row => JSON.stringify(row)).join("\n")}\n`
  }));
  await s3.send(new PutObjectCommand({
    Bucket: dataBucket,
    Key: "customers/data.json",
    ContentType: "application/x-ndjson",
    Body: `${customers.map(row => JSON.stringify(row)).join("\n")}\n`
  }));
  try {
    await glue.send(new CreateDatabaseCommand({ DatabaseInput: { Name: database, Description: "Athena Playground catalog" } }));
  } catch (error) {
    if (!existsError(error)) throw error;
  }
  for (const tableInput of [ordersTable, customersTable]) {
    try {
      await glue.send(new CreateTableCommand({ DatabaseName: database, TableInput: tableInput }));
    } catch (error) {
      if (!existsError(error)) throw error;
      await glue.send(new UpdateTableCommand({ DatabaseName: database, TableInput: tableInput }));
    }
  }
}

export async function serviceStatus() {
  const started = Date.now();
  await s3.send(new HeadBucketCommand({ Bucket: dataBucket }));
  return {
    connected: true,
    endpoint,
    region,
    bucket: dataBucket,
    database,
    latency: Date.now() - started
  };
}

export async function schema() {
  const tables = [];
  let nextToken;
  do {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-amz-json-1.1",
        "X-Amz-Target": "AWSGlue.GetTables"
      },
      body: JSON.stringify({ DatabaseName: database, NextToken: nextToken })
    });
    const body = await response.json();
    if (!response.ok) throw new Error(body.message || body.Message || "Glue catalog request failed");
    tables.push(...(body.TableList || []).map(table => ({
      name: table.Name,
      location: table.StorageDescriptor?.Location || "",
      columns: (table.StorageDescriptor?.Columns || []).map(column => ({
        name: column.Name,
        type: column.Type
      }))
    })));
    nextToken = body.NextToken;
  } while (nextToken);
  return [{ name: database, tables }];
}

export async function startQuery(sql) {
  const databasePattern = database.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const query = sql
    .trim()
    .replace(new RegExp(`\\b${databasePattern}\\s*\\.\\s*`, "gi"), "")
    .replace(/;+\s*$/, "");
  const response = await athena.send(new StartQueryExecutionCommand({
    QueryString: query,
    QueryExecutionContext: { Database: database },
    ResultConfiguration: { OutputLocation: `s3://${dataBucket}/results/` }
  }));
  const queryId = response.QueryExecutionId;
  for (let index = 0; index < 240; index += 1) {
    const execution = await athena.send(new GetQueryExecutionCommand({ QueryExecutionId: queryId }));
    const status = execution.QueryExecution?.Status;
    if (status?.State === "SUCCEEDED") {
      return {
        queryId,
        state: status.State,
        elapsed: execution.QueryExecution?.Statistics?.EngineExecutionTimeInMillis || 0
      };
    }
    if (["FAILED", "CANCELLED"].includes(status?.State)) {
      throw Object.assign(new Error(status.StateChangeReason || `Query ${status.State.toLowerCase()}`), { status: 400 });
    }
    await new Promise(resolve => setTimeout(resolve, 250));
  }
  await athena.send(new StopQueryExecutionCommand({ QueryExecutionId: queryId }));
  throw Object.assign(new Error("Query exceeded the 60 second local limit"), { status: 408 });
}

export async function queryResults(queryId, nextToken) {
  const response = await athena.send(new GetQueryResultsCommand({
    QueryExecutionId: queryId,
    NextToken: nextToken || undefined,
    MaxResults: 50
  }));
  const columns = (response.ResultSet?.ResultSetMetadata?.ColumnInfo || []).map(column => ({
    name: column.Name,
    type: column.Type
  }));
  let rows = (response.ResultSet?.Rows || []).map(row =>
    columns.map((column, index) => row.Data?.[index]?.VarCharValue ?? null)
  );
  if (!nextToken && rows[0]?.every((value, index) => value === columns[index]?.name)) rows = rows.slice(1);
  return { columns, rows, nextToken: response.NextToken || null };
}

export async function recentQueries() {
  const response = await athena.send(new ListQueryExecutionsCommand({ MaxResults: 10 }));
  return response.QueryExecutionIds || [];
}
