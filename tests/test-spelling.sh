#!/bin/bash
#
# Generic test script for Spellchecking markdown files.

echo "****************************************"
echo "***        Spell Checking            ***"
echo "****************************************"
echo ""

BADWORDS=$(sed '/^```/,/^```/d' README.md | aspell --lang=en --encoding=utf-8\
       	--personal=./tests/.aspell.en.pws list)

BADWORDS_COUNT=$(echo $BADWORDS | wc -w)

if [ $BADWORDS_COUNT -gt 0 ]; then
  echo "Error occured - Found $BADWORDS_COUNT bad word(s)"
  echo ""
  echo "$BADWORDS"
  echo ""
  echo "****************************************"
  exit 1;
else
  echo "*** Spellchecking successfull ***"
  exit 0;
fi


