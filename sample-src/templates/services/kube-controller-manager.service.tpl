# vim: set ft=yaml:

[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
Requires=kube-apiserver.service
After=kube-apiserver.service

[Service]
ExecStartPre=/usr/bin/curl -L \
	-o /opt/bin/kube-controller-manager \
	-z /opt/bin/kube-controller-manager \
	https://storage.googleapis.com/kubernetes-release/release/{{K8S_VERSION}}/bin/linux/amd64/kube-controller-manager
ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-controller-manager
ExecStart=/opt/bin/kube-controller-manager \
	--service-account-private-key-file=/opt/bin/kube-serviceaccount.key \
	--master=127.0.0.1:8080 \
	--logtostderr=true
Restart=always
RestartSec=10

[X-Fleet]
Global=true
MachineMetadata=role=master
