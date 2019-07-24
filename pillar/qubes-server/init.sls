qubes-server:
  template: debian-10-minimal
  sys-net-interfaces:
    - pcidevs:
      - '01_00.0'
      - '02_00.0'
    - pci_strictreset: false
    - network:
      - bond:
        - name: bond0
        - mode: 802.3ad
        - interfaces:
          - ens6
          - ens7
      - vlan:
        - device: bond0
        - tags:
          - 10
          - 20
          - 30
        - bridge: true