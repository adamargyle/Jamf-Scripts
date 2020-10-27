#!/bin/bash
# awickert 2018-05-14
# Script to reset user keychain when the password is no longer known/unsynced from AD

## get logged in user via python
user=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

## find users home folder location
home=$(dscl . read /Users/"$user" NFSHomeDirectory | awk '{print $2}')

## clear keychains
rm -rf "$home"/Library/Keychains/*

exit