#!/bin/bash

usage() {
echo "Usage: $0 [OPTIONS]...

Options:
    --init
    --network
    --wan
    --admin
    --dmz
    --lan
"
    exit 1
}

if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run with root permissions" 
   exit 1
fi

if ! OPTS=$(getopt -o hinwadl --long help,init,network,wan,admin,dmz,lan -n "$0" -- "$@"); then
    echo "ERROR: Failed while parsing options."
    exit 1
fi

eval set -- "$OPTS"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help) usage ;;
        -i | --init ) init=1;;
        -n | --network) network=1;;
        -w | --wan ) wan=1;;
        -a | --admin ) admin=1;;
        -d | --dmz ) dmz=1;;
        -l | --lan ) lan=1 ;;
    esac
    shift
done

# Clear
rm -rf /srv/salt/_tops/base/qubes-server*.top /srv/pillar/_tops/base/qubes-server*.top

qubesctl top.enable qubes-server pillar=True
qubesctl top.enable qubes-server.wan pillar=True
qubesctl top.enable qubes-server.dmz pillar=True
qubesctl top.enable qubes-server.lan pillar=True
qubesctl top.enable qubes-server.admin pillar=True

if [ "$init" == "1" ]; then
    qubesctl top.enable qubes-server
    qubesctl --target=debian-10-minimal state.highstate
    qubesctl top.disable qubes-server
fi

if [ "$network" == "1" ]; then
    qubesctl top.enable qubes-server.network
    qubesctl --target=sys-net-interfaces state.highstate
    qubesctl top.disable qubes-server.network
fi

if [ "$wan" == "1" ]; then
    qubesctl top.enable qubes-server.wan
    qubesctl --target=wan-sys-net,wan-sys-firewall state.highstate
    qubesctl top.disable qubes-server.wan
fi

if [ "$admin" == "1" ]; then
    qubesctl top.enable qubes-server.admin
    qubesctl --target=admin-sys-net,admin-sys-firewall,admin-vpn,admin-mgmt state.highstate
    qubesctl top.disable qubes-server.admin
fi

if [ "$dmz" == "1" ]; then
    qubesctl top.enable qubes-server.dmz
    qubesctl --target=dmz-sys-firewall,dmz-sys-net,dmz-ns state.highstate
    qubesctl top.disable qubes-server.dmz
fi

if [ "$lan" == "1" ]; then
    qubesctl top.enable qubes-server.lan
    qubesctl --target=lan-sys-firewall,lan-sys-net,lan-ns,lan-dhcp-server state.highstate
    qubesctl top.disable qubes-server.lan
fi
