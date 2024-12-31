#!/bin/bash

echo "Welcome $USER on $HOSTNAME."
echo "#######################################################"

FREERAM=$(free -m | grep Mem | awk '{print $4}')
LOAD=`uptime | awk '{print $9}'`
ROOTFREE=$(df -h | grep '/dev/sda1' | awk '{print $4}')
CPUS=$(nproc)

echo "#######################################################"
date >> /var/log/systemhealth.log
echo "#######################################################"
echo "Available free RAM is $FREERAM MB" >> /var/log/systemhealth.log
echo "#######################################################"
echo "Current Load Average $LOAD" >> /var/log/systemhealth.log
echo "#######################################################"
echo "Free ROOT partiotion size is $ROOTFREE" >> /var/log/systemhealth.log
echo "#######################################################"
echo "No of CPU's in the system are $CPUS" >> /var/log/systemhealth.log
echo "#######################################################"