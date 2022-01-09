#!/bin/bash

echo "INFO: VPN connection is UP"

if [[ -x /scripts/tunnelUp.sh ]]; then
  echo "INFO: Executing scripts/tunnelUp.sh"
  /scripts/tunnelUp.sh 
  echo "INFO: /scripts/tunnelUp.sh returned $?"
else
  echo "INFO: /scripts/tunnelUp.sh does not exist."
fi
