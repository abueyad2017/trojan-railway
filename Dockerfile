FROM ubuntu:22.04

# تحديث المستودعات وتثبيت الأدوات الضرورية
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# تثبيت سكربت 3X-UI المستقر (أفضل للألعاب والمكالمات)
RUN curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh | bash -s -- -y

WORKDIR /root

# أمر ضروري لمنع الحاوية من التوقف
CMD ["tail", "-f", "/dev/null"]
CMD ["/usr/local/x-ui/x-ui"]
