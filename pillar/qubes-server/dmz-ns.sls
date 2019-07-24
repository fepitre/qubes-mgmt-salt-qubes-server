bind:
  configured_zones:
    dmz.qubesos.local:
      type: master
      notify: False
  available_zones:
    dmz.qubesos.local:
      file: dmz.qubesos.local.zone
      soa:
        ns: ns.dmz.qubesos.local
        contact: root.qubesos.local
        serial: auto
      records:
        A:
          ns: {{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address', '') }}
        NS:
          '@':
            - ns
  config:
    options:
        forwarders:
          - 8.8.8.8
          - 8.8.4.4
        allow-query: '{ any; }'
