#!/bin/sh

# 환경 변수 읽기
INSTREAM_TENANT_SERVER=$(printenv INSTREAM_TENANT_SERVER)
INSTREAM_TENANT_SERVER_PORT=$(printenv INSTREAM_TENANT_SERVER_PORT)
HLS_PATH=$(printenv HLS_PATH)

# nginx.conf 파일에서 변수 값 대체
sed -i "s|\$INSTREAM_TENANT_SERVER_PORT|$INSTREAM_TENANT_SERVER_PORT|g" /etc/nginx/nginx.conf
sed -i "s|\$INSTREAM_TENANT_SERVER|$INSTREAM_TENANT_SERVER|g" /etc/nginx/nginx.conf
sed -i "s|\$HLS_PATH|$HLS_PATH|g" /etc/nginx/nginx.conf

# nginx 시작
/usr/sbin/nginx -g "daemon off;"
