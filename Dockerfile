FROM python:3.9-slim-buster
RUN apt-get update && apt-get install -y curl openssl bash && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN curl -Lo /app/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && chmod +x /app/hysteria
COPY . .
RUN chmod +x entrypoint.sh
# Railway يمرر المنفذ تلقائياً عبر متغير $PORT
CMD ["./entrypoint.sh"]
