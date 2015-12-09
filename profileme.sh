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
									for sec in sys none
									do
										#sudo cp /home/$uname/fstab /etc/fstab
										#echo "$sharedir $local_dir nfs rw,rsize=$rsize,wsize=$wsize,actimeo=$actimeo,proto=$proto 0 0" | sudo tee --append /etc/fstab
										sudo umount $local_dir
										sudo mount.nfs $sharedir $local_dir -o rw,rsize=$rsize,wsize=$wsize,actimeo=$actimeo,proto=$proto,nfsvers=$nfsvers,$lock,$cto,$acl,$rdirplus,sec=$sec
										filename=rs$rsize
										filename+=ws$wsize
										filename+=actimeo$actimeo
										filename+=proto$proto
										filename+=v$nfsvers
										filename+=$lock
										filename+=$cto
										filename+=$acl
										filename+=$rdirplus
										filename+=$sec.log
										currentlog=$logdir/$filename
										sudo iozone -a -R -i 0 -i 1 -c -f -U $local_dir $test_file > $currentlog
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

