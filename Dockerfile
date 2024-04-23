FROM golang:1.22.0-alpine as build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY **/**.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /go-webapp-sample

FROM gcr.io/distroless/static-debian12 as runtime

COPY --from=build /go-webapp-sample /app

EXPOSE 8080

CMD ["/app"]
