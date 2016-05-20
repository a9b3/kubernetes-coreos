# Kubernetes Cluster on CoreOS

Overview parts of the cluster.

1. Dedicated ETCD cluster.
2. Master Kubernetes node.
3. Minion Kubernetes nodes.

## Get kubectl

First let's download kubectl on our local machine so we can test the cluster as we set it up. 

```sh
brew install kubectl
kubectl version
```

## Dedicated ETCD Cluster

First generate the config.env that will be used to compile the templates.

```sh
# Generate the config.env for cluster
# Run only once per cluster
# You can change the settings inside generate_config.sh
./scripts/generate_config.sh
```

Now compile the template for starting a vagrant etcd cluster.

```sh
# Then generate the files for etcd cluster
# This will put all the etcd files into output/etcd
# You can then start up the etcd cluster, and obtain
# The list of IPs for each etcd node
./scripts/compile_etcd_cluster.sh
```

Go into the folder with the compiled assets and start the cluster.

```sh
cd output/etcd
vagrant up
```

This will start up the cluster. You can ssh into one of the nodes to check it out.

```sh
vagrant ssh core-01
```

Inside the CoreOS machine you can run a few commands to get familiar.

```sh
fleetctl list-machines
etcdctl ls
etcdctl member list
etcdctl cluster-health
```

So it looks good. We just set up a dedicated etcd cluster with 3 nodes. You can then target this cluster by its list of IPs.

## Generate Certs

First generate the cluster root ca. Run this script which will generate into `<project_dir>/certs`

- ca-key.pem
- ca.pem
- admin-key.pem
- admin.pem

```sh
./scripts/create_cluster_root_ca.sh
./scripts/create_cluster_admin_keypair.sh
```

## Kubernetes Master Node

First generate the necessary files to start the kubernetes master node. This requires you to have already started the etcd dedicated cluster, and obtained those ips, which you will then need to set in an ENV variable `ETCD_CLUSTER_NODE_IPS` when running the script ot generate these files.

```sh
# IMPORTANT: 
# Set the env variable that the last two scripts will 
# use. This is a comma delimited list of IPs of each
# etcd cluster node.
#
# ETCD_CLUSTER_NODE_IPS=http://123.123.12.1:2379,http...
#
# If you are using the test stuff and vagrant then this will
# be the address
# ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379

# Compile files for the Kubernetes master node
# This will output into output/master
ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379,http://172.17.8.102:2379,http://172.17.8.103:2379 ./scripts/compile_kubernetes_master_node.sh
```

Now go start the box.

```sh
cd output/master
vagrant up
```

If you ssh into this box you can see that it is connected to the etcd cluster and using it.

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


## Break

Ok let's check what we have so far.

- Dedicated ETCD cluster
- Kubernetes Master Node
- certs for master node, and admin

What we have to do.

- 