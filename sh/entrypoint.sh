#!/bin/sh

# 환경 변수 치환
sed -i "s|\$INSTREAM_TENANT_SERVER_PORT|$INSTREAM_TENANT_SERVER_PORT|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh
sed -i "s|\$INSTREAM_TENANT_SERVER|$INSTREAM_TENANT_SERVER|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh
sed -i "s|\$HLS_PATH|$HLS_PATH|g" /etc/nginx/nginx.conf

# 로깅 스크립트 백그라운드 실행
nohup /app/process_logging.sh > /dev/stdout 2> /dev/stderr &

# nginx 실행
exec /usr/sbin/nginx -g "daemon off;"
