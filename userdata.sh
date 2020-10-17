#!/bin/bash
# This script installs and starts the Apache 2 to the Amazon 2 Linux (Centos)
yum -y update
yum -y install httpd
systemctl start httpd
systemctl enable httpd

