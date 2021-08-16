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
    "outbounds": [
        {
            "protocol": "vmess",
            "settings": {
                "vnext": [
                    {
                        "address": "27.0.0.1",
                        "port": 8080,
                        "users": [
                            {
                                "id": "b5f4321b-4642-4663-abdf-e5d7605f3270",
                                "alterId": 0,
                                "security": "auto"
                            }
                        ]
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "tcpSettings": {
                    "header": {
                        "type": "http",
                        "request": {
                            "version": "1.1",
                            "method": "GET",
                            "path": [
                                "/"
                            ],
                            "headers": {
                                "Host": [
                                    "www.cloudflare.com",
                                    "www.amazon.com"
                                ],
                                "User-Agent": [
                                    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36",
                                    "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36",
                                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.75 Safari/537.36",
                                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0"
                                ],
                                "Accept": [
                                    "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
                                ],
                                "Accept-language": [
                                    "zh-CN,zh;q=0.8,en-US;q=0.6,en;q=0.4"
                                ],
                                "Accept-Encoding": [
                                    "gzip, deflate, br"
                                ],
                                "Cache-Control": [
                                    "no-cache"
                                ],
                                "Pragma": "no-cache"
                            }
                        }
                    }
                }
            },
            "mux": {
                "enabled": true
            }
        },
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "direct"
        },
        {
                        "protocol": "blackhole",
                        "settings": {},
                        "tag": "blocked"
        },
        {
            "protocol": "dns",
            "tag": "dns-out"
        }
    ],
    "inbounds": [
        {
            "port": "1099",
            "protocol": "dokodemo-door",
            "settings": {
              "network": "tcp,udp",
              "timeout": 0,
              "followRedirect": true
            },
            "sniffing": {
              "enabled": true,
              "destOverride": ["http", "tls"]
            }
        },
        {
            "port": 2133,
            "tag": "dns-in",
            "protocol": "dokodemo-door",
            "settings": {
                "address": "119.29.29.29",
                "port": 53,
                "timeout": 0,
                "network": "tcp,udp"
            }
        },
        {
            "port": 2333,
            "protocol": "socks",
            "settings": {
                "auth": "noauth",
                "udp": true
            }
        },
        {
            "port": 6666,
            "protocol": "http",
            "settings": {
                "auth": "noauth",
                "udp": true
            }
        }
    ],
    "dns": {
        "servers": [
            {
                "address": "119.29.29.29",
                "port": 53,
                "domains": [
                  "geosite:cn"
                ],
                "expectIPs": [
                  "geoip:cn"
                ]
              },
              {
                "address": "1.1.1.1",
                "port": 53,
                "domains": [
                  "geosite:geolocation-!cn"
                ]
            },
            "8.8.8.8",
            "localhost"
        ]
    },
    "routing": {
        "domainStrategy": "IPOnDemand",
        "rules": [
            {
                "type": "field",
                "inboundTag": [
                    "dns-in"
                ],
                "outboundTag": "dns-out"
            },
            {
                                "type": "field",
                                "ip": [
                                        "geoip:private"
                                ],
                                "outboundTag": "blocked"
                        },
            {
                "type": "field",
                "ip": [
                    "geoip:cn"
                ],
                "outboundTag": "direct"
            },
            {
                "type": "field",
                "domain": [
                    "geosite:cn"
                ],
                "outboundTag": "direct"
            }
        ]
    }
}

EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
