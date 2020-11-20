#!/bin/bash
# awickert 2020-03-01
# Check for firmware password, set if not enabled using asset_tag for a unique password per device
# Using script parameters $4, $5, $6 as reccomended by https://www.jamf.com/jamf-nation/articles/146/script-parameters
# also works interactively for testing

arch=$(/usr/bin/arch)

if [ "$arch" == "arm64" ]; then
	echo "firmwarepasswd command not support on Apple Silicon devices"
	exit 0
else
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
	
	## Check if the device has a furmware password
	doesexist=`firmwarepasswd -check`
	
	## API call to get the barcode stored in the Asset_Tag
	barcode=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
	
	## create a unique password scheme using the barcode
	firmware=passwordscheme${barcode}
	
	## Check if there is a password, if not enables it with the expect shell
	if [ "$doesexist" = "Password Enabled: No" ]; then
		/usr/bin/expect <<- DONE
			spawn firmwarepasswd -setpasswd
			expect "Enter new password:"
			send "$firmware\r";
			expect "Re-enter new password:"
			send "$firmware\r";
			expect EOF
		DONE
	else
		echo "Firmware Password Already Exists"
	fi
fi