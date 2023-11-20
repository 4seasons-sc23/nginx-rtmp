#!/bin/sh

name=$1
HLS_PATH=$2 

# watch_hls_dir.sh 내용을 여기에 복사
/bin/sh /app/watch_hls_dir.sh $HLS_PATH $name &

# exec_ffmpeg.sh 내용을 여기에 복사
/bin/sh /app/exec_ffmpeg.sh $name &