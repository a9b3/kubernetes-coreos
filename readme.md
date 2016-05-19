# Kubernetes Cluster on CoreOS

Overview parts of the cluster.

1. Dedicated etcd cluster.
2. Master Kubernetes node.
3. Minion Kubernetes nodes.

First start etcd cluster. You will need to get the ip of the node that is hosting the etcd cluster.

=> ETCD\_HOST_IP

```sh
# Generate the config.env for cluster
# Run only once per cluster
# You can change the settings inside generate_config.sh
./scripts/generate_config.sh

# Then generate the files for etcd cluster
# This will put all the etcd files into output/etcd
# You can then start up the etcd cluster, and obtain
# The list of IPs for each etcd node
./scripts/compile_etcd_cluster.sh

# IMPORTANT: 
# Set the env variable that the last two scripts will 
# use. This is a comma delimited list of IPs of each
# etcd cluster node.
#
# ETCD_CLUSTER_NODE_IPS=http://123.123.12.1:2379,http...
#
# If you are using the test stuff and vagrant then this will
# be the address
# ETCD_CLUSTER_NODE_IPS=http://172.17.8.101:2379

# Compile files for the Kubernetes master node
# This will output into output/master
./scripts/compile_kubernetes_master_node.sh
```