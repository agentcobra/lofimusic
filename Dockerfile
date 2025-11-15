FROM docker.io/golang:1.22.2 AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod tidy

COPY . .

RUN GOARCH=wasm GOOS=js go build -o docs/web/app.wasm ./bin/lofimusic && \
    go build -o docs/lofimusic ./bin/lofimusic && \
    cd docs && ./lofimusic github && cd .. && \
    rm docs/lofimusic && \
    go clean -modcache

FROM nginx:alpine

COPY --from=builder /src/docs/. /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
