#!/bin/bash

mkdir -p /etc/hysteria

cat > /etc/hysteria/config.yaml <<EOF
listen: :${PORT:-443}

tls:
  selfSigned: true

auth:
  type: password
  password: ${HY2_PASSWORD:-123456}

masquerade:
  type: proxy
  proxy:
    url: https://www.cloudflare.com

bandwidth:
  up: 100 mbps
  down: 100 mbps
EOF

exec hysteria server -c /etc/hysteria/config.yaml
