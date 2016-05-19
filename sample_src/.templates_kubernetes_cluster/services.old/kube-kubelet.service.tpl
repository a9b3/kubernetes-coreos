# vim: set ft=yaml:

[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
Requires=setup-network-environment.service
After=setup-network-environment.service cephfs-mount.service

[Service]
EnvironmentFile=/etc/environment
EnvironmentFile=/etc/master-environment
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin
ExecStartPre=/usr/bin/curl -L \
	-o /opt/bin/kubelet \
	-z /opt/bin/kubelet \
	https://storage.googleapis.com/kubernetes-release/release/{{K8S_VERSION}}/bin/linux/amd64/kubelet
ExecStartPre=/usr/bin/chmod +x /opt/bin/kubelet
ExecStartPre=/opt/bin/wupiao ${K8S_MASTER_IPV4} 8080
ExecStart=/opt/bin/kubelet \
	--address=0.0.0.0 \
	--port=10250 \
	--hostname-override=${COREOS_PRIVATE_IPV4} \
	--api-servers=${K8S_MASTER_IPV4}:8080 \
	--allow-privileged=true \
	--cluster-dns=10.100.0.10 \
	--cluster-domain=cluster.local \
	--logtostderr=true \
	--cadvisor-port=4194 \
	--healthz-bind-address=0.0.0.0 \
	--healthz-port=10248
Restart=always
RestartSec=10

[X-Fleet]
Global=true
MachineMetadata=role=node
