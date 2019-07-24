#!/bin/bash

command="$1"
vif="$2"
vif_type="$3"
ip="$4"

case "$command" in
    online)
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }}" ]; then
            ip route add {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:lan-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:lan-sys-net:network:back:netmask', '')) }} via {{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }} dev "$vif"

            # lan-sys-net <-> lan-dhcp-server
            iptables -I FORWARD 2 -s {{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }} -d {{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }} -p udp --dport 67:68 --sport 67:68 -j ACCEPT
            iptables -I FORWARD 2 -s {{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }} -d {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:lan-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:lan-sys-net:network:back:netmask', '')) }} -p udp --dport 67:68 --sport 67:68  -j ACCEPT
        fi
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }}" ]; then
            iptables -I FORWARD 2 -i "$vif" -d {{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        ;;
    offline)
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }}" ]; then
            ip route del {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:lan-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:lan-sys-net:network:back:netmask', '')) }} via {{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }} dev "$vif"
            
            # lan-sys-net <-> lan-dhcp-server
            iptables -D FORWARD -s {{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }} -d {{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }} -p udp --dport 67:68 --sport 67:68 -j ACCEPT
            iptables -D FORWARD -s {{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }} -d {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:lan-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:lan-sys-net:network:back:netmask', '')) }} -p udp --dport 67:68 --sport 67:68  -j ACCEPT
        fi
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }}" ]; then
            iptables -D FORWARD -i "$vif" -d {{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        ;;
esac