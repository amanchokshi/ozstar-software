#!/bin/bash

# Function to print a message with a timestamp including milliseconds
log() {
  echo "[ $(date '+%Y-%m-%d %H:%M:%S.%3N') ] $1"
}
