FROM ubuntu

RUN apt-get update && apt-get install -y python2.7 cmake git g++ unzip &&  update-alternatives --install /usr/bin/python python /usr/bin/python2.7 10

ADD https://github.com/emscripten-core/emsdk/archive/master.zip /opt/emsdk.zip
ADD https://github.com/WebAssembly/wabt/archive/master.zip /opt/wabt.zip

RUN cd /opt && unzip emsdk.zip && unzip wabt.zip

ENV WABT_HOME=/opt/wabt-master
RUN mkdir ${WABT_HOME}/build && cd ${WABT_HOME}/build && cmake -DBUILD_TESTS=OFF .. && cmake --build .

ENV EMSDK_HOME=/opt/emsdk-master
RUN cd ${EMSDK_HOME} && ./emsdk install latest && ./emsdk activate latest

RUN (echo "source /opt/emsdk-master/emsdk_env.sh"; \
     echo "export PATH=/opt/wabt-master/bin:$PATH") >> /etc/bash.bashrc

WORKDIR /root
VOLUME /root
