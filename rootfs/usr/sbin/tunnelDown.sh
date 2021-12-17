#!/bin/bash

if [[ -x /scripts/tunnelDown.sh ]]; then
  echo "Executing /scripts/tunnelDown.sh"
  /scripts/tunnelDown.sh 
  echo "/scripts/tunnelDown.sh returned $?"
else
  echo "/scripts/tunnelDown.sh does not exist."
fi