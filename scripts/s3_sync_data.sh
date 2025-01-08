# make sure AWS credentials are in ~/.aws

S3BUCKET=elixir-sco-spatial-omics

docker run \
--rm \
-v ~/.aws:/root/.aws \
--mount source=data,target=/data,readonly \
amazon/aws-cli \
s3 sync --delete --quiet \
/data \
s3://$S3BUCKET/data