#!/bin/bash
# awickert 2020-09-30
# Script to set user settings at first login via outset

# Secure home folder
chmod -R og-rwx ~/

# Secure Keyboard Entry in Terminal
defaults write com.apple.Terminal.plist SecureKeyboardEntry -int 1

# Set Desktop Background
sleep 5 # add sleep to make sure desktoppr works
/usr/local/bin/desktoppr "/Library/Desktop Pictures/Solid Colors/Space Gray.png"

# Set scroll direction for mouse
defaults write com.apple.swipescrolldirection -bool false

# Display filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set folders to be sorted first in Finder view
defaults write com.apple.finder.plist _FXSortFoldersFirst -bool true

#show Hard Drives, Network Drives, removable media on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Reset Finder
killall Finder
