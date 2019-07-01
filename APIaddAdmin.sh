#!/bin/bash
# 2019-05-01 awickert
# get the username from jamf and set user as admin
# Using script parameters $4, $5, $6 as reccomended by https://www.jamf.com/jamf-nation/articles/146/script-parameters

serialNumber="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')"
apiUser="$4"
apiPass="$5"
jssHost="$6"

username=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/location" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<username>/{print $3}')
dscl . -append /Groups/admin GroupMembership $username