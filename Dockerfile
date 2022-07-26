FROM golang:alpine

ENV PORT=8081

ENV GIN_MODE="release"

ENV TZ=Asia/Ho_Chi_Minh

WORKDIR /src/listen-push
COPY . .

RUN go build -mod=vendor -o ./bin ./main

ENTRYPOINT ["./bin"]
