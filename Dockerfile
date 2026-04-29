FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    curl wget unzip ca-certificates openssl && \
    rm -rf /var/lib/apt/lists/*

# تحميل Xray (Trojan core)
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip Xray-linux-64.zip \
    && mv xray /usr/local/bin/ \
    && chmod +x /usr/local/bin/xray

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
