#!/bin/bash
if test "$#" -ne 1; then
	echo "There should be a hostname of NFS server or it's ip as a parameter"
	exit 1
fi
uname=$(whoami)
remote_ip=$1
remote_folder=$remote_ip:/home/$uname/Share
local_folder=/home/$uname/NFS
echo "Connecting to $remote_ip"
mkdir $local_folder
sudo apt-get update
sudo apt-get -qq install nfs-kernel-server nfs-common
sudo mount -t nfs -O uid=1000,iocharset=utf-8 $remote_folder $local_folder
