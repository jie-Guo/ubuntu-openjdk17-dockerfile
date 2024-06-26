FROM ubuntu:22.04

WORKDIR /app

# 离线版本
# https://github.com/opencv/opencv/releases/tag/4.9.0
# ADD opencv-4.9.0.tar.gz

# 在线版本
# https://hub.docker.com/_/ubuntu
RUN apt update && apt full-upgrade -y && DEBIAN_FRONTEND=noninteractive apt install -y locales tzdata wget pkg-config openjdk-17-jdk cmake g++ \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
        && echo "Asia/Shanghai" > /etc/timezone \
        && wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/refs/tags/4.9.0.tar.gz \
        && tar -zxf opencv.tar.gz && rm -f opencv.tar.gz 

# 字符集、时区 环境变量
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
ENV TZ=Asia/Shanghai

# JAVA环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${JAVA_HOME}/bin:$PATH

# ffmpeg + opencv
RUN apt -y install ffmpeg libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libpostproc-dev libswresample-dev libswscale-dev \
        && mv opencv* opencv && mkdir build && cd build \
        && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTS=OFF ../opencv \
        && make && make install \
        && rm -rf /var/lib/apt/lists/* && rm -rf /app/*

CMD ["/bin/bash"]
