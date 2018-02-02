#!/bin/bash
#
# Generic test script for ansible roles.

# Variables
WTD_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Script
printf "
**************************************** \n\
***        Ansible Testing           *** \n\
**************************************** \n\
"

printf "*** Step 1: Create valid ansible.cfg *** \n"
printf '[defaults]\nroles_path=../' > "$WTD_SCRIPT_DIR/../ansible.cfg"
printf "**************************************** \n"

printf "*** Step 2: Install Dependencies     *** \n"
if [ -f $WTD_SCRIPT_DIR/../requirements.yml ]; then
  ansible-galaxy install -v -r "$WTD_SCRIPT_DIR/../requirements.yml"
fi
printf "**************************************** \n"

printf "*** Step 3: Syntax Check             ***"
ansible-playbook "$WTD_SCRIPT_DIR/test.yml" -i "$WTD_SCRIPT_DIR/inventory" -vv --syntax-check || WTD_ERR=true
printf "**************************************** \n"

printf "*** Step 4: Linting                  *** \n"
ansible-lint -Rv "$WTD_SCRIPT_DIR/test.yml" || WTD_ERR=true
printf "**************************************** \n"

printf "*** Step 5: Clean Up                 *** \n"
rm -v "$WTD_SCRIPT_DIR/../ansible.cfg"
printf "**************************************** \n"

if [ $WTD_ERR ]; then
  printf "
  **************************************** \n\
  ***   Error occured - Tests failed   *** \n\
  **************************************** \n\
  "
  exit 1
else
  printf "
  **************************************** \n\
  ***        Tests succesfull          *** \n\
  **************************************** \n\
  "
  exit 0
fi
