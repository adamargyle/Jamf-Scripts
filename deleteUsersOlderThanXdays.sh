#!/bin/bash
# awickert 2021-01-29
# remove user folders older than a specific age
# using $4 as a specified variable in Jamf Pro
# based on a script from a coworker who based it on another script originally from github.com/dankeller/macscripts

error=0

## Checks if the variable has been provided
days=$4
if [[ -z $days ]]; then
	read -p "Profile Age:" days
fi

## new shorter bash method to get logged in user
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

## Do not delete the current user or the shared folder, add additional users if needed
permanent=("Shared" "$loggedInUser")

## Verify script is being run as root
if [[ $UID -ne 0 ]]; then echo "$0 must be run as root." && exit 1; fi

## users that have not been active in the specified number of days
allusers=`/usr/bin/find /Users -type d -maxdepth 1 -mindepth 1 -not -name "." -mtime +$days`

echo "deleting inactive users"

## iterate through each inactive user, check if they are in the permanent list, then delete 
for username in $allusers; do
	if ! [[ ${permanent[*]} =~ "$username" ]]; then
		echo "Deleting inactive (over $days days) account" $username
		
		# delete user
		/usr/bin/dscl . delete $username > /dev/null 2>&1
		
		# find and delete home folder (in case it is not in /Users/)
		home=$( dscl . read /Users/${username} NFSHomeDirectory )
		/bin/rm -r $home
		continue
	else
		echo "skip" $username
	fi
done

echo "complete"
exit $error