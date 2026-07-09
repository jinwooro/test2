FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV UV_NO_CACHE=1
ENV MUJOCO_GL=glfw
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc g++ cmake git ffmpeg patchelf unzip \
    libgl1 libgl1-mesa-dev libgl1-mesa-dri libglu1-mesa \
    libglew-dev libglfw3 libglfw3-dev \
    libx11-6 libx11-dev libxext6 libxrender1 libxi6 libxrandr2 \
    libxcursor1 libxinerama1 libxxf86vm1 libsm6 libice6 \
    libxkbcommon0 libxkbcommon-x11-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

COPY src ./src
RUN uv sync --frozen --no-dev

CMD ["run-bundle"]
