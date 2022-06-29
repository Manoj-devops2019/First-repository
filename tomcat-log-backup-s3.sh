#!/bin/sh
# Preserve tomcat logs to s3
################################################################


#provide path of log 
LOG_PATH=/opt/app/tomcat_ob2_70/logs

TODAY=`date +%Y-%m-%d-%H-%M`
HOST=`hostname -i`
s3_bucket=s3://orderbook-dev-terraform/
filename=file_${TODAY}_${HOST}.zip



cd ${LOG_PATH}
zip -r ${filename} file.log
/usr/local/bin/aws s3 cp ${filename} ${s3_bucket}
echo "The logs for orderbook has been backed up to S3 bucket ${s3_bucket}-${filename}"
rm -rf ${filename}