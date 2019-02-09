#!/bin/sh

# Postinstall script for macOS startosinstall.
# Can be used with installr ./packages or Imagr workflows.
#

# Set computer name to a dummy name.
# This name will be used with Munki to install initial
# pakcges to every client. Therefore a Muni manifest
# with name NewCLient is used
/usr/sbin/scutil --set ComputerName NewClient
/usr/sbin/scutil --set HostName NewClient
/usr/sbin/scutil --set LocalHostName NewClient

# Try to set AppleLocale to Germany.
# With Mojave this does currently not work
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences.plist AppleLocale -string de_DE

# Add a certificate to system keychain
# Copy the certificate to /Users/Shared in the packacge
# first and remove it after ist was added.
/usr/bin/security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /Users/Shared/your.cert.cer
/bin/rm -f /Users/Shared/your.cert.cer

# Skip Apple Setup Assistant
/usr/bin/touch /private/var/db/.AppleSetupDone

# Configure time server and timezone
/usr/bin/sntp -S time.apple.com
/usr/sbin/systemsetup -settimezone Europe/Berlin

# Turn off computer sleep when connected to power
/usr/sbin/systemsetup -setcomputersleep Never
