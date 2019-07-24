{% set ifname = salt['pillar.get']('qubes-server:wan-sys-net:network:front:ifname', '') %}
{% set address = salt['pillar.get']('qubes-server:wan-sys-net:network:front:address', '') %}
{% set netmask = salt['pillar.get']('qubes-server:wan-sys-net:network:front:netmask', '') %}
{% set gateway = salt['pillar.get']('qubes-server:wan-sys-net:network:front:gateway', '') %}
{% set dnsdomain = salt['pillar.get']('qubes-server:wan-sys-net:network:front:dnsdomain', '') %}
{% set dnsnameservers = salt['pillar.get']('qubes-server:wan-sys-net:network:front:dnsnameservers', '') %}

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

/rw/bind-dirs/etc/network/interfaces.d/wan:
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
            /usr/lib/qubes/qubes-setup-dnat-to-ns