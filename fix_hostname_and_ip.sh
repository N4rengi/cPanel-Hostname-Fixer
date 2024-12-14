#!/bin/bash
# Script to fix IP issues and resolve hostname lock problem in cPanel

echo "Starting process to fix IP and hostname issues in cPanel..."

# Step 1: Fix IP issues
echo "Step 1: Running mainipcheck..."
/scripts/mainipcheck

echo "Step 2: Running fixetchosts..."
/scripts/fixetchosts

echo "Step 3: Building cpnat..."
/scripts/build_cpnat

echo "Step 4: Restarting IP aliases service..."
/scripts/restartsrv_ipaliases

# Step 5: Remove hostname update lock
LOCK_FILE="/var/cpanel/.application-locks/UpdateHostname"
if [[ -f "$LOCK_FILE" ]]; then
    echo "Step 5: Removing lock file: $LOCK_FILE..."
    rm -rf "$LOCK_FILE"
    echo "Lock file removed successfully."
else
    echo "Step 5: No lock file found. Skipping..."
fi

# Step 6: Set hostname
NEW_HOSTNAME="yourhostname.domainname.tld"
echo "Step 6: Setting the hostname to $NEW_HOSTNAME..."
/usr/local/cpanel/bin/set_hostname "$NEW_HOSTNAME"

echo "All steps completed. Please verify the hostname and IP configuration."
