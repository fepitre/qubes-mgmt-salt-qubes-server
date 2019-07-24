#!/bin/bash

command="$1"
vif="$2"
vif_type="$3"
ip="$4"

case "$command" in
    online)
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:dmz-sys-net:network:front:address', '') }}" ]; then
            ip route add {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:dmz-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:dmz-sys-net:network:back:netmask', '')) }} via {{ salt['pillar.get']('qubes-server:dmz-sys-net:network:front:address', '') }} dev "$vif"
            iptables -t raw -I PREROUTING 1 -s {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:dmz-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:dmz-sys-net:network:back:netmask', '')) }} -i "$vif" -j ACCEPT
        fi
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }}" ]; then
            iptables -I FORWARD 2 -i "$vif" -d {{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        ;;
    offline)
        if [ "$ip" == "{{ salt['pillar.get']('qubes-server:dmz-sys-net:network:front:address', '') }}" ]; then
            ip route del {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:dmz-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:dmz-sys-net:network:back:netmask', '')) }} via {{ salt['pillar.get']('qubes-server:dmz-sys-net:network:front:address', '') }} dev "$vif"
            iptables -t raw -D PREROUTING -s {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:dmz-sys-net:network:back:address', ''), salt['pillar.get']('qubes-server:dmz-sys-net:network:back:netmask', '')) }} -i "$vif" -j ACCEPT
        fi
        if [ "$ip" != "{{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }}" ]; then
            iptables -D FORWARD -i "$vif" -d {{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }} -p udp -m udp --dport 53 -j ACCEPT
        fi
        ;;
esac