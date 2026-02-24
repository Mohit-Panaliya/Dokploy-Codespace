#!/bin/bash

# Dokploy Deployment Script for GitHub Codespaces
# Based on official Dokploy installation documentation: https://docs.dokploy.com/docs/core/installation

set -e

echo "========================================="
echo "Dokploy Deployment on GitHub Codespaces"
echo "========================================="
echo

# Check if running in GitHub Codespaces
if [ -z "$CODESPACES" ]; then
    echo "Error: This script is intended to run in GitHub Codespaces"
    exit 1
fi

# Step 1: Clone Dokploy repository if not already present
if [ ! -d "dokploy" ]; then
    echo "Step 1: Cloning Dokploy repository..."
    git clone https://github.com/Dokploy/dokploy.git dokploy
    cd dokploy
else
    echo "Step 1: Dokploy repository already exists"
    cd dokploy
fi

# Step 2: Apply GitHub Codespaces compatibility fixes
echo "Step 2: Applying GitHub Codespaces compatibility fixes..."

# Fix PostgreSQL connection to use container name instead of localhost
cat > packages/server/src/db/constants.ts << 'EOF'
import fs from "node:fs";

export const {
	DATABASE_URL,
	POSTGRES_PASSWORD_FILE,
	POSTGRES_USER = "dokploy",
	POSTGRES_DB = "dokploy",
	POSTGRES_HOST = "dokploy-postgres",
	POSTGRES_PORT = "5432",
} = process.env;

function readSecret(path: string): string {
	try {
		return fs.readFileSync(path, "utf8").trim();
	} catch {
		throw new Error(`Cannot read secret at ${path}`);
	}
}
export let dbUrl: string;
if (DATABASE_URL) {
	dbUrl = DATABASE_URL;
} else if (POSTGRES_PASSWORD_FILE) {
	const password = readSecret(POSTGRES_PASSWORD_FILE);
	dbUrl = `postgres://${POSTGRES_USER}:${encodeURIComponent(
		password,
	)}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}`;
} else {
	if (process.env.NODE_ENV !== "test") {
		console.warn(`
		⚠️  [DEPRECATED DATABASE CONFIG]
		You are using the legacy hardcoded database credentials.
		This mode WILL BE REMOVED in a future release.
		
		Please migrate to Docker Secrets using POSTGRES_PASSWORD_FILE.
		Please execute this command in your server: curl -sSL https://dokploy.com/security/0.26.6.sh | bash
		`);
	}

	if (process.env.NODE_ENV === "production") {
		dbUrl =
			"postgres://dokploy:amukds4wi9001583845717ad2@dokploy-postgres:5432/dokploy";
	} else {
		if (process.env.CODESPACES === "true") {
			dbUrl =
				"postgres://dokploy:amukds4wi9001583845717ad2@dokploy-postgres:5432/dokploy";
		} else {
			dbUrl =
				"postgres://dokploy:amukds4wi9001583845717ad2@localhost:5432/dokploy";
		}
	}
}
EOF

# Fix Redis connection to use container name instead of localhost
cat > apps/dokploy/server/queues/redis-connection.ts << 'EOF'
import type { ConnectionOptions } from "bullmq";

export const redisConfig: ConnectionOptions = {
	host:
		process.env.NODE_ENV === "production" || process.env.CODESPACES === "true"
			? process.env.REDIS_HOST || "dokploy-redis"
			: "127.0.0.1",
};
EOF

echo "✅ Compatibility fixes applied"

# Step 3: Install dependencies
echo "Step 3: Installing dependencies..."
npm install -g pnpm
pnpm install

# Step 4: Initialize Docker Swarm and setup application
echo "Step 4: Setting up application..."
pnpm dokploy:setup

echo
echo "========================================="
echo "Deployment completed successfully!"
echo "========================================="
echo
echo "To start the development server:"
echo "  cd dokploy"
echo "  pnpm dokploy:dev"
echo
echo "The application will be available at:"
echo "  http://localhost:3000"
echo "or via the forwarded port in your codespace"
echo
echo "For more information, see README.md"
