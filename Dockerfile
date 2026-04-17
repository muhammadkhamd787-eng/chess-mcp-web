# Start from the official chess-mcp image (has Python + uv + all deps)
FROM pab1it0/chess-mcp

# Install Node.js so we can run supergateway
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install supergateway
RUN npm install -g supergateway

# Railway sets $PORT dynamically; default to 8000
EXPOSE 8000

# supergateway bridges the stdio MCP server to HTTP/SSE
# The chess-mcp image uses uv to run the server
CMD sh -c "supergateway \
  --stdio 'uv run src/chess_mcp/main.py' \
  --port ${PORT:-8000} \
  --baseUrl '' \
  --ssePath /sse \
  --messagePath /message"
