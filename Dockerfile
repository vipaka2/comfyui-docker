FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt update && apt install -y \
    git \
    wget \
    curl \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

WORKDIR /app/ComfyUI

RUN pip install --no-cache-dir \
    torch==2.1.0+cu121 \
    torchvision==0.16.0+cu121 \
    torchaudio==2.1.0+cu121 \
    --index-url https://download.pytorch.org/whl/cu121

RUN pip install --no-cache-dir -r requirements.txt

RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager

RUN mkdir -p models/checkpoints models/vae models/loras models/controlnet \
    models/clip_vision models/style_models models/embeddings \
    models/diffusers models/unet input output temp

RUN pip install --no-cache-dir \
    opencv-python \
    pillow \
    numpy \
    requests \
    tqdm \
    safetensors \
    transformers \
    accelerate

RUN pip install --no-cache-dir \
    xformers==0.0.22.post7 \
    --index-url https://download.pytorch.org/whl/cu121

EXPOSE 8188

ENV PYTHONPATH=/app/ComfyUI
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
