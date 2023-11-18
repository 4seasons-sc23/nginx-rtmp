#!/bin/sh

name=$1

ffmpeg -i rtmp://localhost/instream-live/$name \
	-c:a aac -b:a 32k  -c:v libx264 -b:v 128K -f flv rtmp://localhost/hls/${name}_360 \
	-c:a aac -b:a 64k  -c:v libx264 -b:v 256k -f flv rtmp://localhost/hls/${name}_720 \
    -c:a aac -b:a 128k -c:v libx264 -b:v 512K -f flv rtmp://localhost/hls/${name}_1080;   