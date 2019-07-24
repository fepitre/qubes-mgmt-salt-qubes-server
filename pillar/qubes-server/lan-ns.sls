bind:
  configured_zones:
    lan.qubesos.local:
      type: master
      notify: False
  available_zones:
    lan.qubesos.local:
      file: lan.qubesos.local.zone
      soa:
        ns: ns.lan.qubesos.local
        contact: root.qubesos.local
        serial: auto
      records:
        A:
          ns: {{ salt['pillar.get']('qubes-server:lan-ns:network:front:address', '') }}
        NS:
          '@':
            - ns
  config:
    options:
{% if salt['pillar.get']('qubes-server:dmz-ns:network:front:address') %}
        forwarders:
          - {{ salt['pillar.get']('qubes-server:dmz-ns:network:front:address') }}
{% endif %}
        allow-query: '{ any; }'
