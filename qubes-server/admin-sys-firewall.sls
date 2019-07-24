/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            iptables -t nat -A PREROUTING -i eth0 -p udp -d {{ salt['pillar.get']('qubes-server:admin-sys-firewall:network:front:address', '') }} --dport 1194 -j DNAT --to-destination {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }}
            iptables -I FORWARD 2 -i eth0 -p udp -d {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }} --dport 1194 -m conntrack --ctstate NEW -j ACCEPT
            nft add rule ip qubes-firewall forward meta iifname eth0 accept
