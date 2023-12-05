<div align=center>
	<img src="https://capsule-render.vercel.app/api?type=waving&color=auto&height=200&section=header&text=Nginx%20Media%20Server&fontSize=80&fontAlignY=36" />	
</div>
<div align=center>
	<h3>📚 Tech Stack 📚</h3>
	<p>✨ Platforms & Languages ✨</p>
</div>
<div align="center">
	<img src="https://img.shields.io/badge/NGINX RTMP-009639?style=flat&logo=NGINX&logoColor=white" />
    <img src="https://img.shields.io/badge/Shell-5391FE?style=flat&logo=powershell&logoColor=white" />
</div>
<br>

## 개요
4학년 2학기 SW캡스톤디자인 "실시간 라이브 스트리밍 SaaS" 프로젝트 중, 미디어 서버 프로젝트입니다.
<br/>
<br/>

## 미디어 서버 아키텍쳐
<div align="center">
    <img src="./architecture/nginx-rtmp.png" width="900" alt="nginx-rtmp">
</div>

## 핵심 기능
+ RTMP 영상 스트림 변환
  + OBS Studio 영상 스트림 인증 인가
  + OBS Studio 영상 스트림을 HLS 파일로 변환 (360, 720, 1080 화질 지원)
  + HLS 파일 전송

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
