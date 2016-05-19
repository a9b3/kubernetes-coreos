ETCD_CLUSTER_SIZE=3
MASTER_CLUSTER_SIZE=1
MINION_CLUSTER_SIZE=3
ALL_CLUSTER_SIZE=$ETCD_CLUSTER_SIZE + $MASTER_CLUSTER_SIZE + $MINION_CLUSTER_SIZE
_ETCD_DISCOVERY_URL=$(curl -s https://discovery.etcd.io/new?size=$ALL_CLUSTER_SIZE)
ETCD_DISCOVERY_TOKEN=${_ETCD_DISCOVERY_URL##*/}
K8S_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

ETCD_PARAMS="{
  \"CLUSTER_SIZE\": \"$ETCD_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"K8S_VERSION\": \"$K8S_VERSION\",
  \"TYPE\": \"etcd\"
}"

MASTER_PARAMS="{
  \"CLUSTER_SIZE\": \"$MASTER_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"K8S_VERSION\": \"$K8S_VERSION\",
  \"TYPE\": \"master\"
}"

MINION_PARAMS="{
  \"CLUSTER_SIZE\": \"$MINION_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"K8S_VERSION\": \"$K8S_VERSION\",
  \"TYPE\": \"minion\"
}"

echo "Generating etcd files..."
hbs-templater compile --params "$ETCD_PARAMS" --input $1 --output $2/etcd -l --overwrite

echo "Generating master files..."
hbs-templater compile --params "$MASTER_PARAMS" --input $1 --output $2/master -l --overwrite

echo "Generating minion files..."
hbs-templater compile --params "$MINION_PARAMS" --input $1 --output $2/minion -l --overwrite
