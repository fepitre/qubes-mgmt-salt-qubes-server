qubes-server:
  template: debian-10-minimal
  admin-sys-firewall:
    - network:
      - front:
        - netvm: wan-sys-firewall
        - address: 10.137.5.1
  admin-sys-net:
    - pcidevs:
      - '03_00.0'
    - network:
      - front:
        - address: 10.137.5.2
      - back:
        - ifname: ens6
        - address: 10.3.0.1
        - netmask: 255.255.255.0
  admin-ns:
    - network:
      - front:
        - address: 10.137.5.3
  admin-vpn:
    - network:
      - front:
        - address: 10.137.5.4
      - vpn:
        - subnet: 10.8.0.0
        - netmask: 255.255.255.0
  admin-mgmt:
    - network:
      - front:
        - address: 10.137.5.5
    - ssh:
      - admin_authorized_key: 'ssh-rsa XXXX'