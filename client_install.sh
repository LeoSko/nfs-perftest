#!/bin/bash
if test "$#" -ne 1; then
	echo "There should be a hostname of NFS server or it's ip as a parameter"
	exit 1
fi
uname=$(whoami)
remote_ip=$1
remote_folder=$remote_ip:/
local_folder=/home/$uname/NFS
echo "Connecting to $remote_ip"
mkdir $local_folder
sudo apt-get update
sudo apt-get -qq install nfs-kernel-server nfs-common
sudo mount.nfs $remote_folder $local_folder -o rw,rsize=1024,wsize=1024,actimeo=1,proto=tcp,vers=4,lock,cto,acl,rdirplus
