#!/bin/sh
# /etc/acpi/powerbtn.sh
# Initiates a shutdown when the power putton has been
# pressed.

# If all else failed, just initiate a plain shutdown.
/sbin/shutdown -h now "Power button pressed"
