#!/bin/bash
#VERSION="mr4.5.8.1"; docker build --build-arg RTP_VERSION=$VERSION . -t $VERSION
#VERSION="mr4.5.8.1"; docker build --build-arg RTP_VERSION=$VERSION . -t test-rtp
#VERSION="mr6.1.1.1"; docker build --build-arg RTP_VERSION=$VERSION . -t test-rtp
source values.sh
docker build --build-arg RTPE_VERSION=${RTPE_VERSION} --build-arg BCG_VERSION=${BCG_VERSION} . -t test-rtp

