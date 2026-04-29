#!/bin/bash
set -e

PASSWORD=${PASSWORD:-"change-me"}

sed "s/\${PASSWORD}/$PASSWORD/g" \
    /etc/hysteria/config.yaml.template > /etc/hysteria/config.yaml

echo "Starting Hysteria 2 on UDP 2000..."
hysteria server -c /etc/hysteria/config.yaml &

sleep 2

# استخدام gost لعمل نفق TCP->UDP مع الحفاظ على حدود الحزم
echo "Starting gost TCP-to-UDP tunnel: TCP 0.0.0.0:9000 -> UDP 127.0.0.1:2000"
gost -L "relay+tcp://:9000/udp://127.0.0.1:2000?keepAlive=false"

wait -n
exit $?
