# Jamf Pro Scripts
Scripts I use to customize systems with parameters and API access.

All scripts are using the $4, $5, $6 parameters as provided by Jamf Pro. I reccomend customizing the fields in Jamf Admin to make it easier to create policies.

## API Scripts
Several scripts are using the Jamf API to pull data like the asset tag or assigned user. Then by using this information you can do customization based on information in your inventory already, or uploaded to inventory preload.
* **APIaddAdmin** adds the user registered in the JSS to the admin list
* **APIfirmware** creates a firmware password with a variable including the Asset Tag from the JSS
* **APIrename** will rename the computer again using the Asset Tag variable.

## Utility Scripts
* **installWithChoices** is a script that is intended to run a policy by putting a packaging in a staging location, in this case /Library/Management and then calling the installer with the choices.xml file to customize the install. followinf the install this also will delete the files from staging.
* **jamfEvent** is a script I use to make Self Service buttons out of existing policies with custom triggers that may already be scoped in Jamf Pro. This lets me scope the self service policy to a subset, but also use the custom event policy for a wider deployment. It also means I only need to update a single policy when software updates come out.
* **resetkeychain** is a script to reset a keychain when an AD mobile account user changed their password elsewhere and it is not updating correctly. It just creates a new keychain.
* **NVRAMclear** runs the command line version of an NVRAM/PRAM reset. This can help some issues and when an EFI firmware password is enabled it will allow a user who cannot utilize the option to hold modifier keys during startup.
* **AddUserAdmin** adds a user as admin based on a variable. This is helpful for not having a bunch of scripts for individual department labs where a specific user should be a local admin.
* **AddGroupAdmin** adds an AD group to the admin list. This implementation does not seem to work with macOS Mojave and newer versions of macOS.