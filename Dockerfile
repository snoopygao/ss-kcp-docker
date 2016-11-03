FROM easypi/shadowsocks-libev
RUN set -ex \
	&& apk update \
	&& apk add ca-certificates supervisor \
	&& update-ca-certificates \
	&& apk add --update python py-pip \
	&& rm -rf /var/cache/apk/* \
    	&& apk add --no-cache --virtual TMP wget \
	&& wget -O /root/kcptun-linux-amd64.tar.gz https://github.com/xtaci/kcptun/releases/download/v20161009/kcptun-linux-amd64-20161009.tar.gz \
	&& mkdir -p /opt/kcptun \
	&& cd /opt/kcptun \
	&& tar xvfz /root/kcptun-linux-amd64.tar.gz \
   	&& apk del --virtual TMP \ 
	&& pip install supervisor-stdout
COPY supervisord.conf /etc/supervisord.conf
ENV KCP_MTU=1350 KCP_MODE=fast KCP_KEY=123456789 KCP_DATASHARED=5 KCP_PARITYSHARED=5 KCP_SNDWND=1024
EXPOSE 41111/udp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

