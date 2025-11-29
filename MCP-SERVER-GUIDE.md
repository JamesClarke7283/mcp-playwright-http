# Introduction

This guide is made to help you setup a Playwright MCP server over http, to access in your n8n instance

# 1. Setup the environment

## 1.1 Setup Global Prefix (if done already skip)

We need `tsc` and `shx` binaries so we do this:

```shell
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$PATH:$HOME/.npm-global/bin/"' >> ~/.bashrc
```

## 1.2 Clone The repo

```shell
git clone https://github.com/JamesClarke7283/mcp-playwright-http.git
cd mcp-playwright-http
```

## 1.3 Install Dependencies

```shell
npm install --global typescript shx
npm install --omit=dev
```

# 2. Build The Docker Image

```shell
npm run build
docker build -t mcp-playwright-http .
```

# 3. Run the docker container

```shell
docker compose up -d
```

Your MCP server URL will be `http://0.0.0.0:8080/mcp`


