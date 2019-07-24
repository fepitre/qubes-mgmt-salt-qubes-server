openvpn:
  server:
    admin:
      local: {{ salt['pillar.get']('qubes-server:admin-vpn:network:front:address', '') }}
      port: 1194
      proto: udp
      topology: subnet
      dev: tun
      ca: /etc/openvpn/ssl/ca.crt
      ca_content: |
        -----BEGIN CERTIFICATE-----

        -----END CERTIFICATE-----
      cert: /etc/openvpn/ssl/server.crt
      cert_content: |
        -----BEGIN CERTIFICATE-----

        -----END CERTIFICATE-----
      key: /etc/openvpn/ssl/server.key
      key_content: |
        -----BEGIN PRIVATE KEY-----

        -----END PRIVATE KEY-----
      dh: dh2048.pem
      server: '{{ salt['pillar.get']('qubes-server:admin-vpn:network:vpn:subnet', '') }} {{ salt['pillar.get']('qubes-server:admin-vpn:network:vpn:netmask', '') }}'
      ifconfig_pool_persist: ipp.txt
      push: 
        - 'route {{ salt['pillar.get']('qubes-server:admin-mgmt:network:front:address', '') }} 255.255.255.255 10.8.0.1'
      keepalive: '10 120'
      tls_auth: /etc/openvpn/ssl/tls.key 0
      ta_content: |
        -----BEGIN OpenVPN Static key V1-----

        -----END OpenVPN Static key V1-----
      ciphers:
        - AES-256-CBC
      auths:
        - SHA384
      tls_cipher: 'DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-CAMELLIA256-SHA:DHE-RSA-AES256-SHA:DHE-RSA-CAMELLIA128-SHA:DHE-RSA-AES128-SHA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA'
      max_clients: 1
      user: nobody
      group: nogroup
      persist_key:
      persist_tun:
      status: /etc/openvpn/openvpn-status.log
      log: /etc/openvpn/openvpn.log
      log_append: /etc/openvpn/openvpn.log
      verb: 3