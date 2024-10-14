#!/bin/bash

# Function to display usage instructions
function show_help() {
  echo "Usage: $0 [OPTIONS] <logfile>"
  echo "Options:"
  echo "  -h                Show this help message."
  echo "  -p <pattern>      Provide a pattern in order to search for in the log file."
  echo "  -c                Count the number of matches."
}

function error_message() {
  echo "Error: $1"
  echo "Use -h for help."
  exit 1
}

# Check for arguments
if [[ $# -eq 0 ]]; then
  error_message "No arguments provided."
fi

pattern=""
count_matches=0
logfile=""

# Parse command-line options
while getopts ":p:ch" opt; do
  case $opt in
    p)  # Pattern to search for
      pattern="$OPTARG"
      ;;
    c)  # Enable match counting
      count_matches=1
      ;;
    h)  # Show help
      show_help
      exit 0
      ;;
    \?) # Invalid option
      error_message "Invalid option: -$OPTARG"
      ;;
    :)  # Missing argument for an option
      error_message "Option -$OPTARG requires an argument."
      ;;
  esac
done

shift $((OPTIND -1))

logfile=$1

if [[ -z "$logfile" ]]; then
  error_message "No logfile specified."
elif [[ ! -f "$logfile" ]]; then
  error_message "Logfile '$logfile' does not exist."
fi

if [[ -z "$pattern" ]]; then
  error_message "No pattern provided. You have to use -p to specify a pattern."
fi

# Perform the search
if [[ $count_matches -eq 1 ]]; then
  # Count the number of matches using grep and regex
  match_count=$(grep -oP "$pattern" "$logfile" | wc -l)
  echo "Number of matches found: $match_count"
else
  grep -P "$pattern" "$logfile"
fi
