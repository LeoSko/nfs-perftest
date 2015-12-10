#!/bin/bash
sudo apt-get install -qq iozone3
uname=$(whoami)
sharedir=$(df /home/$uname/NFS | cut -d " " -f 1 | tail -1)
if [ "$sharedir" == "/dev/sda1" ]; then
	echo "You have to mount NFS folder into /home/$uname/NFS to run this script"
	exit 1
fi
logdir=/home/$uname/log
local_dir=/home/$uname/NFS
test_file=$local_dir/test.img
mkdir $logdir

sudo cp /etc/fstab /home/$uname/fstab
for rsize in 1024 4096 16384 65536 262144 1048576
do
	for wsize in 1024 4096 16384 65536 262144 1048576
	do
		for actimeo in 1 5 30
		do
			for proto in tcp udp
			do
				for nfsvers in 3 4
				do
					for lock in lock nolock
					do
						for cto in cto nocto
						do
							for acl in acl noacl
							do
								for rdirplus in rdirplus nordirplus
								do
									for sec in sys
									do
										#sudo cp /home/$uname/fstab /etc/fstab
										#echo "$sharedir $local_dir nfs rw,rsize=$rsize,wsize=$wsize,actimeo=$actimeo,proto=$proto 0 0" | sudo tee --append /etc/fstab
										sudo umount $local_dir
										sudo mount.nfs $sharedir $local_dir -o rw,rsize=$rsize,wsize=$wsize,actimeo=$actimeo,proto=$proto,vers=$nfsvers,$lock,$cto,$acl,$rdirplus,sec=$sec
										filename=rs$rsize
										filename+=_ws$wsize
										filename+=_actimeo$actimeo
										filename+=_proto$proto
										filename+=_v$nfsvers
										filename+=_$lock
										filename+=_$cto
										filename+=_$acl
										filename+=_$rdirplus
										filename+=_$sec.log
										currentlog=$logdir/$filename
										echo "Doing $filename"
										check=$(sudo cat /proc/mounts | grep nfs)
										echo "$check"
										if [ -z "$check" ]; then
											echo "err" >> $currentlog
											continue
										fi
										sudo iozone -a -R -g 65536 -c -f -U $local_dir $test_file > $currentlog
									done
								done
							done
						done
					done
				done
			done
		done
	done
done
sudo cp /home/$uname/fstab /etc/fstab

