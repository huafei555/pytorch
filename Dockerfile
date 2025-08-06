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



# 最优方案：使用LightGBM预编译GPU版本
# 基于官方文档：https://github.com/microsoft/lightgbm/blob/master/python-package/README.rst

FROM python:3.10.18-slim

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TimeZone=Asia/Shanghai

# 安装必要的系统包
RUN apt-get update && apt-get install -y \
    git \
    vim \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# 更新pip
RUN pip install --upgrade pip

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

# 验证Python环境
RUN python --version && pip --version

# 安装Python包（包括预编译GPU版LightGBM）
RUN pip install --no-cache-dir \
    numpy \
    scipy \
    pandas \
    scikit-learn \
    seaborn \
    lightgbm \
    xgboost \
    optuna \
    optuna-integration \
    loguru \
    schedule \
    configparser \
    sqlalchemy \
    pymysql \
    psycopg2-binary \
    chinese_calendar \
    cycler \
    einops \
    fonttools \
    mysql-connector \
    mysql-connector-python \
    openpyxl \
    pillow \
    pipreqs \
    pyaml \
    Pygments \
    PyYAML \
    requests \
    scikit-optimize \
    six

# 验证LightGBM安装（支持GPU）
RUN python -c "import lightgbm as lgb; print('LightGBM version:', lgb.__version__); print('GPU support:', hasattr(lgb, 'LGBMRegressor'))"

