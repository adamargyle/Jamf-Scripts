#!/bin/bash
# awickert 9-9-2020
# remove user folders older than a specific age
# using $4 as a specified variable in Jamf Pro
# based on a script from a coworker who based it on another script originally from github.com/dankeller/macscripts

error=0

days=$4
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
permanent=("/Users/Shared" "/Users/$loggedInUser")

if [[ $UID -ne 0 ]]; then echo "$0 must be run as root." && exit 1; fi

allusers=`/usr/bin/find /Users -type d -maxdepth 1 -mindepth 1 -not -name "." -mtime +$days`

echo "deleting inactive users"

for username in $allusers; do
	if ! [[ ${permanent[*]} =~ "$username" ]]; then
		echo "Deleting inactive (over $days days) account" $username
		
		# delete user
		/usr/bin/dscl . delete $username > /dev/null 2>&1
		
		# delete home folder
		/bin/rm -r $username
		continue
	else
		echo "skip" $username
	fi
done

echo "complete"
exit $error