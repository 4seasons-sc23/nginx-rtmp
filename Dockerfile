# Nginx 이미지를 베이스로 사용
FROM nginx:latest

ENV MINIO_BUCKET_NAME=your-bucket-name 
ENV MINIO_ACCESS_KEY=your-access-key 
ENV MINIO_SECRET_KEY=your-secret-key 
ENV MINIO_SERVER=your-mino-server

# Python과 필요한 도구 설치
RUN apt-get update && \
    apt-get install -y python3 python3-pip inotify-tools && \
    rm -rf /var/lib/apt/lists/*

# Python 라이브러리 설치 (MinIO 클라이언트)
RUN pip3 install minio

# Nginx RTMP 모듈 설치
RUN apt-get update && \
    apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev wget && \
    wget http://nginx.org/download/nginx-$(nginx -v 2>&1 | grep -o '[0-9.]*').tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    tar -zxvf nginx-*.tar.gz && unzip master.zip && \
    cd nginx-* && \
    ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && \
    make && make install

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/nginx.conf

# 스크립트 파일 복사
COPY watch_hls_dir.sh /app/watch_hls_dir.sh
COPY upload_to_minio.py /app/upload_to_minio.py

# 스크립트 실행 가능하게 설정
RUN chmod +x /app/watch_hls_dir.sh
RUN chmod +x /app/upload_to_minio.py

# HLS 파일을 저장할 디렉토리 생성
RUN mkdir -p /var/www/html/hls

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
