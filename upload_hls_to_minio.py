import os
from minio import Minio
from minio.error import S3Error

def upload_to_minio(file_path, bucket_name, object_name):
    client = Minio(
        'minio-server:9000',
        access_key='your-access-key',
        secret_key='your-secret-key',
        secure=False
    )

    try:
        client.fput_object(bucket_name, object_name, file_path)
        print(f"Uploaded {file_path} to {bucket_name}/{object_name}")
    except S3Error as e:
        print("MinIO upload failed:", e)

# 예제 파일 경로 및 버킷 이름
file_path = "/path/to/hls/file.ts"
bucket_name = "your-bucket"
object_name = os.path.basename(file_path)

upload_to_minio(file_path, bucket_name, object_name)
