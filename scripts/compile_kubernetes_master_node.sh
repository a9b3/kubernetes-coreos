##
# usage:
#
#   ./compile_other
#
##
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ./config.env

MASTER_PARAMS="{
  \"ETCD_CLUSTER_NODE_IPS\": \"$ETCD_CLUSTER_NODE_IPS\",
  \"CLUSTER_SIZE\": \"$MASTER_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"K8S_VERSION\": \"$K8S_VERSION\",
  \"POD_NETWORK\": \"$POD_NETWORK\",
  \"SERVICE_IP_RANGE\": \"$SERVICE_IP_RANGE\",
  \"KUBERNETES_SERVICE_IP\": \"$KUBERNETES_SERVICE_IP\",
  \"DNS_SERVICE_IP\": \"$DNS_SERVICE_IP\"
}"

echo "Generating master files..."
echo "$MASTER_PARAMS"
hbs-templater compile --params "$MASTER_PARAMS" \
  --input ../sample_src/templates_kubernetes_master_node \
  --output ../output/master \
  -l --overwrite

echo "Copying over CA certs..."
rm -rf ../output/master/certs
mkdir ../output/master/certs
cp ../certs/ca.pem ../output/master/certs
cp ../certs/ca-key.pem ../output/master/certs
