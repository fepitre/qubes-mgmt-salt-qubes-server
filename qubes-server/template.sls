template-dependencies:
  pkg.installed:
    - pkgs:
      - vim
      - bridge-utils
      - ifenslave
      - dnsutils
      - openssh-server
      - isc-dhcp-server
      - isc-dhcp-relay
      - bind9
      - dns-root-data
      - openvpn
      - qubes-core-admin-client
      - qubes-core-agent-networking
      - qubes-core-agent-dom0-updates
      - qubes-core-agent-bridge-device

/etc/systemd/system/sshd.service.d/30_qubes.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/sshd

/etc/systemd/system/isc-dhcp-server.service.d/30_qubes.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/isc-dhcp-server

/etc/systemd/system/isc-dhcp-relay.service.d/30_qubes.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/isc-dhcp-relay

/etc/systemd/system/bind9.service.d/30_qubes.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/bind9

/etc/systemd/system/openvpn@.service.d/30_qubes.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/openvpn

systemd_daemon_reload:
  cmd.run:
    - name: systemctl daemon-reload
