#!/bin/bash

if [[ -x /scripts/tunnelDown.sh ]]; then
  echo "INFO: Executing /scripts/tunnelDown.sh"
  /scripts/tunnelDown.sh 
  echo "INFO: /scripts/tunnelDown.sh returned $?"
else
  echo "INFO: /scripts/tunnelDown.sh does not exist."
fi