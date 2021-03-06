#!/bin/bash
sudo apt-get update
sudo apt-get install -qq nfs-kernel-server nfs-common 
mkdir /home/$(whoami)/Share
echo -e "/home/$(whoami)/Share *(fsid=0,anonuid=1000,anongid=1000,rw,sec=sys:none,no_subtree_check,sync)" | grep ' ' | sudo tee --append /etc/exports > /dev/null
sudo exportfs -a
sudo /etc/init.d/nfs-kernel-server restart
echo "Test" > /home/$(whoami)/Share/Testfile
echo "DONE"
