FROM node:24-alpine AS ffmpeg-builder

WORKDIR /build

RUN apk add --no-cache \
    build-base \
    pkgconf \
    tar \
    xz \
    bash

COPY ffmpeg-8.1.tar.xz /build/

RUN tar -xJf ffmpeg-8.1.tar.xz \
 && cd ffmpeg-8.1 \
 && ./configure \
      --prefix=/opt/ffmpeg \
      --disable-debug \
      --disable-doc \
      --disable-ffplay \
      --disable-shared \
      --enable-static \
      --disable-x86asm \
      --extra-ldexeflags="-static" \
 && make -j"$(getconf _NPROCESSORS_ONLN)" \
 && make install


FROM node:24-alpine

ARG N8N_VERSION=2.12.3

RUN apk add --no-cache python3 tini \
 && npm install -g n8n@${N8N_VERSION}

COPY --from=ffmpeg-builder /opt/ffmpeg /opt/ffmpeg

RUN ln -s /opt/ffmpeg/bin/ffmpeg /usr/local/bin/ffmpeg \
 && ln -s /opt/ffmpeg/bin/ffprobe /usr/local/bin/ffprobe \
 && mkdir -p /home/node/.n8n \
 && chown -R node:node /home/node /opt/ffmpeg

WORKDIR /home/node

ENV N8N_PORT=5678

USER node

ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
