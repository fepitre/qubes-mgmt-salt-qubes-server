{% set ifname = salt['pillar.get']('qubes-server:admin-sys-net:network:back:ifname', '') %}
{% set address = salt['pillar.get']('qubes-server:admin-sys-net:network:back:address', '') %}
{% set netmask = salt['pillar.get']('qubes-server:admin-sys-net:network:back:netmask', '') %}
{% set gateway = salt['pillar.get']('qubes-server:admin-sys-net:network:back:gateway', '') %}
{% set dnsdomain = salt['pillar.get']('qubes-server:admin-sys-net:network:back:dnsdomain', '') %}
{% set dnsnameservers = salt['pillar.get']('qubes-server:admin-sys-net:network:back:dnsnameservers', '') %}

/rw/config/qubes-bind-dirs.d/interfaces.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        binds+=( '/etc/network/interfaces.d' )
        binds+=( '/etc/resolv.conf' )

bind-dirs-interfaces:
  cmd.run:
    - name: /usr/lib/qubes/bind-dirs.sh umount && /usr/lib/qubes/bind-dirs.sh
    - require:
        - file: /rw/config/qubes-bind-dirs.d/interfaces.conf

/rw/bind-dirs/etc/network/interfaces.d/admin:
    file.managed:
        - mode: 0600
        - contents: |
            auto {{ ifname }}
            allow-hotplug {{ ifname }}
            iface {{ ifname }} inet static
              address {{ address }}
              netmask {{ netmask }}
              gateway {{ gateway }}

/rw/bind-dirs/etc/resolv.conf:
    file.managed:
        - mode: 0600
        - contents: |
              search {{ dnsdomain }}
              nameserver {{ dnsnameservers }}

/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            sysctl -w net.ipv4.ip_forward=1

            iptables -I INPUT 1 -s {{ salt['pillar.get']('qubes-server:admin-sys-net:network:back:address', '') }} -j ACCEPT
            iptables -I FORWARD 2 -i {{ ifname }} -o eth0 -j ACCEPT