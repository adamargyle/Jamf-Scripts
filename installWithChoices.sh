#!/bin/bash
# 2020-03-01 awickert
# Install a pkg with choices.xml file, assuming the location of both the pkg file and the choices.xml file to be in /Library/Management

pkgName=$4
if [[ -z $pkgName ]]; then
	read -p "Package File Name:" pkgName
fi
choicesName=$5
if [[ -z $choicesName ]]; then
	read -p "choices.xml File Name:" choicesName
fi

installer -applyChoiceChangesXML "/Library/Management/${choicesName}" -pkg "/Library/Management/${pkgName}" -target /

rm -rf "/Library/Management/${choicesName}"
rm -rf "/Library/Management/${pkgName}"

exit 0