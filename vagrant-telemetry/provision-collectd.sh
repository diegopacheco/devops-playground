#!/bin/bash

sudo yum install -y epel-release

sudo yum --enablerepo=epel install -y collectd

#sudo systemctl start collectd
#sudo systemctl enable collectd