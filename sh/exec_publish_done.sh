#!/bin/sh

name=$1

# $name을 포함하는 모든 ffmpeg 프로세스를 검색합니다.
pids=$(ps aux | grep "ffmpeg.*$name" | grep -v grep | awk '{print $1}')

# 찾은 프로세스들을 종료합니다.
for pid in $pids; do
  echo "Killing ffmpeg process with PID $pid"
  kill -9 $pid
done