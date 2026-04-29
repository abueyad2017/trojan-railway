FROM debian:stable-slim

RUN apt-get update && apt-get install -y curl ca-certificates bash && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.hy2.sh/ | bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

CMD ["/entrypoint.sh"]
