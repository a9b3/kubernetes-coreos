# Kubernetes Cluster on CoreOS

Install this. I am using this to do the templating.

```sh
npm i -g hbs-templater
```

Overview parts of the cluster.

1. Dedicated ETCD cluster.
2. Master Kubernetes node. (Requires ETCD Cluster IPs)
4. Minion Kubernetes nodes.

## Super Quick Start

```sh
./scripts/generate_config.sh
./scripts/compile_etcd_cluster.sh
# => outputs/etcd/

./scripts/create_cluster_root_ca.sh
./scripts/create_cluster_admin_keypair.sh
# => certs/

ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379 ./scripts/compile_kubernetes_master_node.sh
# => outputs/master
# Get outputs/master/certs/* into the machine /etc/kubernetes/ssl

MASTER_IP=172.17.8.201 ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379 ./scripts/compile_kubernetes_minion_node.sh
# => outputs/minion
```

## Generate config.env

This should only be done ONCE per cluster. This will create `scripts/config.env` which will be used to generate the files for the etcd, master, minion node user-data.

```sh
./scripts/generate_config.sh
# => generated ./scripts/config.env
```

## Dedicated ETCD Cluster

Now generate the templates for starting a etcd cluster. This script will output files into `output/etcd`.

```sh
./scripts/compile_etcd_cluster.sh
```

You can follow along by using vagrant, or just use the user-data files to start them up in digital ocean.

#### Vagrant

Go into the folder with the compiled assets and start the cluster.

```sh
cd output/etcd
vagrant up
```

This will start up the cluster. You can ssh into one of the nodes to check it out.

```sh
vagrant ssh core-01
```

Inside the CoreOS machine you can run a few commands to explore what it's doing.

```sh
fleetctl list-machines
etcdctl ls
etcdctl member list
etcdctl cluster-health
```

So it looks good. We just set up a dedicated etcd cluster with 3 nodes. You can then target this cluster by its list of IPs. You can get the list of IPs by running `fleetctl list-machines`.

## Generate Certs

First generate the cluster root ca. Run this script which will generate the following files into `<project_dir>/certs`.

- ca-key.pem
- ca.pem
- admin-key.pem
- admin.pem

```sh
./scripts/create_cluster_root_ca.sh
./scripts/create_cluster_admin_keypair.sh
```

## Kubernetes Master Node

Now you have the dedicated etcd cluster up and running and the certs you can generate the kubernetes master node. If you are following along and starting everything locally using vagrant use these values. Otherwise obtain the IPs of the etcd cluster by sshing and running `fleetctl list-machines`.

```sh
# IMPORTANT:
# If you are using the test stuff and vagrant then these will be the addresses
# ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379
ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379 ./scripts/compile_kubernetes_master_node.sh
```

You will need to get `outputs/master/certs/*` into the machine `/etc/kubernetes/ssl` during the provisioning process.

**TODO**: write how to do this

#### Vagrant

Now go start the box. The supplied Vagrantfile will automatically put certs into the machine.

```sh
cd output/master
vagrant up
```

If you ssh into this box you can see that it is connected to the etcd cluster.

```sh
vagrant ssh

# inside box
# You should see 3 etcd nodes and 1 kubernetes master node
fleetctl list-machines
```

You can also see that docker is using flannel by seeing the ip assigned to docker0.

```sh
ifconfig
# docker0's inet should be in the range specified
```

## Kubectl

Now you have an etcd cluster up and a kubernetes master node up. You can connect to the cluster at this point using kubectl.

First let's download kubectl on our local machine.

```sh
brew install kubectl
kubectl version
```

#### Vagrant

Running this script and giving it the ip of the master node will set up your kubectl to communicate with the vagrant master node.

```
# ./scripts/setup_kubectl.sh <MASTER NODE IP>
# If you are following along this will be the IP assigned to the master node
./setup_kubectl.sh 172.17.8.201
```

Now if you run kubectl you should see some stuff.

```sh
kubectl get nodes
# should see the master node
```

## Kubernetes Minion Nodes

You will need the ip of the master node and the ips of the etcd cluster nodes.

```sh
MASTER_IP=172.17.8.201 ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379 ./scripts/compile_kubernetes_minion_node.sh
```