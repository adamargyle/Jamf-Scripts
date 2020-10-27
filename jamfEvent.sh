#!/bin/bash
# awickert 2020-02-10
# run jamf policy by trigger

## checks for custom trigger, asks if not provided
event=$4
if [[ -z $event ]]; then
	read -p "Jamf Custom Trigger:" event
fi

## run jamf policy by the provided custom trigger
jamf policy -event $event