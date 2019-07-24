qubes-server:
  lan-sys-firewall:
    - network:
      - front:
        - netvm: dmz-sys-firewall
        - address: 10.137.2.1
  lan-ns:
    - network:
      - front:
        - address: 10.137.2.3
  lan-sys-net:
    - devices:
      - bridge:sys-net-interfaces:br20: []
    - network:
      - front:
        - address: 10.137.2.2
      - back:
        - ifname: eth1
        - address: 10.0.0.1
        - netmask: 255.255.255.0
  lan-dhcp-server:
    - network:
      - front:
        - address: 10.0.0.253
