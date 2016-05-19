# vim: set ft=yaml:
#
# Requires /etc/environment
# /opt/bin/*.key

[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
Requires=etcd2.service flanneld.service
After=etcd2.service flanneld.service

[Service]
ExecStartPre=-/usr/bin/mkdir -p /opt/bin
ExecStartPre=/usr/bin/curl -L \
	-o /opt/bin/kube-apiserver \
	-z /opt/bin/kube-apiserver \
	https://storage.googleapis.com/kubernetes-release/release/{{K8S_VERSION}}/bin/linux/amd64/kube-apiserver
ExecStartPre=/usr/bin/chmod +x /opt/bin/kube-apiserver
ExecStartPre=/opt/bin/wupiao 127.0.0.1:2379/v2/machines
ExecStart=/opt/bin/kube-apiserver \
--service-account-key-file=/opt/bin/kube-serviceaccount.key \
--service-account-lookup=false \
--admission-control=NamespaceLifecycle,NamespaceAutoProvision,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota \
--runtime-config=api/v1 \
--allow-privileged=true \
--insecure-bind-address=0.0.0.0 \
--insecure-port=8080 \
--kubelet-https=true \
--secure-port=6443 \
--service-cluster-ip-range=10.100.0.0/16 \
--etcd-servers=http://127.0.0.1:2379 \
--public_address_override=${COREOS_PRIVATE_IPV4} \
--logtostderr=true
Restart=always
RestartSec=10

[X-Fleet]
Global=true
MachineMetadata=role=master
