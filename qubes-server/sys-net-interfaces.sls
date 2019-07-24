/rw/config/qubes-bind-dirs.d/interfaces.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        binds+=( '/etc/network/interfaces.d' )

bind-dirs-interfaces:
  cmd.run:
    - name: /usr/lib/qubes/bind-dirs.sh umount && /usr/lib/qubes/bind-dirs.sh
    - require:
        - file: /rw/config/qubes-bind-dirs.d/interfaces.conf

{% if salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:name') %}
/rw/bind-dirs/etc/network/interfaces.d/10_bond:
    file.managed:
        - mode: 0600
        - contents: |
{% for iface in salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:interfaces', []) %}
            auto {{ iface }}
            iface {{ iface }} inet manual
{% endfor %}

            auto {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:name', '' ) }}
            iface {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:name', '' ) }} inet manual
                slaves {% for iface in salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:interfaces', []) %}{{ iface }} {% endfor %}
                bond-mode {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:bond:mode', '') }}
{% endif %}

{% if salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:device') %}
/rw/bind-dirs/etc/network/interfaces.d/20_vlan:
    file.managed:
        - mode: 0600
        - contents: |
{% for tag in salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:tags', []) %}
            auto {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:device', '') }}.{{tag}}
            iface {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:device', '') }}.{{tag}} inet manual
                vlan_raw_device {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:device', '') }}

{% if salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:bridge') %}            
            auto br{{tag}}
            iface br{{tag}} inet manual
                bridge_ports {{ salt['pillar.get']('qubes-server:sys-net-interfaces:network:vlan:device', '') }}.{{tag}}
                bridge_maxwait 5
                bridge_stp off
                bridge_fd 0
{% endif %}
{% endfor %}
{% endif %}

{% if salt['pillar.get']('qubes-server:sys-net-interfaces:network:bridge') %}
/rw/bind-dirs/etc/network/interfaces.d/30_bridge:
    file.managed:
        - mode: 0600
        - contents: |
{% for iface in salt['pillar.get']('qubes-server:sys-net-interfaces:network:bridge:interfaces', []) %}
            auto br{{loop.index0}}
            iface br{{loop.index0}} inet manual
                bridge_ports {{iface}}
                bridge_maxwait 5
                bridge_stp off
                bridge_fd 0
{% endfor %}
{% endif %}

/rw/config/rc.local:
    file.managed:
        - makedirs: True
        - mode: 0755
        - contents: |
            modprobe br_netfilter
            echo 0 > /proc/sys/net/bridge/bridge-nf-call-arptables
            echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables
            echo 0 > /proc/sys/net/bridge/bridge-nf-call-ip6tables
            
            iptables -F
            iptables -F -t nat

            iptables -P INPUT ACCEPT
            iptables -P OUTPUT ACCEPT
            iptables -P FORWARD ACCEPT

            iptables -A FORWARD -i vif+ -o vif+ -j ACCEPT

            iptables -t nat -A POSTROUTING -o vif+ -j ACCEPT
            iptables -t nat -A POSTROUTING -j MASQUERADE
