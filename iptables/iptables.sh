#!/bin/sh
## load module
#/sbin/modprobe iptable_nat
echo 1 > /proc/sys/net/ipv4/ip_forward

DHCP=1
IPTABLES=/sbin/iptables
LAN_IP="192.168.1.0/255.255.255.0"
LAN_IP2="224.0.0.0/240.0.0.0"
LAN_NIC=eth1
WAN_IP="218.226.229.160/255.255.255.224"
WAN_NIC=eth0
LOC_IP="127.0.0.0/255.0.0.0"
LOC_NIC=lo
BROADCAST=255.255.255.255


## initialize ip tables
$IPTABLES -t filter -F FORWARD
$IPTABLES -t filter -F INPUT
$IPTABLES -t filter -F OUTPUT
$IPTABLES -t nat -F POSTROUTING

## nat
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t nat -A POSTROUTING -s $LAN_IP -o $WAN_NIC -j MASQUERADE 

## mangle
$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P INPUT ACCEPT
$IPTABLES -t mangle -P FORWARD ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT
$IPTABLES -t mangle -P POSTROUTING ACCEPT

## filter
$IPTABLES -t filter -P INPUT DROP
$IPTABLES -t filter -P FORWARD DROP
$IPTABLES -t filter -P OUTPUT DROP

# LOC_NIC localhost
$IPTABLES -A INPUT -i $LOC_NIC -j ACCEPT 
$IPTABLES -A OUTPUT -o $LOC_NIC -j ACCEPT 

# LAN
$IPTABLES -A FORWARD -s $LAN_IP -i $LAN_NIC -o $WAN_NIC -j ACCEPT 
$IPTABLES -A FORWARD -i $WAN_NIC -o $LAN_NIC -m state --state RELATED,ESTABLISHED -j ACCEPT 
$IPTABLES -A INPUT -s $LAN_IP -i $LAN_NIC -j ACCEPT 
$IPTABLES -A OUTPUT -d $LAN_IP -o $LAN_NIC -j ACCEPT 
$IPTABLES -A INPUT -d $LAN_IP2 -i $LAN_NIC -p ! tcp -j ACCEPT 
$IPTABLES -A OUTPUT -d $LAN_IP2 -o $LAN_NIC -p ! tcp -j ACCEPT 

# WAN
if [ 1 == "$DHCP" ] ; then
  $IPTABLES -A OUTPUT -o $WAN_NIC -j ACCEPT 
else
  $IPTABLES -A OUTPUT -s $WAN_IP -o $WAN_NIC -j ACCEPT 
fi
$IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 

# broadcast
$IPTABLES -A INPUT -d $BROADCAST -i $LAN_NIC -j ACCEPT 
$IPTABLES -A INPUT -d $BROADCAST -i $WAN_NIC -j ACCEPT 
$IPTABLES -A OUTPUT -d $BROADCAST -o $LAN_NIC -j ACCEPT 
$IPTABLES -A OUTPUT -d $BROADCAST -o $WAN_NIC -j ACCEPT 


#####
# INPUT
##### 
if [ 1 == "$DHCP" ] ; then
# icmp
  $IPTABLES -A INPUT  -p icmp --icmp-type any -i $WAN_NIC -j ACCEPT 
#  $IPTABLES -A INPUT  -i $WAN_NIC -j REJECT --reject-with icmp-host-prohibited

# ftp
  $IPTABLES -A INPUT  -p tcp --dport 20 -i $WAN_NIC -j ACCEPT 
  $IPTABLES -A INPUT  -p tcp --dport 21 -i $WAN_NIC -j ACCEPT 

# ssh
  $IPTABLES -A INPUT  -p tcp --dport 22 -i $WAN_NIC -j ACCEPT 

# smtp
  $IPTABLES -A INPUT -p tcp --dport 25 -i $WAN_NIC -j ACCEPT 

# http, https
  $IPTABLES -A INPUT -p tcp --dport 80 -i $WAN_NIC -j ACCEPT 
  $IPTABLES -A INPUT -p tcp --dport 443 -i $WAN_NIC -j ACCEPT 

# auth??
  $IPTABLES -A INPUT -p tcp --dport 113 -i $WAN_NIC -j ACCEPT 
else
# icmp
  $IPTABLES -A INPUT -d $WAN_IP -p icmp --icmp-type any -i $WAN_NIC -j ACCEPT 
#  $IPTABLES -A INPUT -d $WAN_IP -i $WAN_NIC -j REJECT --reject-with icmp-host-prohibited

# ftp
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 20 -i $WAN_NIC -j ACCEPT 
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 21 -i $WAN_NIC -j ACCEPT 

# ssh
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 22 -i $WAN_NIC -j ACCEPT 

# smtp
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 25 -i $WAN_NIC -j ACCEPT 

# http, https
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 80 -i $WAN_NIC -j ACCEPT 
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 443 -i $WAN_NIC -j ACCEPT 

# auth??
  $IPTABLES -A INPUT -d $WAN_IP -p tcp --dport 113 -i $WAN_NIC -j ACCEPT 
fi

# portmap
$IPTABLES -A INPUT -s $LAN_IP -p tcp -m tcp --dport 111 -j ACCEPT
$IPTABLES -A INPUT -s $LAN_IP -p udp -m udp --dport 111 -j ACCEPT
$IPTABLES -A INPUT -s $LOC_IP -p tcp -m tcp --dport 111 -j ACCEPT 
$IPTABLES -A INPUT -s $LOC_IP -p udp -m udp --dport 111 -j ACCEPT 

$IPTABLES -A INPUT -s $LAN_IP -p tcp --dport 53 -j ACCEPT
$IPTABLES -A INPUT -s $LAN_IP -p udp --dport 53 -j ACCEPT
$IPTABLES -A INPUT -s $LOC_IP -p tcp --dport 53 -j ACCEPT
$IPTABLES -A INPUT -s $LOC_IP -p udp --dport 53 -j ACCEPT

echo <<EOF
please run bellow commnad

  check)
    iptables -L

  save)

    /etc/init.d/iptables save [ruleset]

  or

    iptables-save > PATH

  LOC_NICad)

    /etc/init.d/iptables load [ruleset]

  or

    iptables-restore < PATH
  
EOF
