/rw/config/rc.local:
    file.append:
        - context:
            - mode: 755
        - text: |
            rm -rf /usr/share/nginx/html/*

            iptables -I INPUT 2 -i eth0 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
            iptables -I INPUT 2 -i eth0 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

            # SSH -> PUB-MIRROR
            iptables -t nat -A PREROUTING -i eth0 -p tcp -d {{ salt['pillar.get']('qubes-server:pub-waf:network:front:address', '') }} --dport 22 -j DNAT --to-destination {{ salt['pillar.get']('qubes-server:pub-mirror:network:front:address', '') }}
            iptables -I FORWARD 2 -i eth0 -p tcp -d {{ salt['pillar.get']('qubes-server:pub-mirror:network:front:address', '') }} --dport 22 -m conntrack --ctstate NEW -j ACCEPT

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