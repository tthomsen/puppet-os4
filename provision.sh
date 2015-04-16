#!/bin/bash
## This script is only used by Vagrant for making our environment available
## with the right hostname resolutions and pre-downloads PE to share across
## the instances.  It's not used outside of Vagrant.
## Yeah, it's a BASH script. So what? Tool for the job, yo.

## The version of PE to make available to in our Vagrant environment

###########################################################

#rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/puppetlabs.repo

## Add host entries for each system
cat > /etc/hosts <<EOH
###############################################################################
192.168.1.25 master.os4.vagrant.vm master
192.168.1.26 agent1.os4.vagrant.vm agent1

###############################################################################
## CNAMEs for CA server
192.168.1.25 puppetca.vagrant.vm puppetca puppet.vagrant.vm puppet
EOH


service iptables stop
## Bootstrap the master(s)
if [[ "$1" == master ]]; then
  yum install puppetserver -y
  echo "dns_alt_names = puppet,master,puppetca.vagrant.vm,puppetca,puppet.vagrant.vm" >> /etc/puppetlabs/puppet/puppet.conf
  service puppetserver start
else
  yum install puppet-agent -y
  echo "" >> /etc/puppetlabs/puppet/puppet.conf
  echo "[agent]" >> /etc/puppetlabs/puppet/puppet.conf
  echo "server =  master.os4.vagrant.vm" >> /etc/puppetlabs/puppet/puppet.conf
  sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
fi
