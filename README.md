容器平台配置

SS_CONFIG = -s 0.0.0.0 -p 6443 -m aes-256-cfb -k password

KCP_MODULE = kcpserver

KCP_CONFIG = -t 127.0.0.1:6443 -l :29900 -sndwnd 1024 -rcvwnd 1024 -mode fast

KCP_FLAG = true

客户端配置
