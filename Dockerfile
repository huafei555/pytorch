# 基于python的基础镜像
# FROM tensorflow/tensorflow:2.11.0-gpu
FROM python:3.10.18
# FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime

# 工作目录
WORKDIR /app
# 复制所有应用程序文件到工作目录
COPY . .
# 安装必要的系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    gcc \
    git \
    libgomp1 \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*
# 更新pip
RUN pip install --upgrade pip
# 安装依赖
RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt
# 验证Python环境
RUN python --version && pip --version
