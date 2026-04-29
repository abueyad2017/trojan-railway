#!/bin/bash
set -e

# كلمة السر من متغيرات البيئة، أو افتراضية
PASSWORD=${PASSWORD:-"change-me"}

# استخدام sed بدلاً من envsubst
sed "s/\${PASSWORD}/$PASSWORD/g" \
    /etc/hysteria/config.yaml.template > /etc/hysteria/config.yaml

echo "Starting Hysteria 2 on UDP 2000..."
hysteria server -c /etc/hysteria/config.yaml &

sleep 2

echo "Starting udp2raw tunnel: TCP 0.0.0.0:9000 -> UDP 127.0.0.1:2000"
udp2raw -s -l 0.0.0.0:9000 -r 127.0.0.1:2000 --raw-mode faketcp --log-level 1

wait -n
exit $?
