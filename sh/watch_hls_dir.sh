#!/bin/sh

HLS_DIR=$1  # 예: /tmp/hls
WATCH_FLAG=$2

declare -A upload_flags

echo "paramenter 1: $HLS_DIR 2: $WATCH_FLAG server: $INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT" >> /var/log/hls/all.log

upload_via_http() {
    api_key=$1
    quality=$2
    ts_file=$3
    m3u8_main="$HLS_DIR/$api_key.m3u8"
    m3u8_index="$HLS_DIR/$api_key_$quality/index.m3u8"
    upload_files=""

    if [[ -f "$m3u8_main" ]]; then
        upload_files="$upload_files -F m3u8Main=@$m3u8_main;type=application/vnd.apple.mpegurl"
    fi

    if [[ -f "$m3u8_index" ]]; then
        upload_files="$upload_files -F m3u8=@$m3u8_index;type=application/vnd.apple.mpegurl"
    fi

    # curl을 사용하여 HTTP POST 요청 보내기
    echo "http://$INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT/api/v1/hls/upload/$quality"

    curl "http://$INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT/api/v1/hls/upload/$quality" \
        -H "ApiKey:$API_KEY" $upload_files \
        -F "ts=@$ts_file;type=video/MP2T"
}

# HLS 디렉토리 감시 시작
if [ "$WATCH_FLAG" = "true" ]; then
    echo "Start watch on $HLS_DIR" >> /var/log/hls/all.log
    inotifywait -m -r -e create -e moved_to --format '%w%f' "$HLS_DIR" 2>&1 | while read FULL_PATH 
    do
        echo "Full Path: $FULL_PATH" >> /var/log/hls/all.log
        FILENAME=$(basename "$FULL_PATH")
        DIRNAME=$(dirname "$FULL_PATH")

        if [[ $FILENAME == *.ts ]]; then
            echo "TS File: $FILENAME" >> /var/log/hls/all.log

            # DIRNAME에서 마지막 '/' 뒤의 문자열을 추출합니다 (즉, 'api_key_quality')
            API_QUALITY=${DIRNAME##*/}

            # API_KEY와 QUALITY를 분리합니다
            API_KEY=${API_QUALITY%_*}
            QUALITY=${API_QUALITY#*_}

            upload_via_http "$API_KEY" "$QUALITY" "$FULL_PATH" 2>&1
        fi
    done >> /var/log/hls/all.log



# HLS 디렉토리 감시 중단
elif [ "$WATCH_FLAG" = "false" ]; then
    echo "Stopping watch on $HLS_DIR" >> /var/log/hls/all.log
    unset upload_flags
    exit 0
fi
