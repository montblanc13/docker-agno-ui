# Dockerfile for building and running the Agent UI (Next.js app) from repository root

### ---- Builder Stage ----
FROM node:20-alpine AS builder
WORKDIR /app

# Install git, enable Corepack and install pnpm
RUN apk add --no-cache git \
    && corepack enable \
    && corepack prepare pnpm@latest --activate

# Clone the Agent UI repository and remove Git metadata
RUN git clone --depth 1 https://github.com/agno-agi/agent-ui.git . \
    && rm -rf .git

# Install dependencies, build, and prune dev dependencies
RUN pnpm install --frozen-lockfile \
    && pnpm run build \
    && pnpm prune --prod

### ---- Production Stage ----
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy built assets and production node_modules from the builder
COPY --from=builder /app ./

# Expose the port the app runs on
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "run", "start"]