wan-sys-net:
    qvm.vm:
        - present:
            - label: red
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - autostart: true
            - netvm: {{ salt['pillar.get']('qubes-server:wan-sys-net:network:front:netvm', 'none') }}
{% if salt['pillar.get']('qubes-server:wan-sys-net:pcidevs') %}
            - virt_mode: hvm
{% endif %}
            - provides-network: true
            - memory: 400
            - pcidevs: {{ salt['pillar.get']('qubes-server:wan-sys-net:pcidevs', []) }}
            - ip: {{ salt['pillar.get']('qubes-server:wan-sys-net:network:back:address', '') }}
        - service:
            - enable:
                - clocksync
            - disable:
                - meminfo-writer
                - network-manager
        - tags:
            - add:
                - created-by-admin-mgmt
{% if salt['pillar.get']('qubes-server:wan-sys-net:devices', []) %}
        - devices:
            - attach: {{ salt['pillar.get']('qubes-server:wan-sys-net:devices', []) }}
{% endif %}

wan-sys-firewall:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: wan-sys-net
            - autostart: true
            - provides-network: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:wan-sys-firewall:network:front:address', '') }}
        - tags:
            - add:
                - created-by-admin-mgmt