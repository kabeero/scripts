#STUNNEL_ID=`ps aux | grep [s]tunnel | cut -d' ' -f3`
STUNNEL_ID=`ps aux | sed -n '/[s]tunnel/s/ \+/ /gp' | cut -d' ' -f2`
sudo kill -9 $STUNNEL_ID
sudo /etc/init.d/dhcpcd restart
sudo /etc/init.d/stunnel restart
