#!/bin/bash

wan="wan-sys-firewall wan-sys-net"
admin="admin-mgmt admin-vpn admin-sys-net admin-sys-firewall"
dmz="dmz-ns dmz-sys-net dmz-sys-firewall"
lan="lan-ns lan-dhcp-server lan-sys-net lan-sys-firewall"
all="$lan $dmz $admin $wan sys-net-interfaces"

if ! OPTS=$(getopt -o hwadlft: --long help,wan,admin,dmz,lan,all,action: -n "$0" -- "$@"); then
    echo "ERROR: Failed while parsing options."
    exit 1
fi

eval set -- "$OPTS"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help) usage ;;
        -w | --wan ) vms="$vms $wan";;
        -a | --admin ) vms="$vms $admin";;
        -d | --dmz ) vms="$vms $dmz";;
        -l | --lan ) vms="$vms $lan";;
		-f | --all ) vms="$all";;
		-t | --action) action="$2"; shift;;
    esac
    shift
done

if [ "$action" == "start" ]; then
	#shellcheck disable=SC2086
	qvm-start --skip-if-running $vms
fi

if [ "$action" == "shutdown" ]; then
	#shellcheck disable=SC2086
	qvm-shutdown --force --wait $vms
fi
