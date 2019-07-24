admin-sys-net:
    qvm.vm:
        - present:
            - label: red
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: {{ salt['pillar.get']('qubes-server:admin-sys-net:network:front:netvm', 'none') }}
{% if salt['pillar.get']('qubes-server:admin-sys-net:pcidevs') %}
            - virt_mode: hvm
{% endif %}
            - autostart: true
            - provides-network: true
            - memory: 400
            - pcidevs: {{ salt['pillar.get']('qubes-server:admin-sys-net:pcidevs', []) }}
            - ip: {{ salt['pillar.get']('qubes-server:admin-sys-net:network:back:address', '') }}
        - service:
            - disable:
                - meminfo-writer
        - tags:
            - add:
                - created-by-admin-mgmt
        - devices:
            - attach: {{ salt['pillar.get']('qubes-server:admin-sys-net:devices', []) }}

admin-sys-firewall:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: admin-sys-net
            - autostart: true
            - provides-network: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:admin-sys-firewall:network:front:address', '') }}
        - tags:
            - add:
                - created-by-admin-mgmt

admin-vpn:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: admin-sys-firewall
            - autostart: true
            - provides-network: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }}
        - service:
            - enable:
                - openvpn
        - tags:
            - add:
                - created-by-admin-mgmt

admin-mgmt:
    qvm.vm:
        - present:
            - label: green
        - prefs:
            - template: {{ salt['pillar.get']('qubes-server:template', 'debian-10-minimal') }}
            - netvm: admin-vpn
            - autostart: true
            - memory: 400
            - ip: {{ salt['pillar.get']('qubes-server:admin-mgmt:network:front:address', '') }}
        - service:
            - enable:
                - sshd
        - tags:
            - add:
                - created-by-admin-mgmt

/etc/qubes-rpc/policy/include/admin-local-rwx:
  file.line:
    - mode: ensure
    - after: '## Add your entries here.*'
    - content: |
        admin-mgmt @adminvm allow,target=@adminvm
        admin-mgmt @tag:created-by-admin-mgmt allow,target=dom0

/etc/qubes-rpc/policy/admin.vm.Create.AppVM:
  file.line:
    - mode: ensure
    - after: '\$include.*'
    - content: admin-mgmt @adminvm allow,target=@adminvm

{%- for policy in ['admin.vm.Remove', 'admin.vm.List', 'admin.label.List'] %}
/etc/qubes-rpc/policy/{{policy}}:
  file.line:
    - mode: ensure
    - after: '\$include.*'
    - content: admin-mgmt @tag:created-by-admin-mgmt allow,target=dom0
{%- endfor %}

admin-sys-net-start:
    qvm.start:
        - name: admin-sys-net

admin-sys-firewall-start:
    qvm.start:
        - name: admin-sys-firewall

admin-vpn-start:
    qvm.start:
        - name: admin-vpn
