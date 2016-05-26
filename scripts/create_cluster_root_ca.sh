parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"

rm -rf ../certs
mkdir -p ../certs
cd ../certs

echo "creating ca-key.pem and ca.pem in certs/ ..."
cfssl gencert -initca ../coreos_certs/ca-csr.json | cfssljson -bare ca -
# openssl genrsa -out ../certs/ca-key.pem 2048
# openssl req -x509 -new -nodes \
#   -key ../certs/ca-key.pem \
#   -days 10000 \
#   -out ../certs/ca.pem \
#   -subj "/CN=kube-ca"
