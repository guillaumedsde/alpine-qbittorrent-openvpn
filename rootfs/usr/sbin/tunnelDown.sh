#!/bin/bash

if [[ -x /${SCRIPTS_DIR}tunnelDown.sh ]]; then
  echo "Executing /${SCRIPTS_DIR}tunnelDown.sh"
  /${SCRIPTS_DIR}tunnelDown.sh 
  echo "/${SCRIPTS_DIR}tunnelDown.sh returned $?"
else
    echo "${SCRIPTS_DIR}/tunnelDown.sh does not exist."
fi