# 基于python的基础镜像
FROM python:3.10.18

# 工作目录
WORKDIR /app
# 复制所有应用程序文件到工作目录
COPY . /app/
# 安装必要的系统依赖

RUN apk update && \
    apk add --no-cache git build-base gcc musl-dev libffi-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN apt-get update && \
    apk add --no-cache git build-base gcc musl-dev libffi-dev && \
    build-essential \
    cmake \
    g++ \
    libgomp1 \
    wget \
    vim \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 显示 Prefect 和 git 的版本
CMD ["sh", "-c", "prefect --version && git --version"]
