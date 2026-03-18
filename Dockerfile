FROM node:24-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN npx next build --webpack
RUN npx next serve out

FROM ghcr.io/nginx/nginx-unprivileged:1.29.3-alpine3.22-otel

LABEL org.opencontainers.image.title="JMAP Webmail"
LABEL org.opencontainers.image.description="Modern webmail client built with Next.js and the JMAP protocol"
LABEL org.opencontainers.image.source="https://github.com/root-fr/jmap-webmail"
LABEL org.opencontainers.image.url="https://github.com/root-fr/jmap-webmail"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="root.cloud"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/out /usr/share/nginx/html/
