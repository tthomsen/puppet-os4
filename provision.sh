#!/bin/bash
## This script is only used by Vagrant for making our environment available
## with the right hostname resolutions and pre-downloads PE to share across
## the instances.  It's not used outside of Vagrant.
## Yeah, it's a BASH script. So what? Tool for the job, yo.

## The version of PE to make available to in our Vagrant environment

###########################################################

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/puppetlabs.repo

## Add host entries for each system
cat > /etc/hosts <<EOH
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain
::1 localhost localhost.localdomain localhost6 localhost6.localdomain
###############################################################################
192.168.1.25 master.os.vagrant.vm master
192.168.1.26 agent1.os.vagrant.vm agent1

###############################################################################
## CNAMEs for CA server
192.168.1.7 puppetca.vagrant.vm puppetca puppet.vagrant.vm puppet

EOH


service iptables stop
## Bootstrap the master(s)
if [[ "$1" == master ]]; then
  yum install puppet-server -y
  yum install puppetserver -y
fi

yum install puppet -y
