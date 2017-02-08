# Shadowsocks with kcptun support

This docker image starts both shadowsocks-libev and kcptun.

Please refer to [kcptun](https://github.com/xtaci/kcptun) for kcptun configurations. If any other configuration is needed, please feel free to send PR.

## envs

please refer to [easyPi shadowsocks docker](https://github.com/EasyPi/docker-shadowsocks-libev) for detailed shadowsocks envs.

SERVER_ADDR 0.0.0.0
SERVER_PORT 8388
METHOD      aes-256-cfb
PASSWORD=
TIMEOUT     60
DNS_ADDR    8.8.8.8

* KCP_MTU=1350
* KCP_MODE=fast
* KCP_KEY=12345678
* KCP_DATASHARED=5 
* KCP_PARITYSHARED=5 
* KCP_SNDWND=1024
