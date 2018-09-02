FROM alpine:edge
LABEL maintainer="charlie@browndev.me"
# webproc release settings
ENV WEBPROC_VERSION 0.1.9
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/$WEBPROC_VERSION/webproc_linux_amd64.gz
# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add openntpd \
	&& apk add --no-cache --virtual .build-deps curl \
	&& curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc \
	&& apk del .build-deps
#configure dnsmasq
COPY ntpd.conf /etc/ntpd.conf
#run!
ENTRYPOINT ["webproc","--config","/etc/ntpd.conf","--","ntpd","-d"]
