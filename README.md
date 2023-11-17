# nginx-rtmp
Nginx rtmp 모듈입니다. 

## 의존성

### bash
```
nginx
nginx-rtmp-module
python3 
python3-pip 
inotify-tools
```

### python
```
minio
```

## ENV
```sh
ENV MINIO_BUCKET_NAME=your-bucket-name 
ENV MINIO_ACCESS_KEY=your-access-key 
ENV MINIO_SECRET_KEY=your-secret-key 
ENV MINIO_SERVER=your-mino-server
```

## 라이브 인증
```sh
on_publish http://instream-tenant-server:8080/api;
```

nginx 설정 중 위 부분에서 아래와 같이 POST 요청을 보냅니다. 

```sh
call=play
addr - client IP address
clientid - nginx client id (displayed in log and stat)
app - application name
flashVer - client flash version
swfUrl - client swf url
tcUrl - tcUrl
pageUrl - client page url
name - stream name
```

2xx가 응답되면 publish를 시작합니다.