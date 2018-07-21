#!/bin/bash
#
# Generic test script for finding trailing whitespace.

# Variables
WTD_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WTD_COLOR_BLUE='\e[1;34m'
WTD_COLOR_GREEN='\e[1;32m'
WTD_COLOR_RED='\e[1;31m'
WTD_COLOR_OFF='\e[0m'

# Script
printf "$WTD_COLOR_BLUE
**************************************** \n\
***       Whitespace Checking        *** \n\
**************************************** \n\
$WTD_COLOR_OFF"

RESULT=$(find . -path "./.git" -prune -o -name "*.md" -prune -o -name "*.md.j2" -o -type f -exec grep -nE ".*\s+$" {} +)
EXIT_CODE=$?

RESULT_MD=$(find . -path ./.git -prune -o -regextype sed -regex "\(.*\.md\)\|\(.*\.md\.j2\)" -exec grep -nE ".*\s+$" {} +)
EXIT_CODE_MD=$?

if [ "$EXIT_CODE" -eq 0 ]; then
  printf "$WTD_COLOR_RED
Error occured - Found trailing whitespace \n\
$RESULT \n\
\n\
**************************************** \n\
$WTD_COLOR_OFF"
  if [ "$EXIT_CODE_MD" -eq 0 ]; then
    printf "\n\
Please also check the below Markdown files manually: \n\
$RESULT_MD \n"
  fi
  exit 1;
else
  printf "$WTD_COLOR_GREEN
**************************************** \n\
***  Whitespace checking successful  *** \n\
**************************************** \n\
  $WTD_COLOR_OFF"
  if [ "$EXIT_CODE_MD" -eq 0 ]; then
    printf "\n\
Please also check the below Markdown files manually: \n\
$RESULT_MD \n"
  fi
  exit 0;
fi
