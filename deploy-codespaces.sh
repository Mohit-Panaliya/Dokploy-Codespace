#!/bin/bash

# Dokploy Deployment Script for GitHub Codespaces
# This script clones the Dokploy repository and sets it up

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

# Clone Dokploy repository if not already present
if [ ! -d "dokploy" ]; then
    echo "Step 1: Cloning Dokploy repository..."
    git clone https://github.com/Dokploy/dokploy.git dokploy
    cd dokploy
else
    echo "Step 1: Dokploy repository already exists"
    cd dokploy
fi

echo "Step 2: Verifying requirements..."
if ! command -v pnpm &> /dev/null; then
    echo "Error: pnpm is not installed"
    exit 1
fi

echo "Step 3: Installing dependencies..."
pnpm install

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
