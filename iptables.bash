# iptables script
# for VPN NAT

# dont lock ourselves out if we have an error
iptables -P INPUT ACCEPT

# Flush all the rules in IPfilter and nat tables
iptables --flush            
iptables --delete-chain
iptables --table nat --flush
iptables --table nat --delete-chain
iptables --table mangle --flush
iptables --table mangle --delete-chain

# allow ongoing connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Setup forwarding rules
iptables -A FORWARD -i ppp0 -o enp0s25 -s 192.168.0.0/24 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -o enp0s25 -j MASQUERADE

# ALLOW
iptables -A INPUT -p TCP --dport ssh -j ACCEPT

iptables -A INPUT -p TCP --dport http -j ACCEPT
iptables -A INPUT -p TCP --dport https -j ACCEPT

# vnc / stunnel
iptables -A INPUT -p tcp -m tcp --dport  6000 -s 127.0.0.1/32 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport  7777 -j ACCEPT

# ipsec, l2tp, ppp
iptables -A INPUT -p udp -m udp --dport   50 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport  500 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 4500 -j ACCEPT

# django
iptables -A INPUT -p tcp -m tcp --dport 8000 -j ACCEPT

# ALLOW - ICMP types (ping, traceroute..)
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

### ALLOW - LAN, Desktops
# allow everything from localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p all -s 127.0.0.1 -j ACCEPT
# allow everything from VPN
iptables -A INPUT -p all -s 192.168.0.0/24 -i ppp0 -j ACCEPT

## unsecure L2TP??
# iptables -A INPUT -p udp -m policy --dir in --pol ipsec -m udp --dport 1701 -j ACCEPT
# iptables -A INPUT -p udp -m udp --dport 1701 -j REJECT --reject-with icmp-port-unreachable
# iptables -A OUTPUT -p udp -m policy --dir out --pol ipsec -m udp --sport 1701 -j ACCEPT
# iptables -A OUTPUT -p udp -m udp --sport 1701 -j REJECT --reject-with icmp-port-unreachable

# default policies
iptables -P INPUT   DROP
iptables -P FORWARD DROP
iptables -P OUTPUT  ACCEPT

# print
iptables -n -L -v
