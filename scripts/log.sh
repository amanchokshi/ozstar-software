#!/bin/bash

# Function to print a message with a timestamp including milliseconds
log() {
  # Check if stdout is a terminal
  if [ -t 1 ]; then
    # Define color codes
    BLACK='\033[0;30m'
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
    echo -e "${BLACK}[${NC}$(date -u '+%Y-%m-%dT%H:%M:%SZ') ${BLUE} LOG ${BLACK}] ${NC}$1"
  else
    # No colors if not printing to a terminal
    echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')  LOG ] $1"
  fi
}
