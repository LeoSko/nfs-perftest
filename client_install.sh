mkdir /home/$(whoami)/NFS
sudo apt-get update
sudo apt-get -qq install nfs-kernel-server nfs-common
sudo mount -t nfs -O uid=1000,iocharset=utf-8 $1:/home/$(whoami)/Share /home/$(whoami)/NFS
