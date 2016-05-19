# vim: set ft=yaml:

[Unit]
Description=Hyperkube Service
Documentation=https://github.com/kubernetes/kubernetes/tree/master/cluster/images/hyperkube
Requires=etcd2.service flanneld.service docker.service
After=etcd2.service flanneld.service docker.service

[Service]
ExecStart=/usr/bin/docker run \
  --volume=/:/rootfs:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:rw \
  --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
  --volume=/var/run:/var/run:rw \
  --net=host \
  --priviledged=true \
  --pid=host \
  -d \
  gcr.io/google_containers/hyperkube-amd64:v{{K8S_VERSION}} \
  /hyperkube kubelet \
    --allow-priveledged=true \
    --api-servers=http://localhost:8080 \
    --v=2 \
    --address=0.0.0.0 \
    --enable-server \
    --hostname-override=127.0.0.1 \
    --config=/etc/kubernetes/manifests-multi \
    --containerized \
    --cluster-dns=10.0.0.10 \
    --cluster-domain=cluster.local
