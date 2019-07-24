/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            echo "nameserver {{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }}" > /etc/resolv.conf
            /usr/lib/qubes/qubes-setup-dnat-to-ns

/rw/config/network-hooks.d/hook-lan.sh:
    file.managed:
        - makedirs: True
        - mode: 755
        - source: salt://qubes-server/hook-lan.sh
        - template: jinja
