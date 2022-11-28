#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# install nginx
sudo amazon-linux-extras install nginx1 -y
# make sure nginx is started
systemctl start nginx