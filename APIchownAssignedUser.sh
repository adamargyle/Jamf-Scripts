#!/bin/bash
# 2021-03-12 awickert
# retrieves the assigned user and re-assigns their user folder permissions

## Gets local device serial number
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

## Finds assigned user by jamf API
username=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/location" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<username>/{print $3}')
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

## Check if user is logged in
if [[ "$loggedInUser" != "$username" ]]
then
	echo $username 'folder owned by' stat -f "%Su" /Users/$username/
	echo "changing ownership of $username home folder..."
	chown -R $username /Users/$username/
	echo "changed ownership of $username home folder..."
	echo $username 'folder owned by' stat -f "%Su" /Users/$username/
	echo "running permission change again for good measure..."
	chown -R $username /Users/$username/
	echo $username 'folder owned by' stat -f "%Su" /Users/$username/
else
	echo "$username is currently logged in"
fi