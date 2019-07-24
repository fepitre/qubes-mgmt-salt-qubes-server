/etc/apt/sources.list.d/notset-qubes.list:
  file.managed:
    - source: salt://qubes-server/repos/notset-qubes.list
    - mode: 0644
    - user: root
    - group: root

/tmp/RPM-GPG-KEY-notset:
  file.managed:
    - source: salt://qubes-server/keys/RPM-GPG-KEY-notset
    - mode: 0644
    - user: root
    - group: root

import-notset-key:
  cmd.run:
    - name: 'apt-key add /tmp/RPM-GPG-KEY-notset'
