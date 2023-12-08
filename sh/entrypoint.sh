#!/bin/sh

envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# 환경 변수 치환
sed -i "s|\$INSTREAM_TENANT_SERVER_PORT|$INSTREAM_TENANT_SERVER_PORT|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh /app/exec_publish.sh /app/exec_publish_done.sh
sed -i "s|\$INSTREAM_TENANT_SERVER|$INSTREAM_TENANT_SERVER|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh /app/exec_publish.sh /app/exec_publish_done.sh

# watch_hls_dir.sh 내용을 여기에 복사
nohup /app/watch_hls_dir.sh > /dev/stdout 2> /dev/stderr &

# nginx 실행
exec nginx
