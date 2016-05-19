# vim: set ft=yaml:

[Unit]
Description=Write Env Files
Requires=etcd2.service flanneld.service
After=etcd2.service flanneld.service

[Service]
ExecStartPre=-/usr/bin/mkdir -p /opt/env
ExecStart=echo "hi" > /opt/env/kubenetes.env
