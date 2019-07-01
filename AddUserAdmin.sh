#!/bin/bash
# 2019-05-01 awickert
# set a user as admin on a machine using script parameter 

username="$4"

dscl . -append /Groups/admin GroupMembership $username