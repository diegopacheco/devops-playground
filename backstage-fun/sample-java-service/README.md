# Sample Java Service

Sample Java Spring Boot microservice created from Backstage template.

## Build

```bash
./mvnw clean package
```

## Run

```bash
./mvnw spring-boot:run
```

## Test

```bash
curl http://localhost:8080/api/hello
curl http://localhost:8080/api/health
```

## Endpoints

* GET /api/hello - Returns greeting message
* GET /api/health - Health check endpoint
