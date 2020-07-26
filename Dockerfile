FROM --platform=$BUILDPLATFORM golang:1.14-alpine as builder
ARG TARGETARCH
WORKDIR /src
COPY . /src/
RUN GOARCH=$TARGETARCH CGO_ENABLED=0 go build -v -ldflags="-X main.GitRev=$(shell git rev-parse --short HEAD)"

FROM --platform=$BUILDPLATFORM alpine:3.10 as hegel
EXPOSE 50060
EXPOSE 50061
RUN apk add --update --upgrade --no-cache ca-certificates
COPY --from=builder /src/hegel /
ENTRYPOINT ["/hegel"]
