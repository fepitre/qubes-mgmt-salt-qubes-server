/rw/bind-dirs/pub:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 775

/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
            iptables -I INPUT 5 -i eth0 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

            useradd mirror
            chown -R mirror:mirror /pub

            rm -rf /usr/share/nginx/html/index.html
            cp /rw/config/nginx.conf /etc/nginx.conf
            cp /rw/config/mirror.conf /etc/nginx/conf.d/mirror.conf
            systemctl restart nginx

/rw/config/nginx.conf:
  file.managed:
    - makedirs: True
    - mode: 0660
    - contents: |
        user www-data;
        worker_processes auto;
        error_log /var/log/nginx/error.log;
        pid /run/nginx.pid;

        events {
            worker_connections 1024;
        }

        http {
            include      mime.types;
            default_type application/octet-stream;
            sendfile     on;
            server_tokens off;

            server {
                listen      80;
                server_name {{ salt['pillar.get']('qubes-server:pub-waf:server-name', 'mirror') }};
                
                location / {
                    root /pub;
                    autoindex on;
                }
            }
        }

/rw/config/qubes-bind-dirs.d/pub.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        binds+=( '/pub' )

bind-dirs:
  cmd.run:
    - name: /usr/lib/qubes/bind-dirs.sh umount && /usr/lib/qubes/bind-dirs.sh
    - require:
        - file: /rw/config/qubes-bind-dirs.d/pub.conf