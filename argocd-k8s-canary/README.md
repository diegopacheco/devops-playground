# argocd-k8s-canary

A self-contained playground for **GitOps + progressive delivery** on a local
[kind](https://kind.sigs.k8s.io/) cluster, using **Argo CD** for sync/visibility
and **Argo Rollouts** for canary deployments.

Every deploy is a **canary** by design — there is no plain `Deployment` resource
anywhere in this project.

---

## What you get

| Script       | What it does                                                              |
| ------------ | ------------------------------------------------------------------------- |
| `start.sh`   | Boots a kind cluster, installs Argo CD + Argo Rollouts, creates namespace |
| `canary.sh`  | Builds the Java app, loads it into kind, triggers a new canary release   |
| `ui.sh`      | Port-forwards the Argo CD UI and (if installed) Argo Rollouts dashboard   |
| `stop.sh`    | Deletes the kind cluster                                                  |

The workload is a tiny **Java 25 + Spring Boot 4.0.6** service that returns its
own version, so canary stages are visually distinguishable from `curl` output.

---

## Layout

```
argocd-k8s-canary/
├── start.sh / stop.sh / ui.sh / canary.sh
├── app/                      Java 25 + Spring Boot 4.0.6
│   ├── pom.xml
│   ├── Containerfile         podman build target
│   └── src/main/java/com/example/App.java
└── spec/                     everything kubectl ever applies
    ├── kind-config.yaml
    ├── namespace.yaml
    ├── service.yaml
    └── rollout.yaml          Argo Rollout (canary strategy lives here)
```

---

## Prerequisites

- `podman` + `podman-machine` running
- `kind` (`brew install kind`)
- `kubectl`
- *(optional but recommended)* `kubectl argo rollouts` plugin
  — install: <https://argoproj.github.io/argo-rollouts/installation/#kubectl-plugin-installation>

The scripts set `KIND_EXPERIMENTAL_PROVIDER=podman` so kind drives podman, not Docker.

---

## Quick start

```bash
./start.sh        # ~2 min: cluster + argocd + argo-rollouts
./canary.sh       # ~2 min first time: maven build + image load + first rollout
./ui.sh           # open the UIs (leave running)
```

Then in another terminal:

```bash
kubectl -n canary-app port-forward svc/canary-app 9000:80
curl localhost:9000     # {"version":"vNNNN","hostname":"canary-app-..."}
```

Every subsequent `./canary.sh` produces a **new** image tag (`v$(date +%s)`)
and triggers a fresh canary rollout.

To watch a canary unfold in the terminal:

```bash
kubectl argo rollouts get rollout canary-app -n canary-app --watch
```

---

## How Argo CD works (and what it does NOT do)

Argo CD is a **GitOps reconciler**. Its job:

1. Watch a source of truth (a git repo, or in our case `spec/` applied directly).
2. Compare the live cluster state against the desired state.
3. Show `Synced` / `OutOfSync` and `Healthy` / `Degraded` per resource.
4. Re-apply or roll back on demand.

What Argo CD **does not** do on its own:

- It does **not** implement canary or blue/green.
- It does **not** split traffic.
- It does **not** auto-promote or pause.

A vanilla `Deployment` managed by Argo CD will do a regular k8s rolling update
— `maxSurge`/`maxUnavailable`, nothing more. To get *progressive* delivery you
need a controller that understands traffic shaping and pause gates — that's
Argo Rollouts.

In this project Argo CD is present so you can **see and reconcile** the canary,
not to drive it.

---

## How Argo Rollouts works

Argo Rollouts adds a CRD called **`Rollout`** that replaces `Deployment`.
A `Rollout` looks almost identical to a `Deployment`, but its `spec.strategy`
field can be `canary` or `blueGreen`.

When the pod template changes (e.g. you change `image:`), the controller:

1. Creates a **new ReplicaSet** for the new version (the **canary**) alongside
   the existing **stable** ReplicaSet.
2. Walks the `steps:` list in order, executing each step:
   - `setWeight: N`  → scale the canary RS to N% of replicas.
   - `pause: {duration: 30s}` → wait 30s, then continue.
   - `pause: {}`     → wait **forever** until a human runs
     `kubectl argo rollouts promote canary-app`.
3. When the last step finishes, the canary RS becomes the new stable RS and
   the old one is scaled to zero.

If a readiness probe fails or you run
`kubectl argo rollouts abort canary-app`, the rollout halts and the stable
RS keeps serving 100% of traffic.

### Our strategy (`spec/rollout.yaml`)

```yaml
strategy:
  canary:
    steps:
    - setWeight: 20
    - pause: {duration: 30s}
    - setWeight: 50
    - pause: {duration: 30s}
    - setWeight: 100
```

With 5 replicas:

| Stage | Canary pods | Stable pods | Curl mix (approx) |
| ----- | ----------- | ----------- | ----------------- |
| start |     1 (20%) |     4       | 1 of 5 returns new version |
| 30s   |     3 (50%) |     2 (round-up of 50%) | ~half new |
| 60s   |     5 (100%)|     0       | all new           |

> **Note on traffic split without a service mesh:** with a plain k8s `Service`,
> "20% canary" really means *"20% of the pods are canary"*. The kube-proxy
> round-robins across endpoints, so traffic share ≈ pod share. For true
> request-level weighting (e.g. 5% canary with 100 pods) you'd wire in a mesh
> (Istio, Linkerd) or an ingress controller (NGINX, ALB) and reference it in
> `strategy.canary.trafficRouting`. We keep it simple here.

---

## "Do I need `canary.sh`, or can I do everything in the UI?"

You **can** trigger a canary purely from the Argo CD UI by editing the manifest
and clicking **Sync** — but for a working playground you still need a script
that:

1. **Builds a new image tag** (the UI cannot build code).
2. **Loads it into kind** (kind doesn't pull from a registry by default).
3. **Bumps the image reference** in the live cluster.

That's what `canary.sh` does. The *strategy* (steps, pauses, weights) lives
permanently in `spec/rollout.yaml` — so every release through Argo CD is
**automatically** a canary. `canary.sh` is the trigger; the canary policy is
declarative.

If you later push `spec/` to a real git repo and create an `Application` CR
pointing at it, the only thing `canary.sh` would still need to do is build +
load the image and bump the tag in git — Argo CD would pick up the change and
sync it.

---

## Seeing the canary in the UIs

You will use **two** UIs side by side:

### 1. Argo CD UI — `https://localhost:8080`

- Login: `admin` / *(password printed by `ui.sh`)*
- Argo CD shows the cluster's resources and their sync/health state.
- The `Rollout` resource appears as a custom resource. Drill in to see the
  **two ReplicaSets** — one labeled `stable`, one labeled the canary hash.
- Pod count per ReplicaSet reflects the current canary weight.

**Where to screenshot:**
1. *Application tree view* — shows `Rollout → ReplicaSet (stable) + ReplicaSet (canary) → pods`.
2. *Sync status badge* — `Synced / Healthy` during a canary, `Progressing`
   while the rollout is mid-flight.

### 2. Argo Rollouts dashboard — `http://localhost:3100/rollouts`

This is the **canary-specific** UI. It shows what Argo CD cannot:

- The canary **step progression bar** (which step you're on, how long left).
- Stable vs canary **replica counts and percentages**.
- A **`PROMOTE`** button for `pause: {}` steps.
- An **`ABORT`** button to immediately roll back.

**Where to screenshot:**
1. *During step 1 (`setWeight: 20`)* — bar at 20%, 1 canary + 4 stable pod chips.
2. *During the 30s `pause`* — countdown visible.
3. *During step 3 (`setWeight: 50`)* — 50% mark, 3 canary chips.
4. *After step 5 (`setWeight: 100`)* — single ReplicaSet, "stable".

### Reproducing the screenshots

```bash
./start.sh
./canary.sh                  # first deploy = v1
./ui.sh                      # leave running
# in another terminal:
./canary.sh                  # second deploy = canary kicks off
kubectl argo rollouts get rollout canary-app -n canary-app --watch
```

While `--watch` runs, switch to your browser and capture the dashboard at
each stage. Total observable window is ~70s (20% + 30s + 50% + 30s + 100%),
so don't blink.

---

## Cheat sheet

```bash
kubectl argo rollouts get rollout canary-app -n canary-app
kubectl argo rollouts get rollout canary-app -n canary-app --watch
kubectl argo rollouts pause   canary-app -n canary-app
kubectl argo rollouts promote canary-app -n canary-app
kubectl argo rollouts abort   canary-app -n canary-app
kubectl argo rollouts set image canary-app -n canary-app app=canary-app:vNEW

kubectl -n canary-app get rs
kubectl -n canary-app get pods -L rollouts-pod-template-hash
```

## Cleanup

```bash
./stop.sh
```
