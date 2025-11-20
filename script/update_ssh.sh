#!/bin/bash

cd ../terraform

EDGE_IP=$(terraform output -raw edge_public_ip)

# Update ssh config for ProxyJump
cat > ~/.ssh/gcp_spark_cluster <<EOF
Host edge
    HostName $EDGE_IP
    User ubuntu
    IdentityFile ~/.ssh/id_rsa

Host 10.0.*.*
    ProxyJump edge
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
EOF

echo "Updated ~/.ssh/gcp_spark_cluster with EDGE_IP=$EDGE_IP"

cd -

# Copy ssh private key to edge node
echo "Copying ssh key to edge node"
scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ubuntu@$EDGE_IP:~/.ssh/
ssh -o StrictHostKeyChecking=no ubuntu@$EDGE_IP "chmod 600 ~/.ssh/id_rsa"
echo "SSH key copied to edge node."
