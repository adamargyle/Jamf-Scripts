#!/bin/bash
# Modified 2020-02-28
# Original source is from MigrateUserHomeToDomainAcct.sh
# Written by Patrick Gallagher - https://twitter.com/patgmac
# Guidance and inspiration from Lisa Davies: http://lisacherie.com/?p=239
# Modified by Rich Trouton
# Further modification by Adam Wickert to automate through Jamf for migration to  NoMAD on existing systems via self service
#
# Migrates an Active Directory mobile account to a local account by the following process:
# 1. Specifies account via Self Service login ($3 variable in Jamf)
# 3. Remove AD specific attributes from the specified account
# 4. Selectively modify the account's AuthenticationAuthority attribute to remove AD-specific attributes.
# 5. Restart the directory services process.
# 6. Check to see if the conversion process succeeded by checking the OriginalNodeName attribute for the value "Active Directory"
# 7. If the conversion process succeeded, update the permissions on the account's home folder.
# 8. Ensure Admin rights are retained for the user.

username=$3
if [[ -z $username ]]; then
	read -p "Username:" username
fi

osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

PasswordMigration(){

	# macOS 10.14.4 will remove the the actual ShadowHashData key immediately 
	# if the AuthenticationAuthority array value which references the ShadowHash
	# is removed from the AuthenticationAuthority array. To address this, the
	# existing AuthenticationAuthority array will be modified to remove the Kerberos
	# and LocalCachedUser user values.

	AuthenticationAuthority=$(/usr/bin/dscl -plist . -read /Users/$username AuthenticationAuthority)
	Kerberosv5=$(echo "${AuthenticationAuthority}" | xmllint --xpath 'string(//string[contains(text(),"Kerberosv5")])' -)
	LocalCachedUser=$(echo "${AuthenticationAuthority}" | xmllint --xpath 'string(//string[contains(text(),"LocalCachedUser")])' -)

	# Remove Kerberosv5 and LocalCachedUser
	if [[ ! -z "${Kerberosv5}" ]]; then
		/usr/bin/dscl -plist . -delete /Users/$username AuthenticationAuthority "${Kerberosv5}"
	fi

	if [[ ! -z "${LocalCachedUser}" ]]; then
		/usr/bin/dscl -plist . -delete /Users/$username AuthenticationAuthority "${LocalCachedUser}"
	fi
}

accounttype=`/usr/bin/dscl . -read /Users/"$username" AuthenticationAuthority | head -2 | awk -F'/' '{print $2}' | tr -d '\n'`
	
if [[ "$accounttype" = "Active Directory" ]]; then
	mobileusercheck=`/usr/bin/dscl . -read /Users/"$username" AuthenticationAuthority | head -2 | awk -F'/' '{print $1}' | tr -d '\n' | sed 's/^[^:]*: //' | sed s/\;/""/g`
	if [[ "$mobileusercheck" = "LocalCachedUser" ]]; then
		/usr/bin/printf "$username has an AD mobile account.\nConverting to a local account with the same username and UID.\n"
		# Remove the account attributes that identify it as an Active Directory mobile account
		
		/usr/bin/dscl . -delete /users/$username cached_groups
		/usr/bin/dscl . -delete /users/$username cached_auth_policy
		/usr/bin/dscl . -delete /users/$username CopyTimestamp
		/usr/bin/dscl . -delete /users/$username AltSecurityIdentities
		/usr/bin/dscl . -delete /users/$username SMBPrimaryGroupSID
		/usr/bin/dscl . -delete /users/$username OriginalAuthenticationAuthority
		/usr/bin/dscl . -delete /users/$username OriginalNodeName
		/usr/bin/dscl . -delete /users/$username SMBSID
		/usr/bin/dscl . -delete /users/$username SMBScriptPath
		/usr/bin/dscl . -delete /users/$username SMBPasswordLastSet
		/usr/bin/dscl . -delete /users/$username SMBGroupRID
		/usr/bin/dscl . -delete /users/$username PrimaryNTDomain
		/usr/bin/dscl . -delete /users/$username AppleMetaRecordName
		/usr/bin/dscl . -delete /users/$username PrimaryNTDomain
		/usr/bin/dscl . -delete /users/$username MCXSettings
		/usr/bin/dscl . -delete /users/$username MCXFlags

		# Migrate password and remove AD-related attributes

		PasswordMigration

		# Refresh Directory Services
		if [[ ${osvers} -ge 7 ]]; then
			/usr/bin/killall opendirectoryd
		else
			/usr/bin/killall DirectoryService
		fi
		
		sleep 20
		
		accounttype=`/usr/bin/dscl . -read /Users/"$username" AuthenticationAuthority | head -2 | awk -F'/' '{print $2}' | tr -d '\n'`
		if [[ "$accounttype" = "Active Directory" ]]; then
			/usr/bin/printf "Something went wrong with the conversion process.\nThe $username account is still an AD mobile account.\n"
			exit 1
		else
			/usr/bin/printf "Conversion process was successful.\nThe $username account is now a local account.\n"
		fi
		
		homedir=`/usr/bin/dscl . -read /Users/"$username" NFSHomeDirectory  | awk '{print $2}'`
		if [[ "$homedir" != "" ]]; then
			/bin/echo "Home directory location: $homedir"
			/bin/echo "Updating home folder permissions for the $username account"
			/usr/sbin/chown -R "$username" "$homedir"		
		fi
		
		# Add user to the staff group on the Mac
		
		/bin/echo "Adding $username to the staff group on this Mac."
		/usr/sbin/dseditgroup -o edit -a "$username" -t user staff
		
		/bin/echo "Displaying user and group information for the $username account"
		/usr/bin/id $username
		
		/usr/sbin/dseditgroup -o edit -a "$username" -t user admin; /bin/echo "Admin rights given to this account";
	else
		/usr/bin/printf "The $username account is not a AD mobile account\n"
	fi
else
	/usr/bin/printf "The $username account is not a AD mobile account\n"
fi