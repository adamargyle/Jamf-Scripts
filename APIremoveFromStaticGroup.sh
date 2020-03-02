#!/bin/bash
# 2020-02-25 awickert
# Remove a computer from a static group with the Jamf API
# Using script parameters $4, $5, $6 as reccomended by https://www.jamf.com/jamf-nation/articles/146/script-parameters
# also works interactively for testing

serialNumber="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')"
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
	
apiData="<computer_group><computer_deletions><computer><serial_number>${serialNumber}</serial_number></computer></computer_deletions></computer_group>"
curl \
	-s \
	-f \
	-u ${apiUser}:${apiPass} \
	-X PUT \
	-H "Content-Type: text/xml" \
	-d "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>${apiData}" ${jssHost}/JSSResource/computergroups/id/${groupID}