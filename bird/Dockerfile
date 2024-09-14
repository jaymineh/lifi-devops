# Use the official Golang image
FROM golang:1.22.5-alpine

# Set the working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o birdApi

# Expose port 4201
EXPOSE 4201

# Run the executable
CMD ["./birdApi"]
