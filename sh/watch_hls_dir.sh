#!/bin/sh

HLS_DIR=$1  # 예: /tmp/hls
WATCH_FLAG=$2
declare -A upload_flags

upload_via_http() {
    api_key=$1
    quality=$2
    ts_file=$3
    m3u8_main="${HLS_DIR}/${api_key}.m3u8"
    m3u8_index="${HLS_DIR}/${api_key}_${quality}/index.m3u8"
    upload_files=""

    if [[ -f "$m3u8_main" ]]; then
        upload_files="$upload_files -F m3u8Main=@$m3u8_main"
    fi

    if [[ -f "$m3u8_index" ]]; then
        upload_files="$upload_files -F m3u8=@$m3u8_index"
    fi

    # curl을 사용하여 HTTP POST 요청 보내기
    curl -X POST http://${INSTREAM_TENANT_SERVER}:${INSTREAM_TENANT_SERVER_PORT}/api/v1/hls_upload \
        -H "ApiKey: $API_KEY" $upload_files \
        -F "ts=@$ts_file" -F "quality=$quality" 
}

# HLS 디렉토리 감시 시작
if [ "$WATCH_FLAG" = "true" ]; then
    inotifywait -m -e create -e moved_to --format '%f' "$HLS_DIR" | while read FILE 
    do
        if [[ $FILE == *.ts ]]; then
            api_key=$(echo $FILE | cut -d'_' -f1)
            quality=$(echo $FILE | cut -d'_' -f2)
            ts_file="$HLS_DIR/$FILE"
            
            upload_via_http "$api_key" "$quality" "$ts_file" >> /var/log/hls/all.log
        fi
    done

# HLS 디렉토리 감시 중단
elif [ "$WATCH_FLAG" = "false" ]; then
    echo "Stopping watch on $HLS_DIR" >> /var/log/hls/all.log
    unset upload_flags
    exit 0
fi
