#!/bin/bash

usage() {
	printf "\nUSAGE: ipHandler.sh [ options ]\n\n";
	printf "options:\n\n"
	printf '%-60s %s\n\n'  "add IPAddr Interface_Name NetMask/Network_Prefix_Length "  "-- To bind the given IP to machine"
	printf '%-60s %s\n\n'  "delete IPAddr Interface_Name NetMask/network_Prefix_Length "  "-- To unbind the given IP from machine"
	printf '%-60s %s\n\n'  "iflist"  							 					   "-- To print the list of available Network Interfaces"
	printf '%-60s %s\n\n'  "ifcheck Interface_Name"             					   "-- To check if the provided interface is up"
	printf '%s\n\n' "The user running this script should be a sudo user"
    exit 1;
}

if [ $# -lt 1 ]; then
    usage
fi

OPTION="$1"
shift

if [ "$OPTION" = "add" ]; then
	if [ $# -lt 1 ]; then
		usage
	fi
	sudo ip a add $1/$3 dev $2   

elif [ "$OPTION" = "delete" ]; then
	if [ $# -lt 1 ]; then
		usage
	fi
	sudo ip a del $1/$3 dev $2   

elif [ "$OPTION" = "iflist" ]; then
	ip address ls up   

elif [ "$OPTION" = "ifcheck" ]; then
	if [ $# -lt 1 ]; then
		usage
	fi
	
	if [ -r /sys/class/net/$1/carrier ] && [ -r /sys/class/net/$1/operstate ]; then
		CARRIER=`cat /sys/class/net/$1/carrier`
		OPERSTATE=`cat /sys/class/net/$1/operstate`
		if [ $CARRIER -eq 1 ] && [ "$OPERSTATE" = "up" ]; then
			echo Interface is UP
		fi
	else
		echo "Unable to check if the interface is up either due to invalid interface or current user do not have permission"
	fi

else
  usage
fi
