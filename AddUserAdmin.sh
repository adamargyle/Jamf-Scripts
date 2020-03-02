#!/bin/bash
# 2019-05-01 awickert
# set a user as admin on a machine using script parameter 

username="$4"
if [[ -z $username ]]; then
	read -p "Username:" username
fi

dscl . -append /Groups/admin GroupMembership $username