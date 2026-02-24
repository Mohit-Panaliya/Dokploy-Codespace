# Dokploy Deployment on GitHub Codespaces

## Overview

This is a minimal configuration project for deploying Dokploy on GitHub Codespaces. Instead of including the entire Dokploy source code, this project provides scripts and configuration to clone and set up Dokploy automatically.

## Prerequisites

- GitHub account with Codespaces enabled
- Internet connection (for cloning the Dokploy repository)

## Quick Start

### Option 1: Using GitHub.dev (Recommended for Small Changes)

1. **Open this repository in GitHub.dev**
2. **Click the "Source Control" icon** on the left sidebar
3. **Commit your changes** if you made any modifications
4. **Click "Sync Changes"** to push to your forked repository
5. **From your forked repository on GitHub.com**, click "Code" → "Open with Codespaces"

### Option 2: Directly from GitHub.com

### Step 1: Create Your Codespace

1. **Fork this repository** to your GitHub account
2. Go to your forked repository
3. Click the green "Code" button
4. Select "Open with Codespaces"
5. Click "New codespace"
6. Choose a machine type (**2-core or higher recommended**)
7. Wait for the codespace to initialize (2-5 minutes)

### Step 2: Run the Deployment Script

Once your codespace is ready:

```bash
# Make the script executable
chmod +x deploy-codespaces.sh

# Run the deployment
./deploy-codespaces.sh
```

The script will:
- ✅ Check if you're in a GitHub Codespace
- ✅ Clone the Dokploy repository (if not already present)
- ✅ Install all dependencies
- ✅ Set up the application (database, configuration)

### Step 3: Start the Development Server

```bash
cd dokploy
pnpm dokploy:dev
```

### Step 4: Access Dokploy

- Click the "Ports" tab on the bottom right
- Find port 3000 (labeled "Dokploy App")
- Click "Open in Browser"

## Project Structure

```
dokploy-codespaces/
├── .devcontainer/          # GitHub Codespaces configuration
│   ├── devcontainer.json  # Dev container configuration
│   └── Dockerfile         # Dockerfile for the dev container
├── .github/
│   └── workflows/
│       └── deploy-codespaces.yml  # GitHub Action for validation
├── deploy-codespaces.sh    # Deployment script
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## Configuration Details

### Dev Container Features

- **Node.js 20** - JavaScript runtime
- **pnpm** - Package manager
- **Docker-in-Docker** - For container management
- **Git** - Version control
- **Go 1.20** - For monitoring service

### Forwarded Ports

- **3000** - Dokploy web application
- **5432** - PostgreSQL database
- **6379** - Redis cache

## Customization

### Modifying the Script

Edit `deploy-codespaces.sh` to customize the deployment:

- Change the repository URL: `https://github.com/Dokploy/dokploy.git`
- Modify installation steps
- Adjust configuration options

### Environment Variables

Create a `.env` file in the `dokploy` directory:

```env
DATABASE_URL="postgresql://username:password@localhost:5432/dokploy"
REDIS_URL="redis://localhost:6379"
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="http://localhost:3000"
```

## GitHub Action

The `.github/workflows/deploy-codespaces.yml` file validates the configuration:
- Checks if the dev container configuration is valid
- Verifies the deployment script is executable
- Ensures all required files are present

## Limitations

- **Codespace Idle Time**: Codespaces auto-suspend after 30 minutes
- **Storage Limits**: Free tier has 15GB storage limit
- **Performance**: Depends on the selected machine type
- **Data Persistence**: Changes are not persistent across codespace lifetime

## Best Practices

### For Development

1. Commit changes to your forked repository
2. Use branches for experiments
3. Monitor resource usage
4. Clean up unused codespaces

### For Production

**GitHub Codespaces is for development only**. For production deployment:
1. Self-host on a cloud provider (AWS, DigitalOcean, Vultr)
2. Use Docker Compose or Kubernetes
3. Set up persistent storage
4. Implement security measures

## License

MIT License - see LICENSE file for details

## Support

- [Dokploy Documentation](https://dokploy.com/docs)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [Dokploy Issues](https://github.com/Dokploy/dokploy/issues)
