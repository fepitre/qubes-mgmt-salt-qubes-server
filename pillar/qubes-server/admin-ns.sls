bind:
  configured_zones:
    admin.qubesos.local:
      type: master
      notify: False
  available_zones:
    admin.qubesos.local:
      file: admin.qubesos.local.zone
      soa:
        ns: ns.admin.qubesos.local
        contact: root.qubesos.local
        serial: auto
      records:
        A:
          ns: {{ salt['pillar.get']('qubes-server:admin-ns:network:front:address', '') }}
        NS:
          '@':
            - ns
  config:
    options:
        forwarders:
          - 8.8.8.8
          - 8.8.4.4
        allow-query: '{ any; }'
