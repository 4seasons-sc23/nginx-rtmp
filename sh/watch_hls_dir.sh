#!/bin/sh

HLS_DIR=$1  # 예: /tmp/hls
name=$2
script_name="watch_hls_dir.sh"
current_pid=$$

echo -e "\n====================== WATCH HLS DIR ======================\n"

ps -ef | grep "$script_name" | grep "$name" | grep -v grep | awk -v cp=$current_pid '{ if ($1 != cp) print $1 }' | while read pid; do
    kill $pid
    echo "watch_hls_dir.sh: Killed $script_name with PID $pid"
done

upload_via_http() {
    api_key=$1
    quality=$2
    ts_file=$3
    m3u8_main="$HLS_DIR/$api_key.m3u8"
    m3u8_index="$HLS_DIR/${api_key}_${quality}/index.m3u8"
    upload_files=""

    # convert_crlf_to_lf $ts_file

    if [[ -f "$m3u8_main" ]]; then
        # convert_crlf_to_lf "$m3u8_main"
        upload_files="-F m3u8Main=@$m3u8_main;type=application/vnd.apple.mpegurl"
    fi

    if [[ -f "$m3u8_index" ]]; then
        # convert_crlf_to_lf "$m3u8_index"
        upload_files="$upload_files -F m3u8=@$m3u8_index;type=application/vnd.apple.mpegurl"
    fi

    echo -e "\n===================== UPLOAD VIA HTTP ======================"
    # curl을 사용하여 HTTP POST 요청 보내기
    echo "watch_hls_dir.sh: upload_via_http; Upload "http://$INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT/api/v1/hls/upload/$quality -H ApiKey:$API_KEY $upload_files -F "ts=@$ts_file;type=video/MP2T"

    curl -s "http://$INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT/api/v1/hls/upload/$quality" \
        -H "ApiKey:$API_KEY" \
        $upload_files \
        -F "ts=@$ts_file;type=video/MP2T"
}

# HLS 디렉토리 감시 시작

echo -e "\n===================== START WATCH ON $HLS_DIR ======================\n"
inotifywait -m -r -e close_write -e moved_to --format '%w%f' "$HLS_DIR" | while read FULL_PATH 
do
    FILENAME=$(basename "$FULL_PATH")
    DIRNAME=$(dirname "$FULL_PATH")

    if [[ $FILENAME == *.ts ]]; then
        echo "watch_hls_dir.sh: Full Path: $FULL_PATH"

        # DIRNAME에서 마지막 '/' 뒤의 문자열을 추출합니다 (즉, 'api_key_quality')
        API_QUALITY=${DIRNAME##*/}

        # API_KEY와 QUALITY를 분리합니다
        API_KEY=${API_QUALITY%_*}
        QUALITY=${API_QUALITY#*_}

        upload_via_http "$API_KEY" "$QUALITY" "$FULL_PATH"
    fi
done
