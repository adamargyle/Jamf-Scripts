#!/bin/bash
# awickert 2020-10-27 
# set an AD group as admin on a machine using script parameter 

## Check if the group has been provided, ask for it if not
groupname="$4"
if [[ -z $group ]]; then
	read -p "Group Name:" group
fi

## add group to the local admin group list
dseditgroup -o edit -a "DOMAIN_NAME\${groupname}" -t group admin

## add group to the domain admins group
dsconfigad -groups "DOMAIN_NAME\${groupname}"