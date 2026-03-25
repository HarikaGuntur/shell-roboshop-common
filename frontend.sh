#!/bin/bash

source ./common.sh

app_name=frontend
check_root

# 1. Install (But don't start yet!)
dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

# 2. Clean the "Garbage" first
rm -rf /usr/share/nginx/html/*
rm -rf /etc/nginx/nginx.conf
rm -rf /etc/nginx/default.d/*
rm -rf /etc/nginx/conf.d/*
VALIDATE $? "Cleaning default configurations"

# 3. Download the Frontend Code
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Downloaded and unzipped frontend"

# 4. Copy your "Good" Config
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

# 5. NOW Start Nginx (Now that the config is perfect)
systemctl enable nginx &>>$LOGS_FILE
systemctl restart nginx
VALIDATE $? "Enabled and started nginx"

print_total_time