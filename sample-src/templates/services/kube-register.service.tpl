# vim: set ft=yaml:

[Unit]
Description=Kubernetes Registration Service
Documentation=https://github.com/kelseyhightower/kube-register
Requires=kube-apiserver.service
After=kube-apiserver.service
Requires=fleet.service
After=fleet.service

[Service]
ExecStartPre=/usr/bin/curl -L -o /opt/bin/kube-register -z /opt/bin/kube-register https://github.com/kelseyhightower/kube-register/releases/download/v0.0.4/kube-register-0.0.4-linux-amd64
ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-register
ExecStart=/opt/bin/kube-register \
--metadata=role=node \
--fleet-endpoint=unix:///var/run/fleet.sock \
--api-endpoint=http://127.0.0.1:8080 \
--healthz-port=10248
Restart=always
RestartSec=10

[X-Fleet]
Global=true
MachineMetadata=role=master
