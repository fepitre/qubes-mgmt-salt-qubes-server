qubes-server:
  pub-waf:
    - devices:
      - bridge:sys-net-interfaces:br40: []
    - network:
      - front:
        - ifname: eth0
        - address: 10.4.0.1
        - netmask: 255.255.255.0
        - gateway: 10.4.0.254
        - dnsdomain: qubesos.local
        - dnsnameservers: 10.4.0.254
      - back:
        - address: 10.137.5.1
  pub-waf:
    - network:
      - front:
        - address: 10.137.5.2
    - server-name: mirror.qubes-os.org