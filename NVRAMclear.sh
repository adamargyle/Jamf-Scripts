#!/bin/bash
# awickert 2018-05-14
# Clear NVRAM/PRAM via command line, rebuild cache

## rebuild cache
update_dyld_shared_cache -root / -force -debug
/usr/libexec/xpchelper --rebuild-cache

## clear all nvram arguments
nvram -c