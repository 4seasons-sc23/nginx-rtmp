#!/bin/sh

name=$1
HLS_PATH=$2 

# watch_hls_dir.sh 내용을 여기에 복사
# /bin/sh /app/watch_hls_dir.sh $HLS_PATH $name > /dev/stdout 2> /dev/stderr
/bin/sh /app/watch_hls_dir.sh $HLS_PATH $name > /var/log/hls/all.log 2>&1

# exec_ffmpeg.sh 내용을 여기에 복사
/bin/sh /app/exec_ffmpeg.sh $name > /var/log/ffmpeg/all.log 2>&1