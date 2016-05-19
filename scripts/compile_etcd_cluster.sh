##
# usage:
#
#   ./compile_etcd
#
##
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ./config.env

ETCD_PARAMS="{
  \"CLUSTER_SIZE\": \"$ETCD_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\"
}"

echo "Generating etcd files..."
echo "$ETCD_PARAMS"
hbs-templater compile --params "$ETCD_PARAMS" \
  --input ../sample_src/templates_etcd_cluster \
  --output ../output/etcd \
  -l --overwrite
