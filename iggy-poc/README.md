<img src="printscreens/logo.png" alt="iggy-poc" width="420">

A proof of concept that runs **[Apache Iggy](https://iggy.apache.org/)** on **podman / podman-compose** and moves real messages through it with a **Rust 1.98 / edition 2024** producer and consumer. `test.sh` proves the messages actually landed in the log and reached the consumer group instead of just checking exit codes.

## How it Works?

`build.sh` compiles the Rust crate on the host, runs its unit test, then builds the app image from a multi-stage `Containerfile` and pulls the Iggy server and Web UI images.

`start.sh` brings up the Iggy server and the Web UI, waits for `/ping` and `/healthz`, starts the consumer, then runs the producer. The producer opens a TCP connection with a connection string, creates the `orders` stream and the `placed` topic with 3 partitions if they are missing, and sends 20 JSON orders. Iggy spreads them round robin across the partitions.

The consumer joins the `billing` consumer group, polls with `PollingStrategy::next()` and auto-commits its offset per message, so a second run reads only what the second producer run appended. It prints each message with its partition and offset, then exits once it has seen the expected count.

`test.sh` snapshots `messages_count` on the topic through the HTTP API, runs both containers, and then asserts on what the server actually stored.

## Architecture

![architecture](printscreens/architecture.png)

## Features

- **Rust 1.98 with edition 2024** — the crate, the `iggy` SDK and the container build all sit on edition 2024, no compatibility shims.
- **Real partitioning** — the topic has 3 partitions and `test.sh` fails unless messages were observed on all of them.
- **Consumer groups with offset commits** — the consumer rejoins across runs and picks up where it left off instead of replaying the log.
- **io_uring made to work under podman** — the server needs its io_uring syscalls, so the compose service drops the seccomp and SELinux confinement that block them.
- **The Web UI is part of the stack** — `ui.sh` opens it already pointed at the server, so the produced messages are browsable.
- **`test.sh` asserts on server state** — sent, received, stored, partitions used and consumer groups are all read back from the HTTP API and the container logs.

## Stack

- **Rust 1.98, edition 2024** — the language the producer, the consumer and Iggy itself are written in.
- **iggy 0.10.0** — the official Rust SDK, the release that pairs with server 0.8.0.
- **apache/iggy 0.8.0** — the message streaming server, TCP and HTTP in one process.
- **apache/iggy-web-ui 0.3.0** — the official SvelteKit admin UI for browsing streams and messages.
- **podman 5 + podman-compose 1.5** — container engine and orchestration, no docker daemon.
- **tokio + futures-util** — the async runtime and the `Stream` adapter the consumer polls through.

## Contracts / APIs

The Rust apps speak the binary TCP protocol; the scripts and the Web UI speak HTTP.

| Surface | Endpoint | Purpose |
| --- | --- | --- |
| TCP | `iggy://iggy:iggy@iggy:8090` | The connection string the SDK parses; credentials are auto-login, transport is TCP. |
| `GET` | `/ping` | Returns `pong`. `start.sh` and `test.sh` block on this. |
| `POST` | `/users/login` | Exchanges username and password for the JWT the other calls need. |
| `GET` | `/streams/orders/topics/placed` | Topic details including `messages_count` and the per-partition breakdown. |
| `GET` | `/streams/orders/topics/placed/consumer-groups` | The consumer groups on the topic, used to prove `billing` was created. |
| `GET` | `/stats` | Server-wide counters, the same numbers the Web UI overview renders. |
| `GET` | `/metrics` | Prometheus metrics, enabled by default. |

The message payload is the contract between the two binaries:

```json
{"order_id":7,"customer":"customer-2","amount":17.99}
```

## Key data structures and design decisions

**The stream layout.** One stream, one topic, three partitions, one consumer group. `app/src/lib.rs` is the single place those names live, so the Rust code and the shell assertions cannot drift apart.

| Name | Kind | Why |
| --- | --- | --- |
| `orders` | stream | The namespace; created by the producer if missing. |
| `placed` | topic | 3 partitions, `NeverExpire`, server default max size. |
| `billing` | consumer group | Lets the consumer scale out later without changing the code. |

**Why the consumer counts to a target and stops.** `IggyConsumer` is an endless `Stream`. A POC needs a process that terminates so a script can assert on it, so the consumer stops at `IGGY_MESSAGE_COUNT` and exits 0. `init_retries(30, 1s)` lets it start before the producer has created the topic.

**Why the server runs unconfined.** Iggy 0.8.0 builds its runtime on io_uring. The podman default seccomp profile blocks `io_uring_setup` (the server fails with `os error 38`), and SELinux then denies it a second time (`os error 13`). `security_opt: seccomp=unconfined, label=disable` is what makes the server boot at all.

**Why the credentials are pinned.** Iggy 0.8.0 generates a random root password on first boot and prints it once to the log. `IGGY_ROOT_USERNAME` and `IGGY_ROOT_PASSWORD` pin it to `iggy` / `iggy` so the scripts and the UI can log in without scraping logs.

**Why `PUBLIC_IGGY_API_URL` points at localhost.** The Web UI calls the HTTP API from the browser, not from the server side, so it needs the published host address rather than the compose service name.

## How to run

```bash
./build.sh              # cargo build, cargo test, build the app image, pull the iggy images
./start.sh              # bring up the stack, produce and consume 20 messages
./test.sh               # the same run, with assertions on what the server stored
./ui.sh                 # open the web ui in the browser
./stop.sh               # stop everything, keep the data volume
./stop.sh --purge       # stop everything and delete the data volume
```

Message volume is configurable:

```bash
IGGY_MESSAGE_COUNT=200 ./test.sh
```

`test.sh` output:

```
[iggy-poc] topic orders/placed holds 0 messages before the run

iggy-poc results
  PASS  messages sent            expected 20 got 20
  PASS  messages received        expected 20 got 20
  PASS  messages stored          expected 20 got 20
  PASS  partitions used          expected 3 got 3
  PASS  consumer groups          expected 1 got 1
```

Access:

| What | Where |
| --- | --- |
| Web UI | http://localhost:3050/auth/sign-in |
| HTTP API | http://localhost:3000 |
| TCP | localhost:8090 |
| User / password | `iggy` / `iggy` |

## Printscreens

### Sign in

![sign in](printscreens/01-sign-in.png)

The Web UI at `localhost:3050`. It authenticates straight against the Iggy server's `/users/login` on `localhost:3000`, with the root credentials the compose file pinned.

### Overview

![overview](printscreens/02-overview.png)

The server counters after one run: 1 stream, 1 topic, 3 partitions, 3 segments, 20 messages and 1 consumer group. This is the same `/stats` payload the scripts read.

### Stream

![stream](printscreens/03-stream.png)

The `orders` stream and the topics inside it. `placed` holds all 20 messages across 3 partitions and never expires.

### Topic

![topic](printscreens/04-topic.png)

The partitions of `placed`. The producer's round robin put 7, 7 and 6 messages on partitions 0, 1 and 2, each in a single segment, which is exactly the split the consumer printed.

### Messages

![messages](printscreens/05-messages.png)

The 7 messages on partition 0 with their offsets, timestamps and checksums. Payloads are shown base64 encoded because Iggy stores raw bytes and never inspects them; decoded, each one is the order JSON above.
