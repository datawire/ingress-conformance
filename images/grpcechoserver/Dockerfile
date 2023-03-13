# Copyright 2023 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build
FROM golang:1.19.0 as builder

ENV CGO_ENABLED=0

WORKDIR /go/src/sigs.k8s.io/ingress-controller-conformance/

RUN apt-get update -y && apt-get install -y wget unzip

# TODO: Also enable arm.

RUN cd /tmp && \
	wget https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip && \
	echo "73243017d21ebe1cc1fda4005b5ace91ffc68218  protoc-22.2-linux-x86_64.zip" | shasum -c && \
	unzip protoc-22.2-linux-x86_64.zip bin/protoc && \
	mv bin/protoc /usr/local/bin/protoc

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 && \
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

COPY go.mod go.sum ./

RUN go mod download

COPY grpcecho.proto .

RUN mkdir grpcechoserver && \
    protoc --go_out=grpcechoserver --go_opt=paths=source_relative \
    --go-grpc_out=grpcechoserver --go-grpc_opt=paths=source_relative \
    grpcecho.proto

COPY grpcechoserver.go .

RUN go build -o echoserver grpcechoserver.go

# Use distroless as minimal base image to package the binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /go/src/sigs.k8s.io/ingress-controller-conformance/echoserver /
USER nonroot:nonroot

ENTRYPOINT ["/echoserver"]
