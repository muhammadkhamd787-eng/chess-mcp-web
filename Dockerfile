FROM node:20-slim

# Install Python, pip, curl, git
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Clone chess-mcp and install its dependencies
RUN git clone https://github.com/pab1it0/chess-mcp /app
WORKDIR /app
RUN uv sync

# Install supergateway
RUN npm install -g supergateway@0.10.1

EXPOSE 8080

ENV PATH="/root/.local/bin:$PATH"

CMD sh -c "supergateway \
  --stdio '/root/.local/bin/uv run src/chess_mcp/main.py' \
  --port ${PORT:-8080} \
  --baseUrl '' \
  --ssePath /sse \
  --messagePath /message"
