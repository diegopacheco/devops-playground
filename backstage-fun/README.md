# Backstage Fun

Running Backstage locally using podman with Kind Kubernetes cluster integration.

## Prerequisites

* podman installed
* kind installed
* kubectl installed
* Port 7007 available

## Structure

```
├── catalog/           # Backstage catalog entities
│   ├── all.yaml       # Location file pointing to all entities
│   ├── apis.yaml      # API definitions
│   ├── components.yaml # Service components
│   ├── groups.yaml    # Team groups
│   └── systems.yaml   # Systems and domains
├── k8s/               # Kubernetes manifests
│   ├── backstage-sa.yaml  # Service account for Backstage
│   └── services.yaml      # Sample service deployments
├── templates/         # Software templates
│   └── java-service/  # Java Spring Boot template
├── app-config.yaml    # Backstage configuration
├── kind-config.yaml   # Kind cluster configuration
├── run.sh             # Start everything
├── stop.sh            # Stop and cleanup
└── test.sh            # Verify setup
```

## How to Run

```bash
./run.sh
```

This will:
1. Create a Kind cluster named `backstage-cluster`
2. Deploy sample services to the cluster
3. Start kubectl proxy for Kubernetes API access
4. Run Backstage with catalog and Kubernetes integration

## Access

* Backstage UI: http://localhost:7007
* Software Catalog: http://localhost:7007/catalog
* Create from Template: http://localhost:7007/create
* Kubernetes view: Click on any component and go to the Kubernetes tab

## Components

The catalog includes:
* **orders-service** - Order processing (Java/Spring Boot)
* **inventory-service** - Inventory management (Java/Spring Boot)
* **payments-service** - Payment processing (Go)
* **users-service** - User management (Python/FastAPI)
* **web-frontend** - Web application (React/TypeScript)

## Test

```bash
./test.sh
```

## Stop

```bash
./stop.sh
```

This will delete the Kind cluster and stop the kubectl proxy.
