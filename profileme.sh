#!/bin/bash
sudo apt-get install -qq iozone3
uname=$(whoami)
sharedir=$(df /home/$uname/NFS | cut -d " " -f 1 | tail -1)
mkdir /home/$uname/log
for rsize in 1024 2048 4096 8192
do
	sudo cp /etc/fstab /home/$uname/fstab
	sudo echo "$sharedir /home/$uname/NFS nfs rw,user,noauto,rsize=$rsize 0 0" >> /home/$uname/fstab
	sudo cp /home/$uname/fstab /etc/fstab
	sudo umount /home/$uname/NFS
	sudo mount -t nfs -O uid=1000,iosharset=utf-8,rsize=$rsize $sharedir /home/$uname/NFS
	sudo iozone -a -R -c -U /home/$uname/NFS -f /home/$uname/NFS/test.img > /home/$uname/log/rs$rsize.log
done
