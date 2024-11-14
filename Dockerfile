# 基于python的基础镜像
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
# 工作目录
WORKDIR /app
# 复制所有应用程序文件到工作目录
COPY . .

#安装依赖

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt
RUN pip install lightgbm --install-option=--no-cython-compile
# 清理未使用的缓存和临时文件
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
