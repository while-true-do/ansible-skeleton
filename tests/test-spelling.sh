#!/bin/bash
#
# Generic test script for Spellchecking markdown files.

# Variables
WTD_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Script
printf "
**************************************** \n\
***        Spell Checking            *** \n\
**************************************** \n\
"

BADWORDS=$(sed '/^```/,/^```/d' "$WTD_SCRIPT_DIR/../README.md" | aspell --lang=en --encoding=utf-8\
       	--personal=./tests/.aspell.en.pws list)

BADWORDS_COUNT=$(echo $BADWORDS | wc -w)

if [ $BADWORDS_COUNT -gt 0 ]; then
  printf "
  Error occured - Found $BADWORDS_COUNT bad word(s) \n\
  \n\
  Bad Words: \n\
  $BADWORDS \n\
  \n\
  **************************************** \n\
  "
  exit 1;
else
  printf "
  **************************************** \n\
  ***     Spellchecking successfull    *** \n
  **************************************** \n\
  "
  exit 0;
fi
