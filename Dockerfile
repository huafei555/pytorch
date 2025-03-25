# 基于python的基础镜像
# FROM tensorflow/tensorflow:2.11.0-gpu
# FROM python:3.10.16
# FROM pytorch/pytorch:2.6.0-cuda11.8-cudnn9-devel
FROM tensorflow/tensorflow:2.15.0-gpu


# 工作目录
WORKDIR /app
# 复制所有应用程序文件到工作目录
COPY . .
# 安装必要的系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        g++ \
        gcc \
        git \
        libgomp1 \
        wget \
        python3-pip \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

