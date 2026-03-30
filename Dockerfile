FROM golang:1.25-alpine AS builder

WORKDIR /src
RUN apk add --no-cache git
RUN git clone --depth=1 https://github.com/fastclaw-ai/weclaw.git .

RUN go mod download

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/weclaw .

FROM alpine:3.21

RUN apk add --no-cache ca-certificates tzdata
COPY --from=builder /usr/local/bin/weclaw /usr/local/bin/weclaw

VOLUME /root/.weclaw

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]