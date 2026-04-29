FROM alpine:latest

# تثبيت الأدوات اللازمة
RUN apk add --no-cache curl openssl bash

# تحميل Hysteria 2 (إصدار amd64)
RUN curl -L -o /usr/local/bin/hysteria \
    https://github.com/apernet/hysteria/releases/download/app/v2.6.1/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

# تحميل udp2raw-tunnel (إصدار amd64)
RUN mkdir /tmp/udp2raw && \
    curl -L -o /tmp/udp2raw/udp2raw.tar.gz \
    https://github.com/wangyu-/udp2raw-tunnel/releases/download/20230206.0/udp2raw_binaries.tar.gz && \
    tar xzf /tmp/udp2raw/udp2raw.tar.gz -C /tmp/udp2raw/ && \
    mv /tmp/udp2raw/udp2raw_amd64 /usr/local/bin/udp2raw && \
    chmod +x /usr/local/bin/udp2raw && \
    rm -rf /tmp/udp2raw

# إنشاء شهادة TLS ذاتية (متطلبة لـ Hysteria)
RUN mkdir -p /etc/hysteria && \
    openssl req -x509 -newkey rsa:2048 -nodes \
    -keyout /etc/hysteria/private.key \
    -out /etc/hysteria/cert.crt \
    -days 3650 -subj "/CN=localhost"

# نسخ الملفات
COPY entrypoint.sh /entrypoint.sh
COPY config.yaml.template /etc/hysteria/config.yaml.template

# منح صلاحيات التنفيذ
RUN chmod +x /entrypoint.sh

# المنفذ الذي سنستخدمه لـ TCP Proxy (يجب تعيينه في Railway)
EXPOSE 9000

CMD ["/entrypoint.sh"]
