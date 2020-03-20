pub-waf:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: {{ salt['pillar.get']('qubes-server:pub-waf:network:front:netvm', 'none') }}
            - autostart: true
            - provides-network: true
            - memory: 800
            - ip: {{ salt['pillar.get']('qubes-server:pub-waf:network:front:address', '') }}
        - service:
            - enable:
                - nginx
        - tags:
            - add:
                - created-by-admin-mgmt

pub-mirror:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: pub-waf
            - autostart: true
            - provides-network: true
            - memory: 800
            - ip: {{ salt['pillar.get']('qubes-server:pub-mirror:network:front:address', '') }}
        - service:
            - enable:
                - nginx
        - tags:
            - add:
                - created-by-admin-mgmt