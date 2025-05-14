# docker-agno-ui
Dockerized Agno Playground UI

## Overview

This project provides a Docker container and network setup for the Agno Playground (Agent UI). It packages the Agno Agent UI (Next.js application) into a multi-stage Docker image and orchestrates it with Docker Compose.

The goal is to create an isolated Docker network where multiple agent containers can communicate and be managed through the Playground UI.

## Architecture

- **Dockerfile**: Clones the `https://github.com/agno-agi/agent-ui.git` repository, installs dependencies via pnpm, builds the Next.js app, and prunes dev dependencies for production.
- **docker-compose.yml**: Defines the `agent-ui` service on the `agents-net` bridge network and mounts a `logs/` directory for runtime logs.
- **.dockerignore**: Excludes unnecessary files (source, build artifacts, node_modules) from the Docker build context.

## Prerequisites

- Docker (>= 20.x)
- Docker Compose (>= 1.27 or v2+)

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/agno-agi/docker-agno-ui.git
   cd docker-agno-ui
   ```
2. Create a directory for logs (optional but recommended):
   ```bash
   mkdir -p logs
   ```
3. Start the Playground UI container:
   ```bash
   docker-compose up -d --build
   ```
4. Open your browser and navigate to `http://localhost:3000` to access the Agno Playground UI.

## Adding Custom Agents

You can deploy additional agent containers into the same Docker network (`agents-net`) so the Playground UI can discover and interact with them.

1. Build or pull your agent Docker image.
2. Run your agent on `agents-net`:
   ```bash
   docker run -d \
     --name my-agent \
     --network agents-net \
     my-agent-image:latest
   ```
3. The Agno Playground UI will automatically detect agents on the network and allow you to manage them.

## Logs

Application logs produced by the UI container are stored on the host in the `logs/` directory.

## Customization

- To change the UI port, edit the `ports` mapping in `docker-compose.yml`.
- To pin the Agent UI to a specific version, update the `git clone` URL (or branch/tag) in the `Dockerfile`.

## Cleanup

To stop and remove containers, network, and volumes:
```bash
docker-compose down
docker network rm docker-agno-ui_agents-net  # if needed
```  



> **Author** : Sébastien LANDEAU