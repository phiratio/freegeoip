FROM golang:1.13

COPY cmd/freegeoip/public /var/www

ADD . /go/src/github.com/apilayer/freegeoip
RUN \
	cd /go/src/github.com/apilayer/freegeoip/cmd/freegeoip && \
	go mod download && go get -d && go install && \
	apt-get update && apt-get install -y libcap2-bin && \
	setcap cap_net_bind_service=+ep /go/bin/freegeoip && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && \
	useradd -ms /bin/bash freegeoip

ARG INITIAL_DATABASE_URL="https://www.dropbox.com/s/wqi977lxspyo7jj/GeoLite2-City.mmdb.gz?dl=1"
ENV FREEGEOIP_CUSTOM_UPDATES_URL=${INITIAL_DATABASE_URL}

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh; \
    if [ -n "$FREEGEOIP_CUSTOM_UPDATES_URL" ]; then \
    curl -fSLo /db.gz "${FREEGEOIP_CUSTOM_UPDATES_URL}"; \
    fi

ENV FREEGEOIP_UPDATE_INTERVAL 24h
ENV FREEGEOIP_RETRY_INTERVAL 6h

USER freegeoip
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080

# CMD instructions:
# Add  "-use-x-forwarded-for"      if your server is behind a reverse proxy
# Add  "-public", "/var/www"       to enable the web front-end
# Add  "-internal-server", "8888"  to enable the pprof+metrics server
#
# Example:
# CMD ["-use-x-forwarded-for", "-public", "/var/www", "-internal-server", "8888"]
