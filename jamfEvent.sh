#!/bin/bash
# 2020-02-10 awickert
# run jamf policy by trigger

event=$4
if [[ -z $event ]]; then
	read -p "Jamf Custom Trigger:" event
fi

jamf policy -event $event

exit 0