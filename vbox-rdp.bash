IP_VM=192.168.100.189

RDP_USER="developer"

# ion
res_w=3836
res_h=2096

# mbp

#res_w=2880
#res_h=1700

# galaxy book
# res_w=2160
# res_h=1340

if [ -n $1 ] 
then
	args="/v:${IP_VM} /u:User /p:password /w:${res_w} /h:${res_h}"
fi
echo "xfreerdp ${args}"
xfreerdp ${args}
