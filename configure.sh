#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
wget -q https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -O /tmp/v2ray/v2ray.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbound": {
      "port": 53,
      "listen": "127.0.0.1",
      "protocol": "shadowsocks",
      "settings": {
      "email": "love@v2ray.com",
      "method": "aes-256-cfb",
      "password": "qwer1234",
      "udp": true,
      "level": 0,
      "ota": true
      },
      "streamSettings": {},
      "tag": "标识",
      "domainOverride": ["http", "tls"]
    }
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
