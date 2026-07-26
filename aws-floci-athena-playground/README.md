# Flocus

Flocus is a light-themed local Athena query playground backed by Floci. Athena executes SQL through Floci's DuckDB sidecar, Glue supplies the table catalog, and S3 stores both source data and query results.

## Features

- Real Athena API calls against Floci
- S3-backed JSON data registered in Glue
- SQL syntax colors with synchronized line numbers
- Schema-aware completion for SQL keywords, functions, tables, and columns
- Paginated Athena result grid with switchable zebra rows
- CSV export for the visible result page
- AI query assistance through `codex exec`, `claude -p`, or `agy -p`
- Browser-persisted AI provider preference
- Responsive light interface
- Podman and podman-compose workflow

## Requirements

- Podman 5 or newer
- podman-compose
- Node.js 24 or newer
- `curl`
- A running Podman machine on macOS
- At least one authenticated host CLI: `codex`, `claude`, or `agy`

The first Athena query asks Floci to pull and start `floci/floci-duck:latest`. The Podman socket mounted into the Floci container enables that sidecar.

## Start

```bash
./start.sh
```

Open `http://localhost:8081`.

The startup flow creates:

- `s3://athena-playground-lake/orders/data.json`
- `s3://athena-playground-lake/customers/data.json`
- Glue database `analytics`
- Glue table `orders`
- Glue table `customers`
- Athena result location `s3://athena-playground-lake/results/`

## Stop

```bash
./stop.sh
```

State is persisted in `./data`.

## Test

```bash
./test.sh
```

The test suite checks Floci connectivity, the Glue catalog, real Athena execution over S3 data, and API error behavior.

## SQL editor

Run the current query with the Run query button or:

```text
Command + Enter
Control + Enter
```

Open completion with:

```text
Control + Space
```

The editor also opens completion while typing recognized prefixes. Double-click the `orders` table in the catalog to insert a basic table query.

## AI query assist

Pick a provider in the right panel. The choice is stored in browser local storage and restored on the next visit.

The three command-line clients run through an authenticated bridge on the host. This preserves native OAuth, keychain access, hooks, configuration, and network behavior.

```text
codex exec
claude -p
agy -p
```

Authenticate each host CLI normally before starting Flocus. API keys exported in the shell are inherited by the bridge:

```bash
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
export GEMINI_API_KEY="your-key"
./start.sh
```

Each request sends the current SQL, Glue table names, column names, column types, table relationship, and written instruction to the selected CLI. The prompt identifies the target as Athena over S3 through Glue and Floci. Source rows and query results are not sent. The generated SQL is shown for review before it replaces the editor content.

## Services

| Service | Address | Purpose |
| --- | --- | --- |
| Flocus | `http://localhost:8081` | Browser UI and API |
| Floci | `http://localhost:4567` | Local AWS endpoint |
| AI bridge | `http://localhost:3031` | Authenticated host CLI execution |
| floci-duck | Managed by Floci | DuckDB query execution |

## Project layout

```text
public/
  app.js
  index.html
  styles.css
src/
  ai-bridge.js
  ai.js
  aws.js
  server.js
test/
  api.test.js
Containerfile
podman-compose.yml
start.sh
stop.sh
test.sh
```
