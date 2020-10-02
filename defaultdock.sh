#!/bin/bash
# awickert 9-30-2020
# sets a default dock usting dockutil, to be run via outset in login-once

# set to the path of dockutil
dockutil="/usr/local/bin/dockutil"

# Delete everything from the dock and replace it with a specific selection of apps.
${dockutil} --remove all --no-restart
sleep 2 # we add a delay so that the dock has time to inialize the removal
${dockutil} --add /Applications/Firefox.app --no-restart
${dockutil} --add /Applications/Google\ Chrome.app --no-restart
${dockutil} --add /Applications/Microsoft\ Word.app --no-restart
${dockutil} --add /Applications/Microsoft\ Excel.app --no-restart
${dockutil} --add /Applications/Microsoft\ PowerPoint.app --no-restart
${dockutil} --add /Applications/Self\ Service.app --no-restart
${dockutil} --add '/Applications' --view list --sort name --no-restart
${dockutil} --add '~/Downloads' --view fan