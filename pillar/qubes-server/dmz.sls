qubes-server:
  dmz-sys-firewall:
    - network:
      - front:
        - netvm: wan-sys-firewall
        - address: 10.137.4.1
  dmz-sys-net:
    - devices:
      - bridge:sys-net-interfaces:br30: []
    - network:
      - front:
        - address: 10.137.4.2
      - back:
        - ifname: eth1
        - address: 10.1.0.1
        - netmask: 255.255.255.0
  dmz-ns:
    - network:
      - front:
        - address: 10.137.4.3
