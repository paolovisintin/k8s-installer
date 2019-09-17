#!/bin/bash
NODES=$($K get nodes --no-headers -o wide -o custom-columns=INTERNAL-IP:.status.addresses[0].address)
apt-get -qq -y install nfs-kernel-server
for NODE in $NODES; 
do
cat << EOF >> /etc/exports
/var/lib/cni/networks ${NODE}/32(rw,no_root_squash)
EOF

done

systemctl restart nfs-kernel-server
