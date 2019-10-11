FROM golang:1.13.1 as build
#RUN apk add --no-cache --virtual git
RUN go get \
    golang.org/x/net/http2 \
    github.com/aws/aws-sdk-go-v2 \
    github.com/jmespath/go-jmespath \
    github.com/hashicorp/golang-lru \
    github.com/go-ini/ini

RUN mkdir /app

ADD . /app/
WORKDIR /app

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o overrun .

FROM scratch
COPY --from=build /app/overrun /root/overrun
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/root/overrun"]