#!/usr/bin/env bash

PATH_REMOTE="server:/dir/sshfs"
PATH_MOUNT=$(eval echo "~/mountpoint")
PATH_CONF="/home/user/sshfs.conf"

if [[ $(mount | grep -i $PATH_MOUNT | wc -l) -gt 0 ]]; then
      read -p "Mountpoint $PATH_MOUNT already in use. Unmount? (Y/n): " ans
      case $ans in
      	[Nn]* ) break;;
      	    * ) fusermount -u $PATH_MOUNT;;
      esac
fi

echo -n "Mounting" $PATH_REMOTE "to" $PATH_MOUNT "..."

sshfs -o auto_unmount \
      -o cache=yes \
      -o compression=no \
      -o follow_symlinks \
      -o kernel_cache \
      -o large_read \
      -o uidfile=$PATH_CONF \
      -o gidfile=$PATH_CONF \
      -o uid=$(id -u `whoami`) \
      -o gid=$(id -u `whoami`) \
      $PATH_REMOTE \
      $PATH_MOUNT

echo " Done"

# benchmark results

# compression on  : 40 MB/s
#             off : 76 MB/s

# linux sys monitor : ~90 MB/s

#      -o Ciphers=arcfour \
