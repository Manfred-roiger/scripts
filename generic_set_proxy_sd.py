import fileinput
import subprocess
import string

################################################################################
# Python script to set autoproxyurl and searchdomains for ethernet and wifi.
# Regardless which ethernet interface is found (Thunderbolt, Apple USB, etc.)
################################################################################
# Created by: Manfred Roiger (manfred.roiger@gmail.com)
# Last change: 24.01.2017
################################################################################

interface_list = []
current_line = ""

# Args for -setsearchdomains, replace with your required search donains
net_cmd2 = ["/usr/sbin/networksetup", "-setsearchdomains", "", "dom1.yourdomain.org", "dom2.yourdomain.org", "dom3.yourdomain.org"]
# Args fpr -setautoproxyurl, replace with your required proxy pac URL
net_cmd3 = ["/usr/sbin/networksetup", "-setautoproxyurl", "", "http://proxy.yourdomain.org:8080/yourproxy.pac"]

# Read a file in ${1} containing the output of:
# /usr/sbin/networksetup -listallnetworkservices
for line in fileinput.input():
    current_line = line.strip("\n")
    interface_list.append(current_line)

for interface in interface_list:
    # Set proxy URL and search domains for all Ethernet interfaces
    if "Ethernet" in interface:
        # Search domains
        net_cmd2[2] = interface
        subprocess.Popen(net_cmd2)
        # Proxy URL
        net_cmd3[2] = interface
        subprocess.Popen(net_cmd3)
        continue
    # Set proxy URL and search domains for Wi-Fi
    if "Wi-Fi" in interface:
        # Search domains
        net_cmd2[2] = interface
        subprocess.Popen(net_cmd2)
        # Proxy URL
        net_cmd3[2] = interface
        subprocess.Popen(net_cmd3)
