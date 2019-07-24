/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            iptables -I INPUT 5 -p udp -m udp --dport 1194 -m conntrack --ctstate NEW -j ACCEPT
            iptables -I FORWARD 2 -i tun0 -p tcp -d {{ salt['pillar.get']('qubes-server:admin-mgmt:network:front:address', '') }} --dport 22 -m conntrack --ctstate NEW -j ACCEPT

            systemctl restart openvpn@admin