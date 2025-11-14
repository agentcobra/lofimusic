FROM docker.io/golang:1.20 AS builder

WORKDIR /src

COPY . .

RUN GOARCH=wasm GOOS=js go build -o docs/web/app.wasm ./bin/lofimusic && \
    go build -o docs/lofimusic ./bin/lofimusic && \
    cd docs && ./lofimusic github && cd .. && \
    cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" docs/web/ && \
    go clean ./... && rm docs/lofimusic

FROM nginx:latest

COPY --from=builder /src/docs/. /usr/share/nginx/html/
