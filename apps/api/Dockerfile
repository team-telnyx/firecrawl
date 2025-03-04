# Base stage
FROM node:22-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

# Create a non-root user and group
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY . /app
WORKDIR /app

# Production dependencies stage
FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

# Build stage
FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install && pnpm run build

# Go build stage
FROM golang:1.24 AS go-base
COPY sharedLibs/go-html-to-md /app/sharedLibs/go-html-to-md
RUN cd /app/sharedLibs/go-html-to-md && \
    go mod tidy && \
    go build -o html-to-markdown.so -buildmode=c-shared html-to-markdown.go && \
    chmod +x html-to-markdown.so

# Rust build stage
FROM rust:1-slim AS rust-base
COPY sharedLibs/html-transformer /app/sharedLibs/html-transformer
RUN cd /app/sharedLibs/html-transformer && \
    cargo build --release && \
    chmod +x target/release/libhtml_transformer.so

# Final runtime stage
FROM base

# Ensure we are root for file operations
USER root

# Copy built artifacts
COPY --from=build /app/dist /app/dist
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=go-base /app/sharedLibs/go-html-to-md/html-to-markdown.so /app/sharedLibs/go-html-to-md/html-to-markdown.so
COPY --from=rust-base /app/sharedLibs/html-transformer/target/release/libhtml_transformer.so /app/sharedLibs/html-transformer/target/release/libhtml_transformer.so

# Ensure scripts have correct line endings
RUN sed -i 's/\r$//' /app/docker-entrypoint.sh

# Fix permissions: give appuser ownership of /app
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 8080

ENTRYPOINT ["/app/docker-entrypoint.sh"]
