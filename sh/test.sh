#!/bin/sh

curl http://10.16.16.41:31371/api/v1/hls/upload/360 -H "ApiKey:15104ce4-6383-4d74-86f3-009b035553c1" -F "ts=@/tmp/hls/15104ce4-6383-4d74-86f3-009b035553c1_360/1.ts;type=video/MP2T" -F "m3u8=@/tmp/hls/15104ce4-6383-4d74-86f3-009b035553c1_360/index.m3u8;type=application/vnd.apple.mpegurl" -F "m3u8Main=@/tmp/hls/15104ce4-6383-4d74-86f3-009b035553c1.m3u8;type=application/vnd.apple.mpegurl"