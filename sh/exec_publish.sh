#!/bin/sh

tcurl=$1
name=$2

# '?' 문자를 기준으로 쿼리 파라미터 추출
query_params=$(echo $tcurl | awk -F'?' '{print $2}' | cut -d'/' -f1)

# UUID 정규 표현식
uuid_regex="[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"

# UUID 추출
application_id=$(echo "$query_params" | \
awk -F'&' '{
    for(i=1; i<=NF; i++) {
        split($i, kv, "=");
        if (kv[1] == "id") {
            print kv[2];
            exit;
        }
    }
}')

application_id=$(echo $application_id | grep -oE $uuid_regex)

# UUID 유효성 검사 및 결과 처리
if [ -z "$application_id" ]; then
    echo "No valid UUID found."
    exit 1
fi

# API 요청
response=$(curl -s -H "ApiKey:$name" "http://$INSTREAM_TENANT_SERVER:$INSTREAM_TENANT_SERVER_PORT/api/v1/medias/$application_id/recentSession")

# 응답에서 deletedAt 값 확인
deletedAt=$(echo $response | jq -r '.deletedAt')

# deletedAt이 null이 아닌 경우 스크립트 종료
if [ "$deletedAt" != "null" ]; then
    echo "deletedAt is not null. Exiting the script."
    exit 1
fi

# deletedAt이 null인 경우 id 추출
session_id=$(echo $response | jq -r '.id')

# UUID 유효성 검사 및 결과 처리
if [ -z "$session_id" ]; then
    echo "No valid session id found."
    exit 1
fi

/usr/local/bin/ffmpeg -i "rtmp://localhost:1935/stream?$query_params/$name" \
    -c:a aac -b:a 32k -c:v libx264 -b:v 128k -f flv -g 30 -s 640x360 rtmp://localhost:1935/hls/${session_id}_360 \
    -c:a aac -b:a 64k -c:v libx264 -b:v 256k -f flv -g 30 -s 1280x720 rtmp://localhost:1935/hls/${session_id}_720 \
    -c:a aac -b:a 128k -c:v libx264 -b:v 512k -f flv -g 30 -s 1920x1080 rtmp://localhost:1935/hls/${session_id}_1080