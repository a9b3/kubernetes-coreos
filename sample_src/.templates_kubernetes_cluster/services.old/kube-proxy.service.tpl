# vim: set ft=yaml:

[Unit]
Description=Kubernetes Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
Requires=setup-network-environment.service
After=setup-network-environment.service

[Service]
EnvironmentFile=/etc/master-environment
ExecStartPre=/usr/bin/curl -L \
	-o /opt/bin/kube-proxy \
	-z /opt/bin/kube-proxy \
	https://storage.googleapis.com/kubernetes-release/release/{{K8S_VERSION}}/bin/linux/amd64/kube-proxy
ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-proxy
# wait for kubernetes master to be up and ready
ExecStartPre=/opt/bin/wupiao ${K8S_MASTER_IPV4} 8080
ExecStart=/opt/bin/kube-proxy \
	--master=${K8S_MASTER_IPV4}:8080 \
	--logtostderr=true
Restart=always
RestartSec=10

[X-Fleet]
Global=true
MachineMetadata=role=node
