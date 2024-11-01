FROM golang:1.23-alpine AS build_base
WORKDIR /src
COPY go.mod .
COPY go.sum .

RUN apk add --no-cache gcc libc-dev
RUN go mod download

FROM build_base AS builder

ADD . /src
WORKDIR /src
RUN go build --tags musl -o /src/bin/ ./cmd/...

FROM alpine:latest

WORKDIR /app

RUN mkdir /app/config

COPY --from=builder /src/frontend/build /app/frontend/build
COPY --from=builder /src/bin /app
