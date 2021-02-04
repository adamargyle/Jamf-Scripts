#!/bin/bash
# awickert 2021-01-29
# Script to reset user keychain when the password is no longer known/unsynced from AD

## get logged in user
user=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

## Find users home folder location
home=$(dscl . read /Users/"$user" NFSHomeDirectory | awk '{print $2}')

## Clear keychains
rm -rf "$home"/Library/Keychains/*

exit