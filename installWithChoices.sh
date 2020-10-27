#!/bin/bash
# awickert 2020-03-01
# Install a pkg with choices.xml file, assuming the location of both the pkg file and the choices.xml file to be in /Library/Management

## checks for variables, asks if they are not provided
pkgName=$4
if [[ -z $pkgName ]]; then
	read -p "Package File Name:" pkgName
fi
choicesName=$5
if [[ -z $choicesName ]]; then
	read -p "choices.xml File Name:" choicesName
fi

## run installer with the choices.xml 
installer -applyChoiceChangesXML "/Library/Management/${choicesName}" -pkg "/Library/Management/${pkgName}" -target /

## delete the cached files
rm -rf "/Library/Management/${choicesName}"
rm -rf "/Library/Management/${pkgName}"