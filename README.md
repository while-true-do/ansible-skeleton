<!--
name: README.md
description: This file contains important information for the repository.
author: while-true-do.io
contact: hello@while-true-do.io
license: BSD-3-Clause
-->

<!-- github shields -->
![](https://img.shields.io/github/tag/while-true-do/ansible-skeleton.svg)
![](https://img.shields.io/github/license/while-true-do/ansible-skeleton.svg)
![](https://img.shields.io/github/issues/while-true-do/ansible-skeleton.svg)
![](https://img.shields.io/github/issues-pr/while-true-do/ansible-skeleton.svg)

# Ansible Skeleton

The skeleton to create new ansible roles.

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

Before creating a new role, please read the below information very carefully.

### Install Ansible

The recommended and portable way to install ansible is via virtualenv.

```
# Create a new virtualenv
virtualenv --no-site-packages $env_name
# Activate virtualenv
source $env_name/bin/activate
# Install Ansible
pip install ansible
```

Sometimes, you have to symlink the selinux packages manually.

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
source $env_name/bin/activate
# Install molecule and docker support
pip install molecule[docker]
```

### Initialize a new role

You only have to do 4 steps.

```
# Step 1: Initialize a new role
ansible-galaxy init $role_name
mv $role_name while_true_do.$role_name

# Step 2: Modify all "TODO" steps
grep -r "TODO" while_true_do.$role_name

# Step 3: Initialize
molecule init scenario -r while_true_do.$role_name

# Step 4: Move molecule.yml
mv molecule.yml molecule/default/molecule.yml
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

### Conventions for a new role

If you want to create a new role, you should stick to the below conventions.

#### Role Definition

Roles are self-contained portable units of ansible automation. They should be
reusable and provide a full lifecycle of a service. The should default to common
standards and policies.

#### Convention over Configuration

A good role forces the user to enter critical data and avoids to ask for
defaults. For example: A web server should run on port 80 per default and the
user should not need to configure this behavior. Instead, when a database
password should be chosen wisely, the user must be forced to enter one.

The user should only define unconventional and mandatory aspects of the role.

#### Install, Remove, Update

Many roles are used to install and configure a software. Sometimes, it is needed
to have a role, that needs to remove a software or configuration. Most roles
should be considered as "Install, Update, Remove" Roles and therefore provide
a way to do these jobs.

#### Role Name tasks, blocks, handlers

You should name all of your tasks and blocks properly. Avoid variables in the
name. If a task can be tuned to "Install, Remove, Update" a package, you
can name it "Manage Package" or similar.

#### Roles and "become: yes"

A role should know, when privileges are needed. Therefore, you should always
test and add "become" to the tasks, when needed. Running playbooks fully in
"become: yes" should be avoided.

#### Role variable prefixing

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

#### Keep provisioning separate from configuration and app deployment

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

#### Role Naming Convention

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

This will lead to a clear differentiation between provisioning, OS configuration,
application, etc.

#### Role dependency handling

You should avoid to enforce dependencies via meta/main.yml. The user should be
put in the situation, that he can choose, if he wants to configure something
manually or do other preparations.

Nevertheless, you should always show possible dependencies and maintain the
`requirements.yml` and `README.md`. If this is needed, always try to use
specific versions.

#### Supported OS

In most cases, you want to have the following OS supported and tested.

-   Fedora
-   CentOS
-   Oraclelinux

Optionally, you should think about the following OS (in this order).

-   Debian
-   Ubuntu

#### Example Playbook

An example pseudo playbook, that facilitates the conventions may look like the
below code.

```
---
- hosts: localhost
  connection: local
  roles:
    - role: while-true-do.prv_ec2
      wtd_prv_ec2_vm_count: 2
      wtd_prv_ec2_vm_group: web

- hosts: all
  roles:
    - role: while_true_do.cfg_user
      wtd_cfg_user_name: admin
      wtd_cfg_user_pass: $$$ENCRYPTED_PASS

    - role: while_true_do.cfg_sudo
      wtd_cfg_sudo_group: developers

- hosts: web
  roles:
    - role: while_true_do.rpo_nginx

    - role: while_true_do.srv_nginx
      wtd_srv_nginx_port: 8080
```

A user does not need to do this configuration in the playbook itself.
Using **group_vars** or **host_vars** can solve the same purpose.

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
