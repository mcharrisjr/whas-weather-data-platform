FROM python:3.12-slim-bookwork AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

ENV UV_LINK_MODE=copy

WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --only-group dbt --no-install-project

COPY dbt/ dbt/


FROM python:3.12-slim-bookworm

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH" \
    DBT_PROJECT_DIR="/app/dbt" \
    DBT_PROFILES_DIR="/app/dbt"

CMD ["dbt", "debug"]
