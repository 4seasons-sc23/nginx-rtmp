#!/bin/sh

name=$1

# $name을 포함하는 모든 ffmpeg 프로세스를 검색합니다.
pids=$(ps aux | grep "[f]fmpeg.*$name" | awk '{print $1}')

# 찾은 프로세스들을 종료합니다.
for pid in $pids; do
  echo "exec_publish_done: Killing ffmpeg process with PID $pid" >> /var/log/hls/all.log
  kill -9 $pid
done