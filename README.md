<!--
name: README.md
description: This file contains important information for the repository.
author: while-true-do.io
contact: hello@while-true-do.io
license: BSD-3-Clause
-->

<!-- github shields -->
![](https://img.shields.io/github/tag/while-true-do/ansible-role-{{ role_name }}.svg)
![](https://img.shields.io/github/license/while-true-do/ansible-role-{{ role_name }}.svg)
![](https://img.shields.io/github/issues/while-true-do/ansible-role-{{ role_name }}.svg)
![](https://img.shields.io/github/issues-pr/while-true-do/ansible-role-{{ role_name }}.svg)

# Ansible Skeleton

The while-true-do skeleton to create new ansible-roles.

## Motivation

Creating a repository is always somewhat interesting and needs a lot explanation. This repository should help to reduce the effort and prepare a ready-to-use environment.

## Description

-   provides lot of template for new roles
-   provides lot of defaults for new roles
-   usable with `ansible-galaxy init`

## Requirements

-   Virtualenv
-   Running Docker Service

## Installation

Install from [Github](https://github.com/while-true-do/ansible-skeleton)
```
git clone https://github.com/while-true-do/ansible-skeleton.git
```

## Usage

### Install Ansible

The recommended and portable way to install ansible is via virtualenv.

```
# Create a new virtualenv
virtualenv --no-site-packages <env_name>
# Activate virtualenv
source <env_name>/bin/activate
# Install Ansible
pip install ansible
```

Sometimes, you have to symlink the selinux packages manually.

```
# Search local site-packages
find /usr/lib64 -iname "*selinux*"
# Now you have to symlink the selinux directory and the python-c-bindings
# Example:
cd <env_name>
ln -s /usr/lib64/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so ./lib/python3.7/site-packages/selinux
ln -s /usr/lib64/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so ./lib/python3.7/site-packages/_selinux.cpython-37m-x86_64-linux-gnu.so
```

### Configure Ansible

Ansible configuration can be done in multiple files, depending on your needs.

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

### Install molecule

Molecule must be installed in the same virtualenv (see above).

```
# Activate virtualenv
source <env_name>/bin/activate
# Install molecule and docker support
pip install molecule[docker]
```

### Initialize a new role

You only have to do 3 steps.

```
# Step 1: Initialize a new role
ansible-galaxy init <role_name>
mv <role_name> while_true_do.<role_name>

# Step 2: Modify all "TODO" steps
grep -r "TODO" while_true_do.<role_name>

# Step 3: Initialize
molecule init scenario -r <while_true_do.role_name>
```

### Test a new role

Molecule has multiple ways of testing role.

```
# test
molecule test
# lint
molecule lint
# converge
molecule converge
```

## Testing

This repository is not tested.

## Contribute

Thank you so much for considering to contribute. We are very happy, when somebody
is joining the hard work. Please fell free to open
[Bugs, Feature Requests](https://github.com/while-true-do/ansible-role-{{ role_name }}/issues)
or [Pull Requests](https://github.com/while-true-do/ansible-role-{{ role_name }}/pulls) after
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
