#!/bin/bash
K=/usr/bin/kubectl
MTU=1450

function start_vxlan() {
    INTERFACE=$1
    ID=$2
    ADDITIONAL=$3
    if [ -z "$INTERFACE" ]; then
        echo "INTERFACE not set"
        exit 1
    fi
    if [ -z "$ID" ]; then
        echo "ID not set"
        exit 1
    fi
    # if existent, deleting VXLAN
    #/bin/ip link del $INTERFACE
    #creating vxlan
    echo "-- creating VXLAN $INTERFACE with ID: $ID"
    /bin/ip link add $INTERFACE type vxlan id $ID
    # getting list of ip addresses
    NODES=$($K get nodes --no-headers -o wide -o custom-columns=INTERNAL-IP:.status.addresses[0].address)
    if ! [ -z "$ADDITIONAL" ]; then
    NODES="$NODES $ADDITIONAL"
    fi

    for NODE in $NODES
    do
        CHECK=$(/bin/ip addr |grep eth0 |grep $NODE)
        if [ "$CHECK" == "" ]; then
            /sbin/bridge fdb append to 00:00:00:00:00:00 dst $NODE dev $INTERFACE
            echo "--- added $NODE"
        fi
    done
    /bin/ip link set dev $INTERFACE mtu $MTU
    /bin/ip link set dev $INTERFACE up

}
start_vxlan macvlan-anycast 101
start_vxlan macvlan-private 102
start_vxlan macvlan-public 103 
start_vxlan macvlan-percona 104
start_vxlan macvlan-testing 105
echo "--- END ---"