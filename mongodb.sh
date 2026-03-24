#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
Validate $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
Validate $? "installed mongodb"

systemctl enable mongod 
Validate $? "enabled mongodb"

systemctl start mongod 
Validate $? "started mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
Validate $? "allowing remote connections"

systemctl restart mongod
Validate $? "restarted mongodb"

Print total_time
