# Ansible Role Conventions

Thank you for taking time to create a new Ansible Role. The below conventions
will help to have some Best Practices applied and ensure, that the role is
according to our standards.

## Table of Contents

-   [Role Definition](#Role_Definition)
-   [Role Handling](#Role_Handling)
-   [Role Naming](#Role_Naming)
-   [Supported OS](#Supported_OS)

## Role Definition

Roles are self-contained portable units of [Ansible](https://docs.ansible.com/)
automation. They should be reusable and provide a full lifecycle of a service.
They should default to common standards and policies.

## Role Handling

This chapter defines the Role Handling. You can find some ideas and concepts,
that ensure Handling consistency for the User of a role.

### Convention over Configuration

A good role forces the user to enter critical data and avoids to ask for
defaults.

For example: A web server should run on port 80 per default and the
user should not need to configure this behavior. Instead, when a database
password should be chosen wisely, the user must be forced to enter one.

The user should only define unconventional and mandatory aspects of the role in
most cases.

### Install, Remove, Update

Roles are needed to install or configure a software. To ensure a high quality
user experience, you should also consider, that roles can do updates or
removals.

Some example variables are prepared in the
[role skeleton](../role/defaults/main.yml.j2')

### Separate provisioning, configuration, application

A role, that install something is cool. The role should also take care of
"Best Practices", like security related configuration. As an example, you can
think of a role "srv_postgresql":

**Good**

-  install postgresql
-  initialize postgresql
-  tune postgresql
-  open firewall ports for postgresql
-  basic SELinux tuning

**Bad**

-  creating new users in postgresql
-  creating new databases
-  filling in content in the database

This should ensure, that roles can be used again and again.

### Privileges

A role should know, when privileges are needed. Therefore, you should always
test and add "become" to the tasks, when needed. Running playbooks fully in
"become: true" should be avoided.

The molecule test provided in the
[role skeleton](../role/molecule/default/molecule.yml) is already prepared for
testing this behavior.

You can also find some example code in the
[role skeleton](../role/tasks/main.yml.j2).

### Dependencies

You should avoid to enforce dependencies via meta/main.yml. The user should be
put in the situation, that he can choose, if he wants to configure something
manually or do other preparations.

Nevertheless, you should always show possible dependencies and maintain the
`requirements.yml` and `README.md`. If this is needed, always try to use
specific versions.

If you think a requirement must be met, please don't use the dependencies, but
fail the role. If a requirement is not met, the role is allowed to break.

An example is given in the [role skeleton](../role/tasks/main.yml.j2).

### Firewalld

All roles should be aware, that a firewall may run on the host. Opening ports,
if firewalld is used should be part of the role, but configurable from users.

You will find an example in the [role skeleton](../role).

### SELinux

Setting a proper SELinux context for files, directories, boolean, etc. should
be part of the role, if SELinux is installed and used on a host.

You can find some example code in the [role skeleton](../role).

## Role Naming

Naming Conventions should ensure, that we are using consistent terms for certain
topics. The user will benefit, because he will get used to naming conventions
and developer will benefit even more.

## Roles

Naming a role is straight forward. Nevertheless, since we are having different
namespaces for github, galaxy, etc. this may look a bit confusing.

- Github => `$github-prefix-$role_name`
- Galaxy => `$galaxy-prefix.$role_name`

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

### Tasks, blocks, handlers

You should name all of your tasks and blocks properly. Avoid variables in the
name. If a task can be tuned to "Install, Remove, Update" a package, you
can name it "Manage Package" or similar.

Some examples are prepared in the [role skeleton](../role/tasks/main.yml.j2).

### Variables

Most users will start using roles from different providers and contributors.
To avoid scenarios where the user does not know why "myRoleXXX: foo" breaks
the playbook, you should always prefix your variables properly.

Good practice is, to have a namespace and $role_name in the variables.

**Good**
```
wtd_srv_mariadb_package: "mariadb-server"
wtd_srv_nginx_conf:
  port: 8080
  directory: /var/www/myApp
```
**Bad**
```
package: "mariadb-server"
port: 8080
```

Some example variables are prepared in the
[role skeleton](../role/defaults/main.yml.j2')

## Supported OS

In most cases, you want to have the following OS supported and tested. These
are already prepared in the `meta/main.yml` and `.travis.yml`.

-   Fedora
-   CentOS
-   RedHat

Optionally, you should think about the following OS.

-   OracleLinux
-   Debian
-   Ubuntu LTS

Other OS can be included, but without priority.
