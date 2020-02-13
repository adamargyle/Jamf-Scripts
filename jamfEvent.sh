#!/bin/bash
# 2020-02-10 awickert
# run jamf policy by trigger

event=$4

jamf policy -event $event

exit 0