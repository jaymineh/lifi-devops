FROM golang:1.22.5-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o birdApi

FROM alpine:3.18
RUN addgroup -S birdapi && adduser -S birdapi -G birdapi
USER birdapi

WORKDIR /app
COPY --from=builder /app/birdApi .
EXPOSE 4201

CMD ["./birdApi"]
