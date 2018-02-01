#!/bin/bash
#
# Generic test script for ansible roles.

echo "****************************************"
echo "***        Ansible Testing           ***"
echo "****************************************"
echo ""

echo "*** Step 1: Create valid ansible.cfg ***"
printf '[defaults]\nroles_path=../' >ansible.cfg
echo ""

echo "*** Step 2: Install Dependencies     ***"
if [ -f requirements.yml ]; then
  ansible-galaxy install -v -r requirements.yml
fi
echo ""

echo "*** Step 3: Syntax Check             ***"
ansible-playbook ./tests/test.yml -i ./tests/inventory -vv --syntax-check || WTD_ERR=true
echo ""

echo "*** Step 4: Linting                  ***"
ansible-lint -Rv ./tests/test.yml || WTD_ERR=true
echo ""

echo "*** Step 5: Clean Up                 ***"
rm -v ansible.cfg
echo ""

if [ $WTD_ERR ]; then
  echo "****************************************"
  echo "***   Error occured - Tests failed   ***"
  echo "****************************************"
  exit 1
else
  echo "****************************************"
  echo "***        Tests succesfull          ***"
  echo "****************************************"
  exit 0
fi
