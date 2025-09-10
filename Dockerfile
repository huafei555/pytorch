# 基于python的基础镜像
FROM python:3.10.18
# FROM algorithm_base_image:prefect_3.4.14

# 安装必要的系统依赖

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

# WORKDIR /app
# COPY . /app/

# ENV TZ=Asia/Shanghai
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN pip install --upgrade pip && \
#     pip install --no-cache-dir -r requirements.txt

# RUN echo "a"
# ENV PREFECT_API_URL="https://admin:ajiotadmin@prefect.ajiot.net:58443/api"
# RUN pip install pyexecjs==1.5.1

# ENV POOL_NAME=""

# #CMD sh -c "prefect worker start --pool \"$POOL_NAME\""
# #ENTRYPOINT ["prefect", "worker", "start", "--pool"]
# CMD ["sh","-c",  "prefect worker start --pool $POOL_NAME"]