#!/bin/bash

set -euo pipefail

# Read the input file
TXT_FILE="$1"
TARGET_FOLDER="$2"

# Read the file line by line
while read -r line
do
    cp "$line/CROPS"
done < $TXT_FILE