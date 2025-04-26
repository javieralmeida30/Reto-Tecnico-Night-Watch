#!/usr/bin/env python3

import boto3
import datetime

# Config
region = "us-east-1"
private_instance_id = "InstanceId"
bucket_name = "BucketName"
namespace = "AWS/EC2"
metrics = [
    "CPUUtilization",
    "NetworkIn",
    "NetworkOut",
    "EBSReadBytes",
    "EBSWriteBytes",
    "EBSReadOps",
    "EBSWriteOps",
    "StatusCheckFailed",
    "StatusCheckFailed_Instance",
    "StatusCheckFailed_System"
]

end_time = datetime.datetime.utcnow()
start_time = end_time - datetime.timedelta(hours=24)
today_str = end_time.strftime('%Y-%m-%d')
log_path = f"/tmp/metrics-{today_str}.txt"

cloudwatch = boto3.client("cloudwatch", region_name=region)
s3 = boto3.client("s3", region_name=region)

with open(log_path, "w") as f:
    f.write(f"Métricas del {today_str} para {private_instance_id}\n\n")
    for metric in metrics:
        response = cloudwatch.get_metric_statistics(
            Namespace=namespace,
            MetricName=metric,
            Dimensions=[{"Name": "InstanceId", "Value": private_instance_id}],
            StartTime=start_time,
            EndTime=end_time,
            Period=3600,
            Statistics=["Average"]
        )
        datapoints = response.get("Datapoints", [])
        datapoints.sort(key=lambda x: x["Timestamp"])
        f.write(f"{metric}:\n")
        if datapoints:
            for dp in datapoints:
                ts = dp["Timestamp"].strftime('%Y-%m-%d %H:%M:%S')
                avg = round(dp["Average"], 2)
                f.write(f"  {ts} UTC - {avg}\n")
        else:
            f.write("  No data\n")
        f.write("\n")

# Upload to S3
s3.upload_file(log_path, bucket_name, f"metrics/{today_str}.txt")
print(f"✅ Upload to s3://{bucket_name}/metrics/{today_str}.txt")

# crontab -e example: 0 2 * * * /usr/bin/python3 /home/ec2-user/scripts/log_metrics.py >> /home/ec2-user/cron.log 2>&1 run 2 am every day
