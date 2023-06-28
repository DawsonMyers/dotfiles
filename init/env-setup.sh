# #!/bin/bash

# conadac() {
#     for f in $(find . -name conda); do
#     echo COND = $f
#     done
# }

# function activate_venv() {
#     currentDepth=$(pwd | tr -cd '/' | wc -c)
#     minDiff=999999 # Initialize with a large value
#     minPath=""

#     # Perform a depth-first search on the current directory
#     while IFS= read -r -d '' dir; do
#         # Check if the directory contains an 'activate' script
#         if [[ -f "$dir/activate" ]]; then
#             dirDepth=$(echo "$dir" | tr -cd '/' | wc -c)
#             depthDiff=$(( dirDepth - currentDepth ))

#             # If this 'activate' script is closer to the current directory, update minPath
#             if (( $depthDiff < $minDiff )); then
#                 minDiff=$depthDiff
#                 minPath=$dir
#             fi
#         fi
#     done < <(find . -type d \( -path "*/venv/bin" -o -path "*/conda/bin" \) -print0)

#     if [[ -n $minPath ]]; then
#         source "${minPath}/activate"
#         echo "Activated venv at ${minPath}"
#     else
#         echo "No venv or conda env found"
#     fi
# }

# # /etc/sysctl.conf

# pip install cpustat

