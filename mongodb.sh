#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "installed mongodb"

systemctl enable mongod 
VALIDATE $? "enabled mongodb"

systemctl start mongod 
VALIDATE $? "started mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connections"

systemctl restart mongod
VALIDATE $? "restarted mongodb"

print_total_time