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


# 第一阶段：准备CUDA环境
FROM nvidia/cuda:12.8.1-devel-ubuntu24.04 as cuda-stage
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH  
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# 第二阶段：Python 3.10环境
FROM python:3.10.18-slim

# 从CUDA阶段复制CUDA工具包
COPY --from=cuda-stage /usr/local/cuda /usr/local/cuda

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
ENV TimeZone=Asia/Shanghai

# 安装必要的系统包
RUN apt-get update && apt-get install -y \
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

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

# 配置pip使用国内镜像源
RUN mkdir -p /root/.pip && \
    echo '[global]' > /root/.pip/pip.conf && \
    echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> /root/.pip/pip.conf && \
    echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> /root/.pip/pip.conf

# 验证Python版本（应该是3.10.18）
RUN python --version

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# 编译安装LightGBM GPU版本
RUN git clone --recursive https://github.com/microsoft/LightGBM /tmp/LightGBM && \
    cd /tmp/LightGBM && \
    cmake -B build -S . -DUSE_CUDA=ON && \
    cmake --build build -j$(nproc) && \
    cd python-package && \
    python setup.py install --precompile && \
    cd / && \
    rm -rf /tmp/LightGBM

# 验证安装
RUN python -c "import lightgbm as lgb; print('LightGBM version:', lgb.__version__)" && \
    python -c "import numpy as np; print('NumPy version:', np.__version__)" && \
    python -c "import pandas as pd; print('Pandas version:', pd.__version__)"

