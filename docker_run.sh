#docker run --network host -p 12222:12222/udp -p 25060:25060/tcp -p 22222:22222 -p 16384-16485:16384-16485 --privileged --name rtpengine -it -e INTERFACES=192.168.56.151!192.168.56.151 --rm test-rtp 
docker run --network host --privileged --name rtpengine -it -e INTERFACES=192.168.56.151!192.168.56.151 --rm test-rtp 
