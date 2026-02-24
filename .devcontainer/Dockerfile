FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:20-bullseye

# Install pnpm
RUN npm install -g pnpm

# Install Docker CLI
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" && \
    apt-get update && apt-get install -y docker-ce-cli

# Install Go
RUN wget -O go.tgz https://go.dev/dl/go1.20.14.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tgz && \
    rm go.tgz

ENV PATH="/usr/local/go/bin:${PATH}"

# Install build dependencies to avoid node-pty installation issues
RUN apt-get install -y \
    build-essential \
    python3 \
    libsecret-1-dev

# Set up workspace
WORKDIR /workspaces/dokploy-codespaces
