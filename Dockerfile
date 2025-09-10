# # 基于python的基础镜像
# FROM python:3.10.18

# # 工作目录
# WORKDIR /app
# # 复制所有应用程序文件到工作目录
# COPY . /app/
# # 安装必要的系统依赖

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         git \
#         build-essential \
#         cmake \
#         g++ \
#         libgomp1 \
#         wget \
#         vim \
#         libffi-dev && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* && \
#     pip install --upgrade pip && \
#     pip install --no-cache-dir -r requirements.txt

# # 显示 Prefect 和 git 的版本
# CMD ["sh", "-c", "prefect --version && git --version"]

FROM registry.cn-beijing.aliyuncs.com/dkzx_test/prefect:3.4.14

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        cmake \
        g++ \
        libgomp1 \
        wget \
        vim \
        libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 更新仓库索引并安装 Node.js 和 npm
RUN apk update && \
    apk add --no-cache \
    nodejs \
    npm

# RUN pip install git+https://shengzhiwei:Shengzw0387.@gitea.ajiot.net/AEO/ods_trading_platform_common.git
RUN echo "a"
ENV PREFECT_API_URL="https://admin:ajiotadmin@prefect.ajiot.net:58443/api"
RUN pip install pyexecjs==1.5.1

ENV POOL_NAME=""

#CMD sh -c "prefect worker start --pool \"$POOL_NAME\""
#ENTRYPOINT ["prefect", "worker", "start", "--pool"]
CMD ["sh","-c",  "prefect worker start --pool $POOL_NAME"]