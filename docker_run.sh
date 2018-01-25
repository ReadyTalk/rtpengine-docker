docker rm -f rtpengine
#echo 'del 0' > /proc/rtpengine/control || true
docker run --network host -p 12222:12222/udp -p 25060:25060/tcp -p 22222:22222 -p 16384-16485:16384-16485 --privileged --name rtpengine -itd readytalk/rtpengine:latest
