FROM ubuntu:22.04

WORKDIR /app

# https://github.com/opencv/opencv/releases/tag/4.9.0
# ADD opencv-4.9.0.tar.gz
RUN apt update && apt full-upgrade -y && apt install -y locales wget pkg-config \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
        && wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/refs/tags/4.9.0.tar.gz \
	&& tar -zxf opencv.tar.gz && rm -f opencv.tar.gz

 # 字符集、时区 环境变量
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
ENV TZ=Asia/Shanghai

# https://hub.docker.com/_/ubuntu
RUN apt -y install openjdk-17-jdk ffmpeg libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libpostproc-dev libswresample-dev libswscale-dev cmake g++ \
	&& mv opencv* opencv && mkdir build && cd build \
        && rm -rf /var/lib/apt/lists/* \
        && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone
	#&& cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ../opencv \
	#&& make && make install \

# JAVA环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${JAVA_HOME}/bin:$PATH

CMD ["/bin/bash"]
