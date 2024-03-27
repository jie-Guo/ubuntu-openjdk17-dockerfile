FROM ubuntu:22.04

WORKDIR /app

# https://github.com/opencv/opencv/releases/tag/4.9.0
ADD opencv-4.9.0.tar.gz

# https://hub.docker.com/_/ubuntu
RUN apt update && apt full-upgrade -y &&  apt install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
	&& apt -y install openjdk-17-jdk ffmpeg cmake g++ \
	&& mv opencv* opencv && mkdir build && cd build \
	&& cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..\opencv
	&& make && make install
	
# 字符集、时区 环境变量
ENV LANG en_US.utf8
ENV TZ=Asia/Shanghai

# JAVA环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${JAVA_HOME}/bin:$PATH

CMD ["/bin/bash"]
