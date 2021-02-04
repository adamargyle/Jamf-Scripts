#!/bin/bash
# awickert 2018-05-14
# Clear NVRAM/PRAM via command line, rebuild cache

## Rebuild cache
update_dyld_shared_cache -root / -force -debug
/usr/libexec/xpchelper --rebuild-cache

## Clear all nvram arguments
nvram -c