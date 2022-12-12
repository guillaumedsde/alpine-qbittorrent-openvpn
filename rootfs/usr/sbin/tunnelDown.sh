#!/bin/bash

if [[ -v TUNNELDOWN ]]; then
  if [[ -x $TUNNELDOWN ]]; then
    echo "INFO: Executing $TUNNELDOWN..."
    $TUNNELDOWN
    echo "INFO: $TUNNELDOWN returned $?"
  else 
    echo "WARNING: Variable TUNNELDOWN defined, but no executable file found at $TUNNELDOWN..."
  fi
else
  echo "INFO: TUNNELDOWN not defined."
fi
