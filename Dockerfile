# 基于python的基础镜像
# FROM tensorflow/tensorflow:2.11.0-gpu
FROM python:3.10.16


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
        vim \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt
