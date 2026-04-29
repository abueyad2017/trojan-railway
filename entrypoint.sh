#!/bin/bash

# قراءة كلمة السر من متغيرات البيئة (أو تعيين افتراضي)
PASSWORD=${PASSWORD:-"change-me"}

# استبدال المتغير في القالب
export PASSWORD
envsubst < /etc/hysteria/config.yaml.template > /etc/hysteria/config.yaml

echo "Starting Hysteria 2 on UDP 2000..."
hysteria server -c /etc/hysteria/config.yaml &

# الانتظار قليلاً للتأكد من بدء Hysteria
sleep 2

echo "Starting udp2raw tunnel: TCP 0.0.0.0:9000 -> UDP 127.0.0.1:2000"
udp2raw --server --listen 0.0.0.0:9000 \
        --remote 127.0.0.1:2000 \
        --raw-mode faketcp \
        --log-level 1

# إذا تعطل أحدهم نوقف الحاوية
wait -n
exit $?
