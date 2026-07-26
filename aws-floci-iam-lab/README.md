# IAM Forge

IAM Forge is a light-themed AWS Identity and Access Management playground powered by Podman and [Floci](https://floci.io/aws/). It teaches the IAM mental model, provisions local IAM and S3 resources, evaluates focused policies, and routes learning questions to an AI CLI already configured on the host.

No AWS account or cloud credentials are required.

## What is included

- IAM crash course covering principals, statements, evaluation, and least privilege
- Three Floci-backed field drills
- JSON policy editor with syntax highlighting and reusable starting points
- Real S3 bucket, object, IAM user, and inline policy creation in Floci
- Decision matrix for Action and Resource matching with explicit deny precedence
- AI bridge for `codex exec`, `claude -p`, and `agy -p`
- Browser-persisted AI provider preference
- Responsive light interface with keyboard-accessible tabs

## Requirements

- Podman
- podman-compose
- Node.js 24 or newer
- curl
- At least one optional AI CLI: `codex`, `claude`, or `agy`

The AI bridge uses the authentication already configured for each host CLI.

## Start

```bash
./start.sh
```

Open [http://127.0.0.1:8080](http://127.0.0.1:8080).

The startup script creates a local bridge token, starts the host AI bridge, builds the playground container, starts Floci, and waits for IAM and S3 readiness. Wait loops sleep for one second and stop after one minute.

## Test

With the stack running:

```bash
./test.sh
```

The checks cover:

- IAM evaluator unit behavior
- Floci IAM and S3 health
- A complete field drill
- Policy application and decision results
- AI provider configuration
- Interface delivery

## Stop

```bash
./stop.sh
```

Floci state remains in the named Podman volume. The host AI bridge is stopped and its process file is removed.

## Architecture

```text
Browser :8080
    |
Node playground container
    |-- AWS SigV4 --> Floci :4566
    |                 |-- IAM
    |                 `-- S3
    |
    `-- token-authenticated HTTP --> host AI bridge :18787
                                      |-- codex exec
                                      |-- claude -p
                                      `-- agy -p
```

The Node service uses built-in modules only. It signs AWS requests directly and has no runtime package dependencies.

## IAM boundary

Floci creates and returns the IAM users, inline policies, S3 buckets, and objects used by the playground. Current Floci S3 accepts local credentials independently of attached identity policies. IAM Forge therefore does not claim that S3 rejected a request.

The decision matrix is a focused local evaluator supporting:

- `Action` and `NotAction`
- `Resource` and `NotResource`
- `Allow`
- implicit deny
- explicit deny precedence
- `*` wildcards

Policies containing `Condition` or `Principal` are rejected by the editor because those elements are outside this focused identity-policy evaluator.

## Services

| Service | Address | Purpose |
|---|---|---|
| IAM Forge | `http://127.0.0.1:8080` | UI and application API |
| Floci | `http://127.0.0.1:4566` | Local AWS endpoint |
| AI bridge | `http://127.0.0.1:18787` | Token-protected host CLI route |

## AI preference

The selected provider is stored in browser local storage under `iamForge.provider`. No provider secret is stored by the browser or playground container. The generated bridge token lives at `data/ai-token` and is excluded from Git.

## Project layout

```text
public/         Browser interface
lib/            AWS signing, IAM evaluation, Floci workflows
test/           Node unit checks
server.js       Dependency-free application server
ai-bridge.js    Host CLI bridge
compose.yaml    Podman services
Containerfile   Playground image
start.sh        Start and readiness flow
stop.sh         Stop flow
test.sh         End-to-end checks
```
