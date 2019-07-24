dhcpd:
  authoritative: true
  listen_interfaces:
    - eth0
  domain_name: lan.qubesos.local
  domain_name_servers:
    - 10.139.1.1
    - 10.139.1.2
  subnets:
    10.0.0.0:
      range: 
        - 10.0.0.10
        - 10.0.0.20
      netmask: {{ salt['pillar.get']('qubes-server:lan-sys-net:network:back:netmask', '') }}
      routers: {{ salt['pillar.get']('qubes-server:lan-sys-net:network:back:address', '') }}