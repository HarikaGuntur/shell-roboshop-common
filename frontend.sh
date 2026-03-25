#!/bin/bash

# Bringing in shared functions and variables
source ./common.sh

app_name=frontend
app_dir=/usr/share/nginx/html
check_root

# 1. Prepare Nginx Environment
dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

# 2. Initial Start
systemctl enable nginx  &>>$LOGS_FILE
systemctl start nginx  
VALIDATE $? "Enabled and started nginx"

# 3. Clean up default web content
rm -rf /usr/share/nginx/html/* VALIDATE $? "Remove default content"

# 4. Download and Deploy Frontend Artifacts
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
cd /usr/share/nginx/html  
unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Downloaded and unzipped frontend"

# 5. CRITICAL: Clear existing Nginx configs to prevent "FAILURE"
rm -rf /etc/nginx/nginx.conf
rm -rf /etc/nginx/default.d/*
rm -rf /etc/nginx/conf.d/*

# 6. Apply your custom Configuration
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

# 7. Final Restart to apply changes
systemctl restart nginx
VALIDATE $? "Restarted Nginx"

# 8. Show the execution time
print_total_time