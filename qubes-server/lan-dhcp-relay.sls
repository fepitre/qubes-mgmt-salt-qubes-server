/rw/config/qubes-bind-dirs.d/dhcp-relay.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        binds+=( '/etc/default/isc-dhcp-relay' )

bind-dirs-dhcp-relay:
  cmd.run:
    - name: /usr/lib/qubes/bind-dirs.sh umount && /usr/lib/qubes/bind-dirs.sh
    - require:
        - file: /rw/config/qubes-bind-dirs.d/dhcp-relay.conf

/etc/default/isc-dhcp-relay:
    file.managed:
        - mode: 0600
        - contents: |
            SERVERS={{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }}
            INTERFACESv4=""