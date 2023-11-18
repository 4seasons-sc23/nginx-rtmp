#!/bin/sh

name=$1
HLS_PATH=$2 

# watch_hls_dir.sh 내용을 여기에 복사
/bin/sh /app/watch_hls_dir.sh $HLS_PATH false &

# $name을 포함하는 모든 ffmpeg 프로세스를 검색합니다.
pids=$(ps aux | grep "ffmpeg.*$name" | grep -v grep | awk '{print $2}')

# 찾은 프로세스들을 종료합니다.
for pid in $pids; do
  echo "Killing ffmpeg process with PID $pid"
  kill -9 $pid
done