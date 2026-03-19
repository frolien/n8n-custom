FROM alpine:3.23 AS ffmpeg_builder
RUN apk add --no-cache ffmpeg

FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Copie le binaire et les libs nécessaires depuis Alpine
COPY --from=ffmpeg_builder /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg_builder /usr/bin/ffprobe /usr/bin/ffprobe
COPY --from=ffmpeg_builder /usr/lib/ /usr/lib/

USER node
