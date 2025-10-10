FROM rust:1.90-slim as builder
WORKDIR /app
COPY Cargo.toml .
COPY src ./src
RUN cargo build --release
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/rust-webservice /usr/local/bin/rust-webservice
EXPOSE 8080
CMD ["rust-webservice"]
