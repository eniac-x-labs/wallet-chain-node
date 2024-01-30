# Build wallet-chain-node in a stock Go builder container
FROM golang:1.21.6-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /savour-core
RUN cd /savour-core && go build

# Pull wallet-chain-node into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
RUN mkdir /etc/wallet-chain-node

ARG CONFIG=config.yml

COPY --from=builder /savour-core/wallet-chain-node /usr/local/bin/
COPY --from=builder /savour-core/${CONFIG} /etc/savour-core/config.yml

EXPOSE 8189
ENTRYPOINT ["wallet-chain-node"]
CMD ["-c", "/etc/savour-core/config.yml"]
