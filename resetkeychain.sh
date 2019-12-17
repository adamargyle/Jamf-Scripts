#!/bin/bash
# 2018-05-14
# Script to reset user keychain when the password is no longer known/unsynced from AD

user=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
home=$(dscl . read /Users/"$user" NFSHomeDirectory | awk '{print $2}')

rm -rf "$home"/Library/Keychains/*

exit