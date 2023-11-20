# 빌드를 위한 임시 이미지
FROM docker.io/library/nginx:alpine as builder

# 환경 변수 설정
ENV INSTREAM_TENANT_SERVER your-tenant-server
ENV INSTREAM_TENANT_SERVER_PORT 8080
ENV HLS_PATH /path/to/hls

RUN export NGINX_VERSION=$(nginx -v 2>&1 | grep -o '[0-9.]*')

RUN echo $NGINX_VERSION > nginx_version.txt

# 필요한 빌드 도구 및 의존성 설치 (로깅 최소화)
RUN apk update --quiet && apk add --no-cache --quiet \
    build-base \
    pcre-dev \
    openssl-dev \
    zlib-dev \
    wget \
    unzip \
    linux-headers

# Nginx 버전 추출
RUN NGINX_VERSION=$(nginx -v 2>&1 | grep -o '[0-9.]*')

# Nginx 및 RTMP 모듈 다운로드 및 컴파일 (로깅 최소화)
RUN wget -q http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    wget -q https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    tar -zxvf nginx-$NGINX_VERSION.tar.gz && unzip -qq master.zip && \
    cd nginx-$NGINX_VERSION && \
    ./configure \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/log/nginx/nginx.pid \
        --with-http_ssl_module \
        --add-module=../nginx-rtmp-module-master && \
    make && make install

# 최종 이미지
FROM docker.io/library/nginx:alpine

# 환경 변수 설정
ENV INSTREAM_TENANT_SERVER your-tenant-server
ENV INSTREAM_TENANT_SERVER_PORT 8080
ENV HLS_PATH /path/to/hls

# 필요한 도구 설치
RUN apk add --no-cache inotify-tools curl pcre ffmpeg

COPY --from=builder nginx_version.txt nginx_version.txt

RUN export NGINX_VERSION=$(cat nginx_version.txt)

# 빌드된 Nginx 및 RTMP 모듈 복사
COPY --from=builder /nginx-$NGINX_VERSION/objs/nginx /usr/sbin/nginx
RUN chmod +x /usr/sbin/nginx
RUN ls -al /usr/sbin/nginx

# Nginx 설정 파일 및 스크립트 복사
COPY nginx.conf /etc/nginx/nginx.conf
COPY sh/ /app/
RUN chmod +x /app/*.sh

# RTMP 로그 확인
RUN mkdir -p /var/log/nginx/rtmp && \
    touch /var/log/nginx/rtmp/access.log

# FFmpeg 로그 확인
RUN mkdir -p /var/log/ffmpeg && \
    touch /var/log/ffmpeg/all.log && \
    chmod -R 755 /var/log/ffmpeg

# Upload 로그 확인
RUN mkdir -p /var/log/hls && \
    touch /var/log/hls/all.log && \
    chmod -R 755 /var/log/hls

COPY sh/init.sh /app/init.sh
RUN chmod +x /app/init.sh

ENTRYPOINT sed -i "s|\$INSTREAM_TENANT_SERVER_PORT|$INSTREAM_TENANT_SERVER_PORT|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh && \ 
    sed -i "s|\$INSTREAM_TENANT_SERVER|$INSTREAM_TENANT_SERVER|g" /etc/nginx/nginx.conf /app/watch_hls_dir.sh && \
    sed -i "s|\$HLS_PATH|$HLS_PATH|g" /etc/nginx/nginx.conf && /usr/sbin/nginx -g "daemon off;"