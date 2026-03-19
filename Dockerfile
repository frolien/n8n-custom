FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl ffmpeg && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

WORKDIR /home/node/n8n
RUN npm install -g n8n

EXPOSE 5678
CMD ["n8n"]
