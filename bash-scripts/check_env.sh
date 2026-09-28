#!/bin/bash
# ↑ Shebang
# Tells Linux: execute this script using Bash.


set -euo pipefail
# ↑ set = change Bash's behavior
#
# -e = exit if an unhandled command fails
#
# -u = treat an unset/undefined variable as an error
#
# -o pipefail = if a pipeline has multiple commands,
#               the pipeline fails if any command fails


ENV_NAME="${1:-development}"
#           │ │
#           │ └── Default value
#           │     If $1 is empty/unset → use "development"
#           │
#           └──── $1 = FIRST command-line argument
#
# Example:
# ./check_env.sh production
#                 ↑
#                 $1 = production
#
# So:
# ENV_NAME="production"
#
# If:
# ./check_env.sh
#
# There is no $1, so:
# ENV_NAME="development"


echo "=========================================="
# ↑ echo = print text to terminal


echo " Running Pre-flight Checks for: $ENV_NAME"
#                                      ↑
#                                      Variable expansion
#                                      Prints the value of ENV_NAME


echo "=========================================="


REQUIRED_TOOLS=("git" "docker" "curl" "jq")
#                ↑     ↑        ↑       ↑
#                Array elements
#
# Bash array:
# REQUIRED_TOOLS[0] = git
# REQUIRED_TOOLS[1] = docker
# REQUIRED_TOOLS[2] = curl
# REQUIRED_TOOLS[3] = jq


MISSING_COUNT=0
# ↑ Normal variable assignment
#
# IMPORTANT:
# No spaces around =
#
# Correct:
# MISSING_COUNT=0
#
# Wrong:
# MISSING_COUNT = 0


echo "Checking required CLI tools..."


for tool in "${REQUIRED_TOOLS[@]}"; do
#                 │             │
#                 │             └── [@]
#                 │                 Means ALL elements of the array
#                 │
#                 └──────────────── Array variable
#
# "${REQUIRED_TOOLS[@]}" means:
# git docker curl jq
#
# The loop takes them one by one:
#
# First iteration:
# tool="git"
#
# Second:
# tool="docker"
#
# Third:
# tool="curl"
#
# Fourth:
# tool="jq"


    if command -v "$tool" >/dev/null 2>&1; then
    #  │             │          │       │
    #  │             │          │       └── Redirect stderr
    #  │             │          │
    #  │             │          └────────── Redirect stdout
    #  │             │
    #  │             └──────────────────── Current tool
    #  │
    #  └────────────────────────────────── if condition
    #
    # command -v "$tool"
    # Checks whether the command exists in PATH.
    #
    # Example:
    # tool="git"
    #
    # command -v git
    #
    # If git exists → command succeeds
    # If git doesn't exist → command fails


        echo "  [OK]   $tool is installed"
        # ↑ Runs when command -v succeeds


    else
    # ↑ Runs when command -v fails


        echo "  [FAIL] $tool is MISSING!"


        MISSING_COUNT=$((MISSING_COUNT + 1))
        #              ↑                 ↑
        #              │                 │
        #              └── Arithmetic    │
        #                  operation     │
        #
        # $(( ))
        # Used for arithmetic in Bash.
        #
        # Example:
        # MISSING_COUNT=0
        #
        # $((0 + 1)) = 1
        #
        # Next missing tool:
        # $((1 + 1)) = 2


    fi
    # ↑ Ends the if/else statement


done
# ↑ Ends the for loop


echo "=========================================="


if [ "$MISSING_COUNT" -gt 0 ]; then
#  │  │                 │
#  │  │                 └── -gt = greater than
#  │  │
#  │  └──────────────────── [ ] = Bash test/condition
#  │
#  └─────────────────────── if
#
# Example:
#
# MISSING_COUNT=2
#
# [ 2 -gt 0 ]
#
# 2 is greater than 0 → TRUE
#
# If:
# MISSING_COUNT=0
#
# [ 0 -gt 0 ]
#
# FALSE


    echo "ERROR: $MISSING_COUNT required tool(s) missing. Deployment aborted."


    exit 1
    # ↑ exit = terminate the script
    #
    # 1 = FAILURE
    #
    # The script tells the operating system:
    # "I failed."


else
    # ↑ Runs when MISSING_COUNT is NOT greater than 0


    echo "SUCCESS: Environment '$ENV_NAME' is ready!"


    exit 0
    # ↑ exit = terminate the script
    #
    # 0 = SUCCESS
    #
    # The script tells the operating system:
    # "I completed successfully."

fi
# ↑ Ends the final if/else
