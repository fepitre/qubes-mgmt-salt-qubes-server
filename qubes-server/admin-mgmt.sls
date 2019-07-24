/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            iptables -I INPUT 5 -p tcp -s {{ salt['network.calc_net'](salt['pillar.get']('qubes-server:admin-vpn:network:vpn:subnet', ''), salt['pillar.get']('qubes-server:admin-vpn:network:vpn:netmask', '')) }} --dport 22 -m conntrack --ctstate NEW -j ACCEPT

admin_authorized_key:
  ssh_auth.present:
    - user: user
    - config: '%h/.ssh/authorized_keys'
    - names:
        - {{ salt['pillar.get']('qubes-server:admin-vpn:ssh:admin_authorized_key', '') }}