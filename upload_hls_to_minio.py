import os
import sys
from minio import Minio
from minio.error import S3Error

def upload_file_to_minio(bucket_name, file_path, minio_client):
    object_name = os.path.basename(file_path)
    try:
        minio_client.fput_object(bucket_name, object_name, file_path)
        print(f"Uploaded {file_path} to MinIO bucket {bucket_name}/{object_name}")
    except S3Error as e:
        print(f"Failed to upload {file_path}: {e}")

if __name__ == "__main__":
    bucket_name = sys.argv[1] # MinIO 버킷 이름
    file_path = sys.argv[2]   # 업로드할 파일의 경로

    minio_client = Minio(
        os.environ['MINIO_SERVER'],
        access_key=os.environ['MINIO_ACCESS_KEY'],
        secret_key=os.environ['MINIO_SECRET_KEY'],
        secure=False
    )

    upload_file_to_minio(bucket_name, file_path, minio_client)
