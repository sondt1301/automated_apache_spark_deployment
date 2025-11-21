#!/bin/bash

TERRAFORM_DIR=../terraform
ANSIBLE_DIR=../ansible/nodes.ini

cd $TERRAFORM_DIR

MASTER_IP=$(terraform output -raw master_ip)
WORKERS=$(terraform output -json worker_ips | jq -r '.[]')
EDGE_IP=$(terraform output -raw edge_public_ip)
STORAGE_IP=$(terraform output -raw storage_ip)

cat > $ANSIBLE_DIR <<EOF
[master]
master-node ansible_host=$MASTER_IP ansible_user=ubuntu

[workers]
EOF

i=0
for ip in $WORKERS; do
cat >> $ANSIBLE_DIR <<EOF
worker-node-$i ansible_host=$ip ansible_user=ubuntu
EOF
((i++))
done

cat >> $ANSIBLE_DIR <<EOF

[edge]
edge-node ansible_host=$EDGE_IP ansible_user=ubuntu

[storage]
storage-node ansible_host=$STORAGE_IP ansible_user=ubuntu
EOF

echo "nodes.ini successfully generated!"
