#!/bin/sh
#################################
# Make user local admin.
# Can be used in JSS Policies where $3 is the currently logged in user
#################################
# Author: Manfred Roiger
# Created: 29.07.2015
# Last change: 30.12.2016
#################################

# Append local user in $3 to local admin group
/usr/bin/dscl . append /Groups/admin GroupMembership $3
