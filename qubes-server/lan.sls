lan-sys-firewall:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: {{ salt['pillar.get']('qubes-server:lan-sys-firewall:network:front:netvm', 'none') }}
            - autostart: true
            - provides-network: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:lan-sys-firewall:network:front:address', '') }}
        - tags:
            - add:
                - created-by-admin-mgmt

lan-sys-net:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: lan-sys-firewall
{% if salt['pillar.get']('qubes-server:lan-sys-net:pcidevs') %}
            - virt_mode: hvm
{% endif %}
            - autostart: true
            - provides-network: no
            - memory: 400
            - pcidevs: {{ salt['pillar.get']('qubes-server:lan-sys-net:pcidevs', []) }}
            - ip: {{ salt['pillar.get']('qubes-server:lan-sys-net:network:front:address', '') }}
        - service:
            - enable:
                - isc-dhcp-relay
            - disable:
                - meminfo-writer
        - tags:
            - add:
                - created-by-admin-mgmt
{% if salt['pillar.get']('qubes-server:lan-sys-net:devices', []) %}
        - devices:
            - attach: {{ salt['pillar.get']('qubes-server:lan-sys-net:devices', []) }}
{% endif %}

lan-dhcp-server:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: lan-sys-firewall
            - autostart: true
            - provides-network: no
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:lan-dhcp-server:network:front:address', '') }}
        - service:
            - enable:
                - isc-dhcp-server
            - disable:
                - qubes-update-check.timer
        - tags:
            - add:
                - created-by-admin-mgmt

lan-ns:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: lan-sys-firewall
            - autostart: true
            - provides-network: no
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }}
        - service:
            - enable:
                - bind9
            - disable:
                - qubes-update-check.timer
        - tags:
            - add:
                - created-by-admin-mgmt

lan-sys-firewall-start:
    qvm.start:
        - name: lan-sys-firewall