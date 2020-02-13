#!/bin/bash
# 2019-11-5 awickert
# Install a pkg with choices.xml file, assuming the location of both the pkg file and the choices.xml file to be in /Library/Management

pkgName=$4
choicesName=$5

installer -applyChoiceChangesXML "/Library/Management/${choicesName}" -pkg "/Library/Management/${pkgName}" -target /

rm -rf "/Library/Management/${choicesName}"
rm -rf "/Library/Management/${pkgName}"

exit 0