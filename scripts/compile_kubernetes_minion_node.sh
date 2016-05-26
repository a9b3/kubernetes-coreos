##
# usage:
#
#   ./compile_other
#
##
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ./config.env

MINION_PARAMS="{
  \"MASTER_IP\": \"$MASTER_IP\",
  \"ETCD_CLUSTER_NODE_IPS\": \"$ETCD_CLUSTER_NODE_IPS\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"CLUSTER_SIZE\": \"$MINION_CLUSTER_SIZE\",
  \"POD_NETWORK\": \"$POD_NETWORK\",
  \"SERVICE_IP_RANGE\": \"$SERVICE_IP_RANGE\",
  \"KUBERNETES_SERVICE_IP\": \"$KUBERNETES_SERVICE_IP\",
  \"DNS_SERVICE_IP\": \"$DNS_SERVICE_IP\",
  \"K8S_VERSION\": \"$K8S_VERSION\"
}"

echo "Generating minion files..."
echo "$MINION_PARAMS"
hbs-templater compile --params "$MINION_PARAMS" \
  --input ../sample_src/templates_kubernetes_minion_node \
  --output ../output/minion \
  -l --overwrite

echo "Copying over CA certs..."
rm -rf ../output/minion/certs
mkdir ../output/minion/certs
cp ../certs/ca.pem ../output/minion/certs
cp ../certs/ca-key.pem ../output/minion/certs
