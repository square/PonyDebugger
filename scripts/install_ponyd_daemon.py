#!/usr/bin/python
import os
import platform
import plistlib
from subprocess import CalledProcessError, check_call

if not (platform.mac_ver()[0] >= 10.4):
	print "FATAL ERROR: This install script is not supported on your operating system."
	exit(1)

dev_null = open(os.devnull, 'w')

try:
    check_call(["/usr/local/bin/ponyd -h"],shell=True, stdout=dev_null, stderr=dev_null)
except CalledProcessError:
    print "FATAL ERROR: `/usr/local/bin/ponyd` not found, or not working right.\n\
Double check your ponyd installation and try running this script again."
    exit(1)


plist = { 'Label' : 'com.joshavant.ponyd_launcher',
'ProgramArguments': ['/usr/local/bin/ponyd', 'serve', '--listen-interface=127.0.0.1'],
'KeepAlive':True}

plistFile = open(os.path.expanduser('~/Library/LaunchAgents/com.joshavant.ponyd_launcher.plist'), 'w')

plistlib.writePlist(plist, plistFile)