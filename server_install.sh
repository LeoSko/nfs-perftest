#!/bin/bash
sudo apt-get update
sudo apt-get install -qq nfs-kernel-server nfs-common 
mkdir /home/$(whoami)/Share
echo -e "/home/$(whoami)/Share $(hostname -I | xargs)\b/255.255.255.0(rw,insecure,nohide,all_squash,anonuid=1000,anongid=1000,no_subtree_check)" | grep ' ' | sudo tee --append /etc/exports > /dev/null
sudo /etc/init.d/nfs-kernel-server restart
sudo exportfs -a
echo "Test" > /home/$(whoami)/Share/Testfile
echo "DONE"
