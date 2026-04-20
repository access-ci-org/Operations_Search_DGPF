# =========================
# Base stage (shared)
# =========================
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app


# =========================
# Builder
# =========================
FROM base AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt


# =========================
# Runtime
# =========================
FROM base AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv
ENV APP_CONFIG="/app/local_settings.py"
ENV PATH="/opt/venv/bin:$PATH"

COPY . .

RUN useradd -m appuser && chown -R appuser /app
USER appuser

COPY --chmod=755 scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]