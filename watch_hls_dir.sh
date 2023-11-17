#!/bin/bash

HLS_DIR=$1
WATCH_FLAG=$2
MINIO_BUCKET=$MINIO_BUCKET_NAME # 환경변수에서 MinIO 버킷 이름 읽기

# Minio에 파일 업로드
upload_to_minio() {
    python /app/upload_to_minio.py $MINIO_BUCKET $1
}

# HLS 디렉토리 감시 시작
if [ "$WATCH_FLAG" = "true" ]; then
    inotifywait -m -e create -e moved_to --format '%f' "$HLS_DIR" | while read FILE
    do
        if [[ $FILE == *.ts ]]; then
            echo "New .ts file detected: $FILE"
            upload_to_minio "$HLS_DIR/$FILE"

            # 가장 최근의 .m3u8 파일 찾기
            M3U8_FILE=$(ls -t $HLS_DIR/*.m3u8 | head -1)
            if [[ -f "$M3U8_FILE" ]]; then
                echo "Uploading the latest .m3u8 file: $M3U8_FILE"
                upload_to_minio "$M3U8_FILE"
            fi
        fi
    done

# HLS 디렉토리 감시 중단
elif [ "$WATCH_FLAG" = "false" ]; then
    echo "Stopping watch on $HLS_DIR"
    exit 0
fi
