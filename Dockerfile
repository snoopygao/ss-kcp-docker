FROM alpine:3.9

LABEL maintainer="gao <gaoxing2000@gmail.com>"

ARG TZ='Asia/Shanghai'

ENV TZ ${TZ}
ENV SS_LIBEV_VERSION v3.2.5
ENV KCP_VERSION 20190418
ENV SS_DOWNLOAD_URL https://github.com/shadowsocks/shadowsocks-libev.git
ENV OBFS_DOWNLOAD_URL https://github.com/shadowsocks/simple-obfs.git
ENV KCP_DOWNLOAD_URL https://github.com/xtaci/kcptun/releases/download/v${KCP_VERSION}/kcptun-linux-amd64-${KCP_VERSION}.tar.gz
ENV LINUX_HEADERS_DOWNLOAD_URL=http://dl-cdn.alpinelinux.org/alpine/v3.7/main/x86_64/linux-headers-4.4.6-r2.apk

RUN apk upgrade \
    && apk add bash tzdata rng-tools \
    && apk add --virtual .build-deps \
        autoconf \
        automake \
        build-base \
        curl \
        c-ares-dev \
        libev-dev \
        libtool \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        tar \
        git \
    && curl -sSL ${LINUX_HEADERS_DOWNLOAD_URL} > /linux-headers-4.4.6-r2.apk \
    && apk add --virtual .build-deps-kernel /linux-headers-4.4.6-r2.apk \
    && git clone ${SS_DOWNLOAD_URL} \
    && (cd shadowsocks-libev \
    && git checkout tags/${SS_LIBEV_VERSION} -b ${SS_LIBEV_VERSION} \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install) \
    && git clone ${OBFS_DOWNLOAD_URL} \
    && (cd simple-obfs \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --disable-documentation \
    && make install) \
    && curl -sSLO ${KCP_DOWNLOAD_URL} \
    && tar -zxf kcptun-linux-amd64-${KCP_VERSION}.tar.gz \
    && mv server_linux_amd64 /usr/bin/kcpserver \
    && mv client_linux_amd64 /usr/bin/kcpclient \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del .build-deps .build-deps-kernel \
	&& apk add --no-cache \
      $(scanelf --needed --nobanner /usr/bin/ss-* /usr/local/bin/obfs-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
    && rm -rf /linux-headers-4.4.6-r2.apk \
        kcptun-linux-amd64-${KCP_VERSION}.tar.gz \
        shadowsocks-libev \
        simple-obfs \
        /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
