#!/bin/bash
# 2019-04-19 awickert
# get the barcode from jamf asset_tag and set the hostname
# Using script parameters $4, $5, $6 as reccomended by https://www.jamf.com/jamf-nation/articles/146/script-parameters

serialNumber="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')"
apiUser="$4"
apiPass="$5"
jssHost="$6"

barcode=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${jssHost}/JSSResource/computers/serialnumber/${serialNumber}/subset/general" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<asset_tag>/{print $3}')
hostname=Mac-$barcode
scutil --set ComputerName $hostname
scutil --set HostName $hostname
scutil --set LocalHostName $hostname