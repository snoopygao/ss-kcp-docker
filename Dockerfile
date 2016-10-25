# This dockerfile uses the ubuntu image
# VERSION 1 - EDITION 1
# Author: Yale Huang
# Command format: Instruction [arguments / command] ..

# Base image to use, this must be set as the first line
FROM easypi/shadowsocks-libev
RUN set -ex \
	&& apk update \
	&& apk add ca-certificates \
	&& update-ca-certificates \
    	&& apk add --no-cache \
               --virtual TMP wget \
	&& wget -O /root/kcptun-linux-amd64.tar.gz https://github.com/xtaci/kcptun/releases/download/v20161009/kcptun-linux-amd64-20161009.tar.gz \
	&& mkdir -p /opt/kcptun \
	&& cd /opt/kcptun \
	&& tar xvfz /root/kcptun-linux-amd64.tar.gz \
   	&& apk del --virtual TMP \
	&& apk add supervisor supervisor-stdout
COPY supervisord.conf /etc/supervisord.conf
ENV KCP_MTU=1350 KCP_MODE=fast KCP_KEY=123456789
EXPOSE 41111/udp 8338/tcp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

