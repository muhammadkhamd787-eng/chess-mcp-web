FROM python:3.12-slim

# Install curl and git
RUN apt-get update && apt-get install -y \
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

# Install mcp-proxy
RUN pip install mcp-proxy

EXPOSE 8080

CMD sh -c "mcp-proxy \
  --port ${PORT:-8080} \
  --allow-origin '*' \
  -- /root/.local/bin/uv run src/chess_mcp/main.py"
