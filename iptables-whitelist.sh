#!/usr/bin/sudo bash

check_ip_type()
{
    (printf %s "$1" | grep ":" > /dev/null) && echo v6 || echo v4
}

allow()
{
    type=$(check_ip_type "$1")
    if [ $type = 'v4' ]; then
        echo " * allow connection from ipv4 $1"
        iptables -A INPUT -s "$1" -p tcp --dport $PORTS -j ACCEPT
    elif [ $type = 'v6' ]; then
        echo " * allow connection from ipv6 $1"
        ip6tables -A INPUT -s "$1" -p tcp --dport $PORTS -j ACCEPT
    fi
}

firewall_begin()
{
    echo '--- Firewall setup begin ---'
    echo
    iptables -F INPUT
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    ip6tables -F INPUT
    ip6tables -A INPUT -i lo -j ACCEPT
    ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
}

firewall_end()
{
    echo
    echo '--- Firewall setup end ---'
    iptables -A INPUT -p tcp --dport $PORTS -j DROP
    ip6tables -A INPUT -p tcp --dport $PORTS -j DROP
}

dump()
{
    iptables  -n -L INPUT
    ip6tables -n -L INPUT
}

PORTS=8484:8490

firewall_begin
  allow 1.1.1.1
firewall_end
echo

dump
