FROM golang:alpine3.12 as builder

ENV CADVISOR_VERSION "v0.39"

RUN apk add --no-cache device-mapper git make         \
    && git clone --branch release-${CADVISOR_VERSION} \
        https://github.com/google/cadvisor.git        \
        /src/cadvisor

WORKDIR /src/cadvisor
RUN make build

FROM arm32v7/alpine:3.12

COPY --from=builder /src/cadvisor/cadvisor /usr/bin/cadvisor

EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]
