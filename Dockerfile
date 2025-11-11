# Multi-stage Dockerfile for MCP Playwright Server
# This Dockerfile expects the project to be built before running docker build
# Run `npm install --omit=dev && npm run build` before building the image

FROM node:20-slim

# Set working directory
WORKDIR /app

# Copy package files for reference
COPY package*.json ./

# Copy node_modules from host (production dependencies only)
# Make sure to run `npm install --omit=dev` before building
COPY node_modules ./node_modules

# Copy the pre-built application
COPY dist ./dist

# Install Python and required system dependencies for mcp-proxy and Playwright
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    ca-certificates \
    xvfb \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create isolated virtual environment for mcp-proxy
RUN python3 -m venv /opt/mcp-proxy-venv \
    && /opt/mcp-proxy-venv/bin/pip install --no-cache-dir mcp-proxy

# Install Playwright browsers (chromium, firefox, webkit) with dependencies
RUN npx playwright install --with-deps chromium firefox webkit

# Environment defaults for HTTP exposure and browser selection
ENV MCP_PROXY_HOST=0.0.0.0
ENV MCP_PROXY_PORT=8080
# Comma-separated list; e.g. "chromium", "firefox", "webkit"
ENV PLAYWRIGHT_BROWSERS=chromium,firefox,webkit
# Extra args passed through to mcp-proxy, e.g. "--log-level debug"
ENV MCP_PROXY_EXTRA_ARGS=

# Expose HTTP port for mcp-proxy
EXPOSE 8080

# Start MCP server on stdio and expose via mcp-proxy HTTP endpoint.
# We rely on Dockerfile ENV defaults so values are concrete, not shell placeholders.
CMD ["/opt/mcp-proxy-venv/bin/python", "-m", "mcp_proxy", "--host", "0.0.0.0", "--port", "8080", "node", "dist/index.js"]
