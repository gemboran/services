FROM node:20-alpine AS base
LABEL authors="gemboran"

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ARG CLOUDFLARED_VERSION=2024.9.1
ARG CLOUDFLARED_BASE_URL="https://github.com/cloudflare/cloudflared/releases/download"

ENV VERSION=$CLOUDFLARED_VERSION

USER root
WORKDIR /var/app

RUN apk add --no-cache curl

RUN curl -L ${CLOUDFLARED_BASE_URL}/${CLOUDFLARED_VERSION}/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared

CMD cloudflared tunnel --no-autoupdate run --token eyJhIjoiMjljODY2ZjQ4NTk4MGI4NjAxYjZlNTNjMWFjZmVlZmUiLCJ0IjoiMmRjMTk3ZjctOWRkOS00NzgyLWIwYjQtYWU0YjlmYjYzNzU2IiwicyI6IlpqTTFOamhtTVdZdFlqSm1aaTAwTnpVd0xXRTJPV1l0T1RGaVltSm1NVFpoWVRkaCJ9
