#!/bin/bash
# 2019-05-01 awickert
# set an AD group as admin on a machine using script parameter 

group="$4"

dseditgroup -o edit -a "DOMAIN_NAME\${group}" -t group admin