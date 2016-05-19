parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"

echo "Creating cluster admin keypair ..."
openssl genrsa -out ../../certs/admin-key.pem 2048

openssl req -new -key ../../certs/admin-key.pem \
  -out ../../certs/admin.csr \
  -subj "/CN=kube-admin"

openssl x509 -req -in ../../certs/admin.csr \
  -CA ../../certs/ca.pem \
  -CAkey ../../certs/ca-key.pem \
  -CAcreateserial \
  -out ../../certs/admin.pem \
  -days 365
