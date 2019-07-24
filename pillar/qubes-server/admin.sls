qubes-server:
  template: debian-10-minimal
  admin-sys-net:
    - pcidevs:
      - '03_00.0'
    - network:
      - front:
        - ifname: ens6
        - address: 10.3.0.1
        - netmask: 255.255.255.0
        - gateway: 10.3.0.254
        - dnsdomain: admin.qubesos.local
        - dnsnameservers: 10.3.0.254
      - back:
        - address: 10.137.5.1
  admin-sys-firewall:
    - network:
      - front:
        - address: 10.137.5.2
  admin-vpn:
    - network:
      - front:
        - address: 10.137.5.3
      - vpn:
        - subnet: 10.8.0.0
        - netmask: 255.255.255.0
  admin-mgmt:
    - network:
      - front:
        - address: 10.137.5.4
    - ssh:
      - admin_authorized_key: 'ssh-rsa XXXX'