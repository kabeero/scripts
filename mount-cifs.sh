cd /media

dirs="domain/home domain/exp domain/shared domain/pf domain/daq domain/ate domain/app"

for d in $dirs; do
	sudo mkdir -p $d
	sudo umount $d
done;

sudo mount -t cifs //domaincorp.com/folder/ /media/domain/home -o credentials=/root/.smbcredentials,iocharset=utf8,uid=kabeero,gid=kabeero,file_mode=0755,dir_mode=0755
