#! /bin/bash --

T="/$0" T="${T%/*}" T="${T#/}" T="${T:-.}" T="$( cd -- "$T" && pwd )" &&
source -- "$T/../lib.sh" || exit

for t in filter nat mangle raw security ; do
  $sudo iptables-restore <"/usr/share/iptables/empty-$t.rules"
  $sudo ip6tables-restore <"/usr/share/iptables/empty-$t.rules"

done


$sudo iptables -N TCP
$sudo iptables -N UDP

$sudo iptables -P INPUT DROP
$sudo iptables -P FORWARD DROP
$sudo iptables -P OUTPUT ACCEPT

$sudo iptables -A INPUT -i lo -j ACCEPT
$sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
$sudo iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
$sudo iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
$sudo iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

$sudo iptables -A TCP -p tcp --dport 80 -j ACCEPT
$sudo iptables -A TCP -p tcp --dport 443 -j ACCEPT
$sudo iptables -A TCP -p tcp --dport 22 -j ACCEPT
$sudo iptables -A UDP -p udp --dport 5353 -j ACCEPT

$sudo iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
$sudo iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
$sudo iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable


$sudo ip6tables -N TCP
$sudo ip6tables -N UDP

$sudo ip6tables -P INPUT DROP
$sudo ip6tables -P FORWARD DROP
$sudo ip6tables -P OUTPUT ACCEPT

$sudo ip6tables -A INPUT -i lo -j ACCEPT
$sudo ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$sudo ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
$sudo ip6tables -A INPUT -p icmpv6 --icmpv6-type 128 -m conntrack --ctstate NEW -j ACCEPT
$sudo ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
$sudo ip6tables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

$sudo ip6tables -A TCP -p tcp --dport 80 -j ACCEPT
$sudo ip6tables -A TCP -p tcp --dport 443 -j ACCEPT
$sudo ip6tables -A TCP -p tcp --dport 22 -j ACCEPT
$sudo ip6tables -A UDP -p udp --dport 5353 -j ACCEPT

#$sudo ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp -j ACCEPT
$sudo ip6tables -A INPUT -p udp -j REJECT --reject-with icmp6-port-unreachable
$sudo ip6tables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
$sudo ip6tables -A INPUT -j REJECT --reject-with icmp6-port-unreachable

$sudo ip6tables -t raw -A PREROUTING -m rpfilter -j ACCEPT
$sudo ip6tables -t raw -A PREROUTING -j DROP

$sudo iptables-save >"$T/iptables.rules"
$sudo ip6tables-save >"$T/ip6tables.rules"
