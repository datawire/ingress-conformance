#!/bin/bash

set -exo pipefail

X86_URL="https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip"
X86_CHECKSUM="73243017d21ebe1cc1fda4005b5ace91ffc68218  protoc-22.2-linux-x86_64.zip"

ARM64_URL="https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-aarch_64.zip"
ARM64_CHECKSUM="b6077aef64f28f4a73190928b474ee6618162438  protoc-22.2-linux-aarch_64.zip"

URL=""
CHECKSUM=""

if [[ "$TARGETPLATFORM" == "linux/amd64" || "$TARGETPLATFORM" == "" ]]; then
	URL="$X86_URL"
	CHECKSUM="$X86_CHECKSUM"
elif [[ "$TARGETPLATFORM" == "linux/arm64" ]]; then
	URL="$ARM64_URL"
	CHECKSUM="$ARM64_CHECKSUM"
else
	echo "Platform $TARGETPLATFORM is not supported." >/dev/stderr
	exit 1
fi


cd /tmp && \
	wget "$URL" && \
	echo "$CHECKSUM" | shasum -c && \
	unzip protoc-22.2-linux-*.zip bin/protoc && \
	mv bin/protoc /usr/local/bin/protoc
