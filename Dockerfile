# 基于python的基础镜像
FROM python:3.9-slim
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
        && rm -rf /var/lib/apt/lists/*
#安装依赖

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt
# 清理未使用的缓存和临时文件
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
