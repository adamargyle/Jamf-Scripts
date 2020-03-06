#!/bin/bash
# 2020-02-25 awickert
# Check for firmware password, remove if enabled
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
doesexist=`firmwarepasswd -check`
barcode=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
firmware=passwordscheme${barcode}

if [ "$doesexist" = "Password Enabled: Yes" ]; then
	/usr/bin/expect <<- DONE
		spawn firmwarepasswd -delete
		expect "Enter password:"
		send "$firmware\r";
		expect EOF
	DONE
else
	echo "No Firmware Password Set"
	
fi