# Shadowsocks with kcptun support

This docker image starts both shadowsocks-libev and kcptun.

Please refer to [kcptun](https://github.com/xtaci/kcptun) for kcptun configurations. If any other configuration is needed, please feel free to send PR.

## envs

please refer to [easyPi shadowsocks docker](https://github.com/EasyPi/docker-shadowsocks-libev) for detailed shadowsocks envs.

* KCP_MTU=1350
* KCP_MODE=fast
* KCP_KEY=123456789 
* KCP_DATASHARED=5 
* KCP_PARITYSHARED=5 
* KCP_SNDWND=1024
