FROM golang:1.22.5-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o birdImage

FROM alpine:3.18
RUN addgroup -S birdimageapi && adduser -S birdimageapi -G birdimageapi
USER birdimageapi

WORKDIR /app
COPY --from=builder /app/birdImage .
EXPOSE 4200

CMD ["./birdImage"]
