# nginx-rtmp
Nginx rtmp 모듈입니다. 

## ENV
```sh
ENV INSTREAM_TENANT_SERVER your-tenant-server
ENV INSTREAM_TENANT_SERVER_PORT 8080
ENV HLS_PATH /path/to/hls
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
