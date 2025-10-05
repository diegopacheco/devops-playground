# Vault Secrets Kubernetes Integration

HashiCorp Vault integration with Kubernetes for secret management using Kind cluster.

## Prerequisites

- Docker
- Kind
- kubectl
- Helm
- Go 1.21+
- jq

## Project Structure

```
.
├── kind-config.yaml          # Kind cluster configuration
├── vault-setup.sh           # Vault installation and configuration
├── main.go                  # Go application
├── go.mod                   # Go module file
├── Dockerfile              # Application container image
├── specs/                  # Kubernetes manifests
│   ├── service-account.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── run.sh                  # Setup and deployment script
├── test.sh                 # Test script
└── shutdown.sh             # Cleanup script
```

## Setup

Run the setup script to create the cluster, install Vault, and deploy the application:

```bash
./run.sh
```

This will:
1. Create a Kind cluster with port forwarding
2. Install HashiCorp Vault in dev mode
3. Configure Vault with Kubernetes auth
4. Create secrets in Vault
5. Build and deploy the Go application
6. Expose the application on port 8080

## Testing

Test the application:

```bash
./test.sh
```

This retrieves and displays the secret from Vault via the application endpoint.

## Access

- Application: http://localhost:8080
- Vault UI: http://localhost:8200 (token: root)

## Endpoints

- `GET /secret` - Retrieve secrets from Vault
- `GET /health` - Health check

## Cleanup

Destroy the cluster:

```bash
./shutdown.sh
```

## How It Works

1. Vault Agent Injector injects a sidecar container into the application pod
2. The sidecar authenticates to Vault using the Kubernetes service account
3. Vault Agent writes the authentication token to `/vault/secrets/token`
4. The Go application reads the token and makes API calls to Vault
5. Secrets are retrieved from the `secret/myapp/config` path
