FROM alpine:3.9

LABEL maintainer="gaoxing2000@gmail.com"

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                autoconf \
                                build-base \
                                curl \
                                libev-dev \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                tzdata \
                                c-ares-dev \
                                git \
                                gcc \
                                make \
                                libtool \
                                zlib-dev \
                                automake \
                                openssl \
                                asciidoc \
                                xmlto \
                                libpcre32 \
                                g++ && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    cd /tmp && \
    v=`curl -I -s https://github.com/xtaci/kcptun/releases/latest | grep Location | sed -n 's/.*\/v\(.*\)/\1/p' | tr -d '\r'` && \
    curl -sSL https://github.com/xtaci/kcptun/releases/download/v$v/kcptun-linux-amd64-$v.tar.gz | tar xz server_linux_amd64 && \
    mv server_linux_amd64 /usr/bin/ && \
    mkdir ss && \
    cd ss && \
    v=`curl -I -s https://github.com/shadowsocks/shadowsocks-libev/releases/latest | grep Location | sed -n 's/.*\/v\(.*\)/\1/p' | tr -d '\r'` && \
    curl -sSL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$v/shadowsocks-libev-$v.tar.gz | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd /tmp && \
    git clone https://github.com/shadowsocks/simple-obfs.git && \
    cd simple-obfs && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

ENV SERVER_ADDR=0.0.0.0 \
SERVER_PORT=37210 \
PASSWORD=passw0rd \
METHOD=aes-256-cfb \
TIMEOUT=300 \
FASTOPEN=--fast-open \
UDP_RELAY=-u \
DNS_ADDR=8.8.8.8 \
DNS_ADDR_2=8.8.4.4 \
ARGS='' \
KCP_LISTEN=29900 \
KCP_MODE=fast \
KCP_MUT=1350 \
KCP_NOCOMP='' \
KCP_ARGS=''

USER nobody

EXPOSE $SERVER_PORT/tcp
EXPOSE $KCP_LISTEN/udp

CMD /usr/bin/ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k $PASSWORD \
              -m $METHOD \
              -t $TIMEOUT \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              $FASTOPEN \
              $ARGS \
              -f /tmp/ss.pid \
              && /usr/bin/server_linux_amd64 -t "127.0.0.1:$SERVER_PORT" \
              -l ":$KCP_LISTEN" \
              --mode $KCP_MODE \
              $KCP_NOCOMP \
              $KCP_ARGS
