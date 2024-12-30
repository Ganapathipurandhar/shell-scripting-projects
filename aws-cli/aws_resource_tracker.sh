#!/bin/bash

##########################################
# Author       : Purandhar
# Date         : 25th Dec
# Version      : v1.1
# Description  : This script reports AWS resource usage and stores it in a file.
##########################################

#Set -x #debug mode
#Set -e # exit the script when there is a error 
#Set -o # pipefail


# File to store resource information
output_file="/path/to/resourceTracker.txt"

# Start fresh output file
echo "AWS Resource Tracker - $(date)" > $output_file
echo "========================================" >> $output_file

# AWS S3 - List Buckets
echo "AWS S3 Buckets:" >> $output_file
if aws s3 ls >> $output_file 2>> $output_file; then
    echo "S3 Bucket list fetched successfully." >> $output_file
else
    echo "Error: Unable to fetch S3 Bucket list." >> $output_file
fi
echo "----------------------------------------" >> $output_file

# AWS EC2 - List Instances
echo "AWS EC2 Instances:" >> $output_file
if aws ec2 describe-instances --output json | jq -r '.Reservations[].Instances[].InstanceId' >> $output_file 2>> $output_file; then
    echo "EC2 Instance list fetched successfully." >> $output_file
else
    echo "Error: Unable to fetch EC2 Instances." >> $output_file
fi
echo "----------------------------------------" >> $output_file

# AWS Lambda - List Functions
echo "AWS Lambda Functions:" >> $output_file
if aws lambda list-functions --output json | jq -r '.Functions[].FunctionName' >> $output_file 2>> $output_file; then
    echo "Lambda function list fetched successfully." >> $output_file
else
    echo "Error: Unable to fetch Lambda functions." >> $output_file
fi
echo "----------------------------------------" >> $output_file

# AWS IAM - List Users
echo "AWS IAM Users:" >> $output_file
if aws iam list-users --output json | jq -r '.Users[].UserName' >> $output_file 2>> $output_file; then
    echo "IAM Users list fetched successfully." >> $output_file
else
    echo "Error: Unable to fetch IAM Users." >> $output_file
fi
echo "----------------------------------------" >> $output_file

# Set executable permissions for the script
chmod +x "$0"
