#  syntax=docker/dockerfile:1.4

FROM golang:1.18.3 AS golang
RUN <<EOT
    addgroup --gid 1000 docker
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker
    USER=docker
    GROUP=docker

    # based on target arch, choose the binary format
    case $TARGETARCH in arm64) ARCH=arm64 ;;
    amd64) ARCH=amd64 ;;
    *)  ARCH=amd64 ;;
    esac

    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-$ARCH.tar.gz | tar -C /usr/local/bin -xzf -
    chown root:root /usr/local/bin/fixuid
    chmod 4755 /usr/local/bin/fixuid
    mkdir -p /etc/fixuid
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml
EOT
USER docker:docker
ENTRYPOINT ["fixuid", "-q"]

FROM golang AS codebase
WORKDIR /home/docker/src
COPY go.mod go.sum ./
RUN whoami && go mod download && go mod verify
COPY . .

FROM codebase AS builder
RUN whoami && go build -o ./myapp .

FROM alpine AS myapp
COPY --from=builder ./myapp ./
ENTRYPOINT [ "./myapp" ]
