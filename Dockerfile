FROM alpine:edge

ENV GOPATH /go
ENV GOREPO github.com/influxdata/influxdb-comparisons
RUN mkdir -p $GOPATH/src/$GOREPO
COPY . $GOPATH/src/$GOREPO
WORKDIR $GOPATH/src/$GOREPO

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		git \
		go \
		build-base \
	&& go build cmd/bulk_load_influx/* \
	&& mv http_writer /usr/local/bin/bulk_load_influx \
	&& apk del .build-deps \
	&& rm -rf $GOPATH/pkg

ENV URLS http://localhost:8086
ENV WORKERS 10
ENV DB_CREATE false

CMD bulk_load_influx -urls=$URLS -workers=$WORKERS -do-db-create=$DB_CREATE
