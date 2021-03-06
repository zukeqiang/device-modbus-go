#
# Copyright (C) 2018 IOTech Ltd
#
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.11-alpine AS builder

ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --update make git openssh build-base

# set the working directory
WORKDIR $GOPATH/src/github.com/edgexfoundry/device-modbus-go

COPY . .

RUN make build

FROM scratch

ENV APP_PORT=49991
EXPOSE $APP_PORT

COPY --from=builder /go/src/github.com/edgexfoundry/device-modbus-go/cmd /

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2019: IoTech Ltd'

ENTRYPOINT ["/device-modbus","--profile=docker","--confdir=/res","--registry=consul://edgex-core-consul:8500"]
