
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

Some examples are prepared in the [role skeleton](../role/tasks/main.yml.j2).

### "become: true"

A role should know, when privileges are needed. Therefore, you should always
test and add "become" to the tasks, when needed. Running playbooks fully in
"become: true" should be avoided.

### Role Variables

Most users will start using roles from different providers and contributors.
To avoid scenarios where the user does not know why "myRoleXXX: foo" breaks
the playbook, you should always prefix your variables properly.

Good practice is, to have a namespace and $role_name in the variables.

**Good**
```
wtd_prv_ec2_vm_count: 2
wtd_srv_nginx_conf_port: 8080
```
**Bad**
```
vm_count: 2
port: 8080
```

Some example variables are prepared in the
[role skeleton](../role/defaults/main.yml.j2')

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
are already prepared in the `meta/main.yml` and `.travis.yml`.

-   Fedora
-   CentOS
-   RedHat

Optionally, you should think about the following OS.

-   OracleLinux
-   Debian
-   Ubuntu LTS

Other OS can be included, but without priority.
