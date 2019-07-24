qubes-server:
  wan-sys-net:
    - devices:
      - bridge:sys-net-interfaces:br10: []
    - network:
      - front:
        - ifname: eth0
        - address: 10.2.0.1
        - netmask: 255.255.255.0
        - gateway: 10.2.0.254
        - dnsdomain: qubesos.local
        - dnsnameservers: 10.2.0.254
      - back:
        - address: 10.137.1.1
  wan-sys-firewall:
    - network:
      - front:
        - address: 10.137.1.2