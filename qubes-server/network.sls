sys-net-interfaces:
    qvm.vm:
        - present:
            - label: red
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: none
            - virt_mode: hvm
            - autostart: true
            - provides-network: true
            - memory: 400
            - pcidevs: {{ salt['pillar.get']('qubes-server:sys-net-interfaces:pcidevs', []) }}
            - pci_strictreset: {{ salt['pillar.get']('qubes-server:sys-net-interfaces:pci_strictreset', 'true') }}
        - service:
            - disable:
                - meminfo-writer