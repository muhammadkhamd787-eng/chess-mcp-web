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

# Install supergateway
RUN npm install -g supergateway

# Clone chess-mcp and install its dependencies
RUN git clone https://github.com/pab1it0/chess-mcp /app
WORKDIR /app
RUN uv sync

EXPOSE 8000

CMD sh -c "supergateway \
  --stdio 'uv run src/chess_mcp/main.py' \
  --port ${PORT:-8000} \
  --baseUrl '' \
  --ssePath /sse \
  --messagePath /message"
