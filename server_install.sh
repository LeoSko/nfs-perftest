#!/bin/bash
sudo apt-get update
sudo apt-get install -qq nfs-kernel-server nfs-common 
mkdir /home/$(whoami)/Share
echo -e "/home/$(whoami)/Share *(rw,insecure,nohide,no_root_squash,no_subtree_check,sync)" | grep ' ' | sudo tee --append /etc/exports > /dev/null
sudo exportfs -a
sudo /etc/init.d/nfs-kernel-server restart
echo "Test" > /home/$(whoami)/Share/Testfile
echo "DONE"
