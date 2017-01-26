#!/bin/sh

################################################################################
# Run a Python script to set autoproxyurl and searchdomains for ethernet and wifi.
# Regardless which ethernet interface is found (Thunderbolt, Apple USB, etc.)
# The Python script will be copied to /Users/Shared/set_proxy_sd.py by this package
################################################################################
# Created by: Manfred Roiger (manfred.roiger@gmail.com)
# Last change: 24.01.2017
################################################################################

# Create input file for Python script
/usr/sbin/networksetup -listallnetworkservices >/tmp/netwokservices.txt

# Run Python script on file and configure all relevant network interfaces
/usr/bin/python /Users/Shared/set_proxy_sd.py /tmp/netwokservices.txt

# Clean up
/bin/rm -f /tmp/netwokservices.txt
/bin/rm -f /Users/Shared/set_proxy_sd.py
