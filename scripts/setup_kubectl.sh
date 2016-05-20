parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ./config.env

MASTER_IP=http://$1:8080
CA_CERT=/Users/sam/Projects/devops/do-kubernetes/certs/ca.pem
ADMIN_KEY=/Users/sam/Projects/devops/do-kubernetes/certs/admin-key.pem
ADMIN_CERT=/Users/sam/Projects/devops/do-kubernetes/certs/admin.pem

echo "MASTER_IP=$MASTER_IP"

kubectl config set-cluster default-cluster \
  --server=$MASTER_IP \
  --certificate-authority=$CA_CERT \
  --client-key=$ADMIN_KEY \
  --client-certificate=$ADMIN_CERT
kubectl config set-credentials default-admin \
  --certificate-authority=$CA_CERT \
  --client-key=$ADMIN_KEY \
  --client-certificate=$ADMIN_CERT
kubectl config set-context default-system \
  --cluster=default-cluster \
  --user=default-admin
kubectl config use-context default-system
