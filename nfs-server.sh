#!/bin/bash
NODES=$($K get nodes --no-headers -o wide -o custom-columns=INTERNAL-IP:.status.addresses[0].address)
apt-get -qq -y install nfs-kernel-server
for NODE in $NODES; 
do
cat << EOF >> /etc/exports
/nfs ${NODE}/32(rw,no_root_squash)
EOF

done
exportfs -a
systemctl restart nfs-kernel-server
