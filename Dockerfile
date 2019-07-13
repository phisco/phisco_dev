FROM alpine:3.9 AS builder

ENV HUGO_VERSION 0.55.6
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./site /site

WORKDIR /site

RUN /usr/bin/hugo

FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d
COPY --from=builder /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
