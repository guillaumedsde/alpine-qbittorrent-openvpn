#!/bin/bash

if [[ -x /${SCRIPTS_DIR}tunnelUp.sh ]]; then
  echo "Executing /${SCRIPTS_DIR}tunnelUp.sh"
  /${SCRIPTS_DIR}tunnelUp.sh 
  echo "/${SCRIPTS_DIR}tunnelUp.sh returned $?"
else
    echo "${SCRIPTS_DIR}/tunnelUp.sh does not exist."
fi