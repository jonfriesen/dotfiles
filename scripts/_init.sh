#!/bin/bash

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the first argument passed to the script
script_name=$1
shift

# Flag to check if script name is found
script_found=false

# Loop through all files in the directory
for file in $DIR/*.sh; do
  # Get the filename without the .sh extension
  filename="${file%.*}"
  command=`basename $filename`
  if [[ $command != _* ]]; then
    if [ "$command" == "$script_name" ]; then
    # Run the script with the rest of the arguments passed through
    "$file" "$@"
    script_found=true
    exit 0
    fi
  fi
done

if [ "$script_found" = false ]; then
  echo "Script not found: $script_name"
  echo "Available options:"
  for file in $DIR/*.sh; do
    # Get the filename without the .sh extension
    filename="${file%.*}"
    command=`basename $filename`
    if [[ $command != _* ]]; then
      echo " - $command"
    fi
  done
fi
