#!/bin/bash

if [[ -v TUNNELUP ]]; then
  if [[ -x $TUNNELUP ]]; then
    echo "INFO: Executing $TUNNELUP..."
    $TUNNELUP
    echo "INFO: $TUNNELUP returned $?"
  else 
    echo "WARNING: Variable TUNNELUP defined, but no executable file found at $TUNNELUP..."
  fi
else
  echo "INFO: TUNNELUP not defined."
fi
