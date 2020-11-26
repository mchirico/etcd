FROM golang:1.15 as builder


WORKDIR /workspace
COPY go.mod go.mod


COPY . /workspace/
RUN go get -v -t -d ./...
RUN make


FROM gcr.io/distroless/static
WORKDIR /
COPY --from=builder /workspace/bin/etcd .
#COPY --from=builder   /workspace/certs /certs

ENTRYPOINT ["/etcd", "--name","infra0", "--data-dir", "infra0","--cert-file=/certs/server.crt","--key-file=/certs/server.key","--advertise-client-urls=https://0.0.0.0:2379","--listen-client-urls=https://0.0.0.0:2379"]



