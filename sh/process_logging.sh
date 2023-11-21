#!/bin/sh

# 무한 루프
while true
do
    echo -e "\n====================== PROCESS LOGGING START ======================\n"

    # 'ps' 명령어 실행
    ps

    echo -e "\n====================== PROCESS LOGGING END ======================\n"

    echo -e "\n====================== FFMPEG LOGGING START ======================\n"

    # 'ps' 명령어 실행
    cat /var/log/ffmpeg/all.log

    echo -e "\n====================== FFMPEG LOGGING END ======================\n"

    echo -e "\n====================== HLS LOGGING START ======================\n"

    # 'ps' 명령어 실행
    cat /var/log/hls/all.log

    echo -e "\n====================== HLS LOGGING END ======================\n"

    # 1초 대기
    sleep 5
done