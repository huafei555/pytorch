# 基于python的基础镜像
# FROM python:3.10.18
FROM tensorflow/tensorflow:2.20.0-gpu

RUN apt update && \
    apt install -y --no-install-recommends \
        git \
        build-essential \
        cmake \
        g++ \
        libgomp1 \
        wget \
        vim \
        libffi-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install -U prefect==3.4.14 -i https://pypi.tuna.tsinghua.edu.cn/simple
