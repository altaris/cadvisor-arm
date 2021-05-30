FROM arm32v7/golang as builder

ENV CADVISOR_VERSION "v0.39"

RUN apt-get update                                      \
    && apt-get install -y git dmsetup                   \
    && apt-get clean                                    \
    && git clone --branch release-${CADVISOR_VERSION}   \
        https://github.com/google/cadvisor.git          \
        /src/cadvisor

WORKDIR /src/cadvisor
RUN make build

FROM arm32v7/debian

COPY --from=builder /src/cadvisor/cadvisor /usr/bin/cadvisor

EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]
