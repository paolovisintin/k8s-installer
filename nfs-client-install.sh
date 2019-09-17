#!/bin/bash
K=/usr/bin/kubectl
export KUBECONFIG=/etc/kubernetes/admin.conf
NFS_SERVER=$($K get nodes --no-headers -o wide -o custom-columns=INTERNAL-IP:.status.addresses[0].address | head -n 1 )
echo "${NFS_SERVER}:/nfs /nfs nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
mount /nfs
