#!/bin/bash
# awickert 2020-03-01
# Add a computer to a static group by its ID with the Jamf API, help from @koalatee
# Using script parameters $4, $5, $6 as reccomended by https://www.jamf.com/jamf-nation/articles/146/script-parameters
# also works interactively for testing

## Grab the serial number of the device
serialNumber="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')"

## Check if the variables have been provided, ask for them if not
apiUser="$4"
if [[ -z $apiUser ]]; then
	read -p "Username:" apiUser
fi
apiPass="$5"
if [[ -z $apiPass ]]; then
	read -sp "Password:" apiPass
fi
jssHost="$6"
if [[ -z $jssHost ]]; then
	read -p "JSS Host Address:" jssHost
fi
groupID="$7"
if [[ -z $groupID ]]; then
	read -p "Group ID Number:" groupID
fi

## the location in the API URL to add the computer by serial number
apiData="<computer_group><computer_additions><computer><serial_number>${serialNumber}</serial_number></computer></computer_additions></computer_group>"

## curl call to the API to add the computer to the provided group ID
curl \
	-s \
	-f \
	-u ${apiUser}:${apiPass} \
	-X PUT \
	-H "Content-Type: text/xml" \
	-d "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>${apiData}" ${jssHost}/JSSResource/computergroups/id/${groupID}