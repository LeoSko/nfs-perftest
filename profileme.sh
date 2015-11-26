#!/bin/bash
sudo apt-get install -qq iozone3
uname=$(whoami)
sharedir=$(df /home/$uname/NFS | cut -d " " -f 1 | tail -1)
if [ -z "$sharedir" ]; then
	echo "You have to mount NFS folder into /home/$uname/NFS to run this script"
	exit 1
fi
logdir=/home/$uname/log
local_dir=/home/$uname/NFS
test_file=$local_dir/test.img
mkdir $logdir

sudo cp /etc/fstab /home/$uname/fstab
for rsize in 1024 2048 4096 8192
do
	sudo cp /home/$uname/fstab /etc/fstab
	echo "$sharedir $local_dir nfs rw,user,noauto,rsize=$rsize 0 0" | sudo tee --append /etc/fstab
#	sudo umount $local_dir
#	sudo mount -t nfs -O uid=1000,iosharset=utf-8,rsize=$rsize $sharedir $local_dir
	sudo iozone -a -R -c $local_dir -f $test_file > $logdir/rs$rsize.log
done
sudo cp /home/$uname/fstab /etc/fstab

