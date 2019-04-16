<!--
name: README.md
description: This file contains important information for the repository.
author: while-true-do.io
contact: hello@while-true-do.io
license: BSD-3-Clause
-->

<!-- github shields -->
[![Github (tag)](https://img.shields.io/github/tag/while-true-do/ansible-skeleton.svg)](https://github.com/while-true-do/ansible-skeleton/tags)
[![Github (license)](https://img.shields.io/github/license/while-true-do/ansible-skeleton.svg)](https://github.com/while-true-do/ansible-skeleton/blob/master/LICENSE)
[![Github (issues)](https://img.shields.io/github/issues/while-true-do/ansible-skeleton.svg)](https://github.com/while-true-do/ansible-skeleton/issues)
[![Github (pull requests)](https://img.shields.io/github/issues-pr/while-true-do/ansible-skeleton.svg)](https://github.com/while-true-do/ansible-skeleton/pulls)
<!-- travis shields -->
[![Travis (com)](https://img.shields.io/travis/com/while-true-do/ansible-skeleton.svg)](https://travis-ci.com/while-true-do/ansible-skeleton)

# Ansible Skeleton

The skeleton to create new [Ansible](https://docs.ansible.com/) roles.

## Motivation

Creating a repository is always somewhat interesting and needs a lot
explanation. This repository should help to reduce the effort and prepare a
ready-to-use environment.

## Description

-   provides template for new ansible roles
-   provides defaults for new ansible roles
-   provides steps for new ansible roles
-   provides guidance for ansible new roles
-   usable with `ansible-galaxy init`

## Requirements

-   [virtualenv](https://virtualenv.pypa.io/en/stable/)
-   [Docker](https://docs.docker.com/)

## Installation

Install from [Github](https://github.com/while-true-do/ansible-skeleton)
```
git clone https://github.com/while-true-do/ansible-skeleton.git
```

## Usage

Before creating a new role, please read the below information very carefully.
They will explain, how a new role should look like and which steps are needed.

### Install Ansible

The recommended and portable way to install [Ansible](https://docs.ansible.com/)
is via [virtualenv](https://virtualenv.pypa.io/en/stable/).

```
# Create a new virtualenv
virtualenv $env_name
# Activate virtualenv
source $env_name/bin/activate
# Install Ansible
pip install ansible
```

On some selinux enabled systems like Fedora, you have to symlink the selinux
site-packages manually.

```
# Search local site-packages
find /usr/lib64 -iname "*selinux*"
# Now you have to symlink the selinux directory and the python-c-bindings
# Example:
cd $env_name
ln -s /usr/lib64/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so ./lib/python3.7/site-packages/selinux
ln -s /usr/lib64/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so ./lib/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so
```

### Configure Ansible

[Ansible](https://docs.ansible.com/) configuration can be done in multiple
files, depending on your needs.

```
# Edit system ansible.cfg
sudo vi /etc/ansible/ansible.cfg

# Edit user ansible.cfg
vi ~/.ansible.cfg

# Add one to the specific role
vi ansible.cfg (in the current directory)
```

You have to add the following lines:

```
[galaxy]
role_skeleton = <path_to_ansible-skeleton>/role
role_skeleton_ignore = ^.git$,^.*/.git_keep$
```

### Install Molecule

[Molecule](https://molecule.readthedocs.io/en/stable/) must be installed in the
same [virtualenv](https://virtualenv.pypa.io/en/stable/) (see above).

```
# Activate virtualenv
source $env_name/bin/activate
# Install molecule and docker support
pip install molecule[docker]
```

### Create Ansible role

Some manual steps are needed to create new role from scratch.

```
# Step 1: Create Directory from skeleton
ansible-galaxy init $role_name
mv $role_name while_true_do.$role_name

# Step 2: Initialize molecule
molecule init scenario -r while_true_do.$role_name

# Step 3: Move molecule.yml
mv molecule.yml molecule/default/molecule.yml

# Step 4: Review and Modify all "TODO" steps
grep -r "TODO" while_true_do.$role_name
```

### Add Tests to the role

Testing is key for new roles. You want to get comfortable with the following
files and tools.

#### Molecule

[Molecule](https://molecule.readthedocs.io/en/stable/) is the testing framework
used for Ansible. You should have a look at the `molecule.yml` and configure
it properly with OS, you want to test.

#### Testinfra

[Testinfra](https://testinfra.readthedocs.io/en/stable/) is a testing suite,
which should be used for writing your tests, before writing the role. Since
Ansible is having a very declarative way of handling tasks, this is not needed
in all cases, but you should get comfortable with the suite and start writing
tests, when possible. You should review and tune the `test_default.py`, after
initializing the role with Molecule.

**Example**
```
import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

# Test, if httpd is installed
def test_httpd_package(host):
    pkg = host.package("httpd")
    assert pkg.is_installed

# Test, if httpd service is running
def test_httpd_service(host):
    srv = host.service("httpd")
    assert srv.is_running
    assert srv.is_enabled
```

#### Travis CI

[Travis CI](travis-ci.com) does the test automation. The skeleton provides a
`.travis-yml`, which should be "okay" for many Ansible use cases. Nevertheless,
please feel free to review the file and add tests or scenarios, when needed.

### Test Ansible role with Molecule

[Molecule](https://molecule.readthedocs.io/en/stable/) has multiple ways of
testing roles.

```
# test (create + tests + destroy)
molecule test

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

## Conventions for a new role

Thank you for taking time ti create a new Ansible role. The below conventions
will help to have some Best Practices applied and ensure, that the role is
according to our standards.

### Role Definition

Roles are self-contained portable units of [Ansible](https://docs.ansible.com/)
automation. They should be reusable and provide a full lifecycle of a service.
They should default to common standards and policies.

### Convention over Configuration

A good role forces the user to enter critical data and avoids to ask for
defaults. For example: A web server should run on port 80 per default and the
user should not need to configure this behavior. Instead, when a database
password should be chosen wisely, the user must be forced to enter one.

The user should only define unconventional and mandatory aspects of the role.

### Install, Remove, Update

Most of our roles are needed to install or configure a software. To ensure a
high quality user experience, you should also consider, that roles can do
updates or removals. This will ensure, that a user can do updates with our roles
and remove the software, when he no longer needs it.

### Name tasks, blocks, handlers

You should name all of your tasks and blocks properly. Avoid variables in the
name. If a task can be tuned to "Install, Remove, Update" a package, you
can name it "Manage Package" or similar.

### "become: yes"

A role should know, when privileges are needed. Therefore, you should always
test and add "become" to the tasks, when needed. Running playbooks fully in
"become: yes" should be avoided.

### Role Variables

Most users will start using roles from different providers and contributors.
To avoid scenarios where the user does not know why "myRoleXXX: foo" breaks
the playbook, you should always prefix your variables properly.

Good practice is, to have a namespace and $role_name in the variables.

**Good**
```
wtd_prv_ec2_vm_count: 2
wtd_srv_nginx_port: 8080
```
**Bad**
```
vm_count: 2
port: 8080
```

### Keep provisioning separate from configuration and app deployment

A role, that install something is cool. The role should also take care of
"Best Practices", like security related configuration. As an example, you can
think of a role "srv_postgresql":

**Good**

-  install postgresql
-  initialize postgresql
-  tune postgresql
-  open ports for postgresql
-  basic selinux tuning

**Bad**

-  creating new users in postgresql
-  creating new databases
-  filling in content in the database

This should ensure, that roles can be used again and again.

### Role Naming Convention

Naming a role is straight forward. Nevertheless, since we are having different
namespaces for github, galaxy, etc. this may look a bit confusing.

- Github => $github-prefix-$role_name
- Galaxy => $galaxy-prefix.$role_name

As you can see, there are 3 variables.

| Variable      | Default       | Description |
| ------------- | ------------- | ----------- |
| github-prefix | ansible-role  | Used in github to indicate an ansible role. |
| galaxy-prefix | while_true_do | Namespace of our galaxy environment. |
| role_name     | app_*         | Roles to install a client application or user application. |
|               | cfg_*         | Roles to do system configuration like users, kernel, etc. |
|               | prv_*         | Roles to use a provider service like aws, azure, nagios. |
|               | rpo_*         | Roles to enable, disable all kinds of repositories. |
|               | srv_*         | Roles to install server or services like docker, httpd, ntp. |
|               | sys_*         | Roles to do something with a system itself, like upgrade or reboot. |

This will lead to a clear differentiation between provisioning, OS configuration,
application, etc.

### Role dependency handling

You should avoid to enforce dependencies via meta/main.yml. The user should be
put in the situation, that he can choose, if he wants to configure something
manually or do other preparations.

Nevertheless, you should always show possible dependencies and maintain the
`requirements.yml` and `README.md`. If this is needed, always try to use
specific versions.

### Supported OS

In most cases, you want to have the following OS supported and tested. These
are already prepared in the `meta/main.yml` and `molecule.yml`.

-   Fedora
-   CentOS

Optionally, you should think about the following OS.

-   Debian
-   Ubuntu LTS
-   OracleLinux
-   RedHat

Other OS can be included, but without priority.

## Testing

This repository is not tested.

## Contribute

Thank you so much for considering to contribute. We are very happy, when somebody
is joining the hard work. Please fell free to open
[Bugs, Feature Requests](https://github.com/while-true-do/ansible-skeleton/issues)
or [Pull Requests](https://github.com/while-true-do/ansible-role-skeleton/pulls) after
reading the [Contribution Guideline](https://github.com/while-true-do/doc-library/blob/master/docs/CONTRIBUTING.md).

See who has contributed already in the [kudos.txt](./kudos.txt).

## License

This work is licensed under a [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

## Contact

-   Site <https://while-true-do.io>
-   Twitter <https://twitter.com/wtd_news>
-   Code <https://github.com/while-true-do>
-   Mail [hello@while-true-do.io](mailto:hello@while-true-do.io)
-   IRC [freenode, #while-true-do](https://webchat.freenode.net/?channels=while-true-do)
-   Telegram <https://t.me/while_true_do>
