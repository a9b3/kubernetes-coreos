# Detailed Steps

### Change settings to your cluster

Inside `./scripts/generate_config.sh` and `./coreos_certs`.

### Generate root ca files

```
./scripts/create_cluster_root_ca.sh
```

This will create 3 files `ca.pem`, `ca-key.pem`, and `ca.csr`, inside `./certs/` folder. These will be used to create additional keys specific to each node in the cluster. They will also need to be moved into each node's `/etc/ssl/certs/` folder.

### Generate etcd cluster user-data

```
./scripts/compile_etcd_cluster.sh
```

This will compile some files into `./output/etcd` folder, which you can use to start vagrant nodes. These nodes need to be secure so certs will need to be moved inside, and additional keys will need to be generated for each node. Since these additional keys will require information about the nodes that might not be available before the nodes start you will need to create these keys after the nodes.