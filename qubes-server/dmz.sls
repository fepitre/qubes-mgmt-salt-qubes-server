dmz-sys-firewall:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: {{ salt['pillar.get']('qubes-server:dmz-sys-firewall:network:front:netvm', 'none') }}
            - autostart: true
            - provides-network: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:dmz-sys-firewall:network:front:address', '') }}
        - tags:
            - add:
                - created-by-admin-mgmt

dmz-sys-net:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: dmz-sys-firewall
{% if salt['pillar.get']('qubes-server:dmz-sys-net:pcidevs') %}
            - virt_mode: hvm
{% endif %}
            - autostart: true
            - provides-network: no
            - memory: 400
            - pcidevs: {{ salt['pillar.get']('qubes-server:dmz-sys-net:pcidevs', []) }}
            - ip: {{ salt['pillar.get']('qubes-server:dmz-sys-net:network:front:address', '') }}
        - service:
            - disable:
                - meminfo-writer
        - tags:
            - add:
                - created-by-admin-mgmt
{% if salt['pillar.get']('qubes-server:dmz-sys-net:devices', []) %}
        - devices:
            - attach: {{ salt['pillar.get']('qubes-server:dmz-sys-net:devices', []) }}
{% endif %}

dmz-ns:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: dmz-sys-firewall
            - autostart: true
            - provides-network: no
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }}
        - service:
            - enable:
                - bind9
            - disable:
                - qubes-update-check.timer
        - tags:
            - add:
                - created-by-admin-mgmt

dmz-sys-firewall-start:
    qvm.start:
        - name: dmz-sys-firewall