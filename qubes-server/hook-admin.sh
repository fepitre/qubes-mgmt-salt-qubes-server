#!/bin/bash

command="$1"
vif="$2"
vif_type="$3"
ip="$4"

case "$command" in
    online)
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:admin-ns:network:front:address', '') }}" ]; then
            iptables -I FORWARD 2 -i "$vif" -d {{ salt['pillar.get']('qubes-server:admin-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:admin-sys-net:network:front:address', '') }}" ]; then
            iptables -I FORWARD 2 -i "$vif" -d {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }} -p udp --dport 1194 -m conntrack --ctstate NEW -j ACCEPT
        fi
        ;;
    offline)
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:admin-ns:network:front:address', '') }}" ]; then
            iptables -D FORWARD -i "$vif" -d {{ salt['pillar.get']('qubes-server:admin-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:admin-sys-net:network:front:address', '') }}" ]; then
            iptables -D FORWARD -i "$vif" -d {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }} -p udp --dport 1194 -m conntrack --ctstate NEW -j ACCEPT
        fi
        ;;
esac