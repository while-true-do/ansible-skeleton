# Ansible Role Testing

## Table of Contents

-   [Molecule](Molecule)
-   [Testinfra](Testinfra)
-   [Travis CI](Travis_CI)

## Molecule

[Molecule](https://molecule.readthedocs.io/en/stable/) is the testing framework
used for Ansible. You should have a look at the `molecule.yml`.

Cheatsheet:

```
# test (create + test + destroy)
molecule test
# You can handover more details according to molecule.yml
name="myName" image="myImage:10" pygroup="python3" molecule test

# create (create docker container)
molecule create
# lint (check syntax)
molecule lint
# converge (run the role / playbook)
molecule converge
# verify (run testinfra tests)
molecule verify
# destroy (destroy the VMs)
molecule destroy
```

## Testinfra

[Testinfra](https://testinfra.readthedocs.io/en/stable/) is a testing suite,
which should be used for writing your tests, before writing the role. Since
Ansible is having a very declarative way of handling tasks, this is not needed
in all cases, but you should get comfortable with the suite and start writing
tests, when possible. You should review and tune the `test_default.py`, after
initializing the role with Molecule.

Some example code is given in the
[role skeleton](role/molecule/default/test_default.py).

## Travis CI

[Travis CI](travis-ci.com) does the test automation. The skeleton provides a
`.travis-yml`, which should be "okay" for many Ansible use cases. Nevertheless,
please feel free to review the file and add tests, scenarios or OS support.
