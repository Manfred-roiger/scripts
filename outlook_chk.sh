#!/bin/sh

###################################################
#
# Extension attribute script to check if Outlook 2011 or Outlook 2016 is running.
# Outlook 2011 is /Applications/Microsoft Office 2011/Microsoft Outlook.app
# Outlook 2016 is /Applications/Microsoft Outlook.app
#
# Author: Manfred Roiger
# Last modified: 19.08.2016
#
###################################################

OUTLOOK=`/bin/ps -ef | /usr/bin/grep Outlook | /usr/bin/egrep -v grep| /usr/bin/awk '{ print $10 }' | /usr/bin/cut -c1-4`

# If Outlook 2011 is running, result is 2011 else result is "Outl" for Outlook 2016 or empty if Outlook is not running
echo "<result>$OUTLOOK</result>"



