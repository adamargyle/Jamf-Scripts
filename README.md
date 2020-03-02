# Jamf Pro Scripts
Scripts I use to customize systems with parameters and API access.

All scripts are using the $4, $5, $6 parameters as provided by Jamf Pro. I reccomend customizing the fields in Jamf Admin to make it easier to create policies. I've added interactivity for testing the scripts in most cases so it will prompt if the variable is not passed.

## API Scripts
Several scripts are using the Jamf API to pull data like the asset tag or assigned user. Then by using this information you can do customization based on information in your inventory already, or uploaded to inventory preload.
* **APIaddAdmin** adds the user registered in the JSS to the admin list.
* **APIfirmware** creates a firmware password with a variable including the Asset Tag from the JSS.
* **APIremoveFWPW** removes a firmware password with a variable including the Asset Tag from the JSS, to be used in conjunction with the script to create. This can be used when erasing a system to prepare for reuse or resale.
* **APIrename** will rename the computer again using the Asset Tag variable.
* **APIaddtoStaticGroup** adds the computer the script is run on to a Jamf Pro Static Group by its ID number via the API. This is helpful for scoping policies to specific groups, and works well in conjunction with policies and profiles to be applied through Self Service
* **APIremoveFromStaticGroup** removes the computer the script is run on from a Jamf Pro Static Group by its ID via the API. This can be used to remove profiles, or prepare a machine to be re-imaged with an erase and install.

## Utility Scripts
* **installWithChoices** is a script that is intended to run a policy by putting a packaging in a staging location, in this case /Library/Management and then calling the installer with the choices.xml file to customize the install. followinf the install this also will delete the files from staging.
* **jamfEvent** is a script I use to make Self Service buttons out of existing policies with custom triggers that may already be scoped in Jamf Pro. This lets me scope the self service policy to a subset, but also use the custom event policy for a wider deployment. It also means I only need to update a single policy when software updates come out.
* **resetkeychain** is a script to reset a keychain when an AD mobile account user changed their password elsewhere and it is not updating correctly. It just creates a new keychain.
* **NVRAMclear** runs the command line version of an NVRAM/PRAM reset. This can help some issues and when an EFI firmware password is enabled it will allow a user who cannot utilize the option to hold modifier keys during startup.
* **AddUserAdmin** adds a user as admin based on a variable. This is helpful for not having a bunch of scripts for individual department labs where a specific user should be a local admin.
* **AddGroupAdmin** adds an AD group to the admin list. This implementation does not seem to work with macOS Mojave and newer versions of macOS.
* **autoMigratetoLocal** is based on Rich Trouton's interactive script https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/migrate_ad_mobile_account_to_local_account but intended for use in Self Service. It uses the #3 variable to pull the user logged in to Self Service and migrate that account if it is in fact a mobile account, and retains admin permissions as it is configured in our environment. THe policy is configured to run 3 things, migrate the account, install the NoMAD profile and then the NoMAD application and launchagent.
* **startupChime** re-enables the startup chime on newer macs, because it's fun and it made the blog rounds https://mrmacintosh.com/how-to-enable-the-mac-startup-chime-on-your-2016-macbook-pro/
