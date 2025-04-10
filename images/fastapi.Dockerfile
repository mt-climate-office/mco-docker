FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y cron && \
    apt-get install -y curl && \
    apt-get install -y libpq-dev && \
    apt-get install -y gcc && \
    rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables with defaults that can be overridden
ENV APP_DIR=/app \
    APP_MODULE=main.py \
    APP_PATH="" \
    PORT=8000

# Copy the application into the container
COPY . ${APP_DIR}

# Install the application dependencies
WORKDIR ${APP_DIR}
RUN uv sync --frozen --no-cache

# Run the application
CMD /app/.venv/bin/fastapi run ${APP_PATH:+${APP_PATH}/}${APP_MODULE} --port ${PORT} --host 0.0.0.0
