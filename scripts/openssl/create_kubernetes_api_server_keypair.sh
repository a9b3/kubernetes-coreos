##
# IMPORTANT: You need to set the following ENV vars
#
# MASTER_IP
##

parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ../config.env

PARAMS="{
  \"MASTER_IP\": \"$MASTER_IP\",
  \"KUBERNETES_SERVICE_IP\": \"$KUBERNETES_SERVICE_IP\"
}"

echo "Generating kubernetes api server keypair openssl..."
echo "$PARAMS"
hbs-templater compile --params "$PARAMS" \
  --input ./api_server_templates \
  --output ../../certs \
  -l --overwrite

echo "Generating kubernetes api server keypair certs..."
openssl genrsa -out ../../certs/apiserver-key.pem 2048
openssl req -new -key ../../certs/apiserver-key.pem \
  -out ../../certs/apiserver.csr \
  -subj "/CN=kube-apiserver" \
  -config ../../certs/openssl.cnf
openssl x509 -req -in ../../certs/apiserver.csr \
  -CA ../../certs/ca.pem \
  -CAkey ../../certs/ca-key.pem \
  -CAcreateserial \
  -out ../../certs/apiserver.pem \
  -days 365 \
  -extensions v3_req \
  -extfile ../../certs/openssl.cnf
