# # 基于python的基础镜像
# # FROM tensorflow/tensorflow:2.11.0-gpu
# FROM python:3.10.16


# # 工作目录
# WORKDIR /app
# # 复制所有应用程序文件到工作目录
# COPY . .
# # 安装必要的系统依赖
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         build-essential \
#         cmake \
#         g++ \
#         gcc \
#         git \
#         libgomp1 \
#         wget \
#         python3-pip \
#         vim \
#         && rm -rf /var/lib/apt/lists/*

# RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# GPU支持的LightGBM电价预测Docker镜像
FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
ENV TimeZone=Asia/Shanghai

# 更新包管理器并安装基础依赖
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    g++ \
    gcc \
    git \
    cmake \
    build-essential \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libboost-python-dev \
    libssl-dev \
    libffi-dev \
    libgomp1 \
    wget \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# 创建python3的软链接到python
RUN ln -sf /usr/bin/python3 /usr/bin/python

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# 克隆LightGBM源码并编译GPU版本
RUN git clone --recursive https://github.com/microsoft/LightGBM /tmp/LightGBM && \
    cd /tmp/LightGBM && \
    cmake -B build -S . -DUSE_CUDA=ON && \
    cmake --build build -j$(nproc) && \
    cd python-package && \
    python setup.py install --precompile && \
    cd / && \
    rm -rf /tmp/LightGBM
