#!/bin/bash

echo "INFO: VPN connection is UP"

if [[ -x /scripts/tunnelUp.sh ]]; then
  echo "Executing scripts/tunnelUp.sh"
  /scripts/tunnelUp.sh 
  echo "/scripts/tunnelUp.sh returned $?"
else
  echo "/scripts/tunnelUp.sh does not exist."
fi
