##
# IMPORTANT: You need to set the following ENV vars
#
# WORKER_IPS - comma delimited list of worker IPs
##

parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"
source ../config.env

mkdir -p ../../certs/workers

echo "Generating kubernetes worker keypairs..."
counter=0
for ip in $( echo $WORKER_IPS | sed "s/,/ /g" )
do
  counter=$(($counter + 1))
  WORKER_FQDN=worker_$counter

  WORKER_IP=$ip

  openssl genrsa -out ../../certs/workers/${WORKER_FQDN}-worker-key.pem 2048

  openssl req -new -key ../../certs/workers/${WORKER_FQDN}-worker-key.pem \
    -out ../../certs/workers/${WORKER_FQDN}-worker.csr \
    -subj "/CN=${WORKER_FQDN}" \
    -config ./worker-openssl.cnf

  openssl x509 -req -in ../../certs/workers/${WORKER_FQDN}-worker.csr \
    -CA ../../certs/ca.pem \
    -CAkey ../../certs/ca-key.pem \
    -CAcreateserial \
    -out ../../certs/workers/${WORKER_FQDN}-worker.pem \
    -days 365 \
    -extensions v3_req \
    -extfile ./worker-openssl.cnf
done
