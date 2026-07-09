FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV MUJOCO_GL=glfw

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    cmake \
    git \
    ffmpeg \
    patchelf \
    swig \
    \
    libgl1 \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libglu1-mesa \
    libglew-dev \
    libglfw3 \
    libglfw3-dev \
    \
    libx11-6 \
    libx11-dev \
    libxext6 \
    libxrender1 \
    libxi6 \
    libxrandr2 \
    libxcursor1 \
    libxinerama1 \
    libxxf86vm1 \
    libsm6 \
    libice6 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    \
    libsdl2-2.0-0 \
    libsdl2-dev \
    libsdl2-image-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libsdl2-ttf-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip setuptools wheel

RUN pip install torch==2.9.1 \
    --index-url https://download.pytorch.org/whl/cpu

RUN pip install \
    numpy==1.26.4 \
    mujoco==3.4.0 \
    robosuite==1.5.2 \
    gymnasium==1.2.3 \
    stable_baselines3==2.7.1 \
    sb3_contrib==2.7.1 \
    rl_zoo3==2.7.0 \
    imageio==2.37.2 \
    imageio-ffmpeg \
    pygame==2.6.1 \
    glfw==2.10.0 \
    PyOpenGL==3.1.10 \
    matplotlib==3.10.8 \
    opencv-python-headless==4.11.0.86 \
    pandas==2.3.3 \
    scipy==1.17.0 \
    h5py==3.15.1 \
    tqdm==4.67.1 \
    requests==2.32.5 \
    PyYAML==6.0.3 \
    cloudpickle==3.1.2 \
    shimmy==2.0.0 \
    optuna==4.7.0 \
    huggingface-sb3==3.0 \
    huggingface-hub==0.36.0

CMD ["python"]
