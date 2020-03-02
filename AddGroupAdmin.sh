#!/bin/bash
# 2019-05-01 awickert
# set an AD group as admin on a machine using script parameter 

group="$4"
if [[ -z $group ]]; then
	read -p "Group Name:" group
fi

dseditgroup -o edit -a "DOMAIN_NAME\${group}" -t group admin