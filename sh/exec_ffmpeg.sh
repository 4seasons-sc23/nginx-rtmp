#!/bin/sh

name=$1

# 'ps' 명령어를 사용하여 ffmpeg 프로세스 중에서 $name을 포함하는지 확인
if ps aux | grep -q "[f]fmpeg.*$name"; then
    echo "Stream for $name is already running."
else
    # ffmpeg 스트리밍 명령 실행
    ffmpeg -i rtmp://localhost/instream-live/$name \
        -c:a aac -b:a 32k  -c:v libx264 -b:v 128K -f flv rtmp://localhost/hls/${name}_360 \
        -c:a aac -b:a 64k  -c:v libx264 -b:v 256k -f flv rtmp://localhost/hls/${name}_720 \
        -c:a aac -b:a 128k -c:v libx264 -b:v 512K -f flv rtmp://localhost/hls/${name}_1080 &   
fi
