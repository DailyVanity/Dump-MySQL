#!/bin/sh
DB_PASSWORD="${INPUT_DB_PASSWORD}"
DB_USERNAME="${INPUT_DB_USERNAME}"
DB_NAME="${INPUT_DB_NAME}"
DB_HOST="${INPUT_DB_HOST}"
TIME=`/bin/date +%d-%m-%Y-%T`

S3_BUCKET="${INPUT_S3_BUCKET}"
S3_PATH="${INPUT_S3_PATH:=''}"
S3_LOC="$S3_BUCKET/$S3_PATH"
S3_DB_DUMPFILE="$INPUT_DB_NAME_$TIME.sql.gz"
DESTLATEST="latest.sql.gz"

mysqldump -h $DB_HOST -u $DB_USERNAME -p$PASSWORD $DB_NAME | gzip > ./$S3_DB_DUMPFILE

# Upload tar to s3
export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_KEY
export AWS_DEFAULT_REGION=$INPUT_AWS_REGION
aws s3 cp ./$S3_DB_DUMPFILE s3://$S3_LOC/
aws s3 cp s3://$S3_LOC/$S3_DB_DUMPFILE  s3://$BUCKET/$BUCKETDIR/$DESTLATEST

rm -rf ./$S3_DB_DUMPFILE