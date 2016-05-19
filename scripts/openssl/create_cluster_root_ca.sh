parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"

mkdir -p ../../certs

echo "creating ca-key.pem and ca.pem in certs/ ..."
openssl genrsa -out ../../certs/ca-key.pem 2048
openssl req -x509 -new -nodes \
  -key ../../certs/ca-key.pem \
  -days 10000 \
  -out ../../certs/ca.pem \
  -subj "/CN=kube-ca"
