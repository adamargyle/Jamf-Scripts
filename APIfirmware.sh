#!/bin/bash
# 2019-05-01 awickert
# Check for firmware password, set if not enabled sing asset_tag

serialNumber="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')"
apiUser="username"
apiPass="password"
jssHost="hostname"
doesexist=`firmwarepasswd -check`
barcode=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
firmware=passwordscheme${barcode}

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