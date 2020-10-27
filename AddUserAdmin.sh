#!/bin/bash
# awickert 2019-05-01
# set a user as admin on a machine using script parameter 

## Check if the username has been provided, ask for it if not
username="$4"
if [[ -z $username ]]; then
	read -p "Username:" username
fi

## add the user to the the local admin group
dscl . -append /Groups/admin GroupMembership $username