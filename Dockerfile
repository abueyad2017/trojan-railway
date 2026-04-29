FROM alpine:latest

RUN apk add --no-cache curl openssl bash

# تنزيل Hysteria 2
RUN curl -L -o /usr/local/bin/hysteria \
    https://github.com/apernet/hysteria/releases/download/app/v2.6.1/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

# تنزيل udp2raw
RUN mkdir /tmp/udp2raw && \
    curl -L -o /tmp/udp2raw/udp2raw.tar.gz \
    https://github.com/wangyu-/udp2raw-tunnel/releases/download/20230206.0/udp2raw_binaries.tar.gz && \
    tar xzf /tmp/udp2raw/udp2raw.tar.gz -C /tmp/udp2raw/ && \
    mv /tmp/udp2raw/udp2raw_amd64 /usr/local/bin/udp2raw && \
    chmod +x /usr/local/bin/udp2raw && \
    rm -rf /tmp/udp2raw

# إنشاء شهادة موقعة ذاتياً
RUN mkdir -p /etc/hysteria && \
    openssl req -x509 -newkey rsa:2048 -nodes \
    -keyout /etc/hysteria/private.key \
    -out /etc/hysteria/cert.crt \
    -days 3650 -subj "/CN=localhost"

COPY entrypoint.sh /entrypoint.sh
COPY config.yaml.template /etc/hysteria/config.yaml.template

RUN chmod +x /entrypoint.sh

EXPOSE 9000

CMD ["/entrypoint.sh"]
