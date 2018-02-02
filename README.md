# Ansible Galaxy Skeleton
| The while-true-do skeleton to create new ansible-roles. 

-  Including a script to update meta files
-  Can be used with `ansible-galaxy` command
-  Includes some testing-scripts

## Motivation

Creating a repository is always somewhat interesting and needs a lot explanation. This repository should help to reduce the effort and prepare a ready-to-use environment.

With the installation of [Ansible](https://www.ansible.com/) you will get a very useful command `ansible-galaxy`. This command is capable of creating a directory with a lot of cool stuff in it. 

The [ansible-galaxy-skeleton](https://github.com/while-true-do/ansible-galaxy-skeleton/) will extend this behaviour by providing a custom skeleton for [while-true-do.org](https://while-true-do.org).

## Requirements

You need the following tools on your system:

- ansible
- ansible-lint
- ansible-review
- aspell
- aspell-en
- bash

## Dependencies

The `update-meta-files.sh` depends on the reachability of other repositories.

-   <https://github.com/while-true-do/community>
-   <https://github.com/while-true-do/ansible-galaxy-skeleton>

## Layout / Structure

The directory / file layout will be:

```
README.md                 # Tune it to your needs
LICENSE.md                # This file contains the license

.editorconfig             # You should consider to use a plugin for editorconfig
.gitignore                # Both files can be updated via update-meta-files.sh

.travis.yml               # This file is used from travis-ci for automated testing.

update-meta-files.sh      # The script to update meta files and docs and tests

docs/
  doc01                   # Here you can find documents like our CONTRIBUTING.md
  doc02                   # The documents are maintained in
  doc03                   # https://github.com/while-true-do/community
  doc04                   # and can be updated via update-meta-files.sh

defaults/
  main.yml                # Containing some useful comments
files/
  file01                  # Maybe some files are used in the "tasks"
handlers/
  main.yml                # Everything which will be triggered via "notify".
meta/
  main.yml                # A meta file, which is used in ansible galaxy.
tasks/
  main.yml                # Here you will find the tasks, which are in the role.
templates/
  foo.j2                  # Often Templates are needed for config files.
tests/
  test01                  # Tests can be found here.
vars/
  main.yml                # Even more vars can be specified here. These will overwrite defaults
```

## Installation

Install from [Github](https://github.com/while-true-do/ansible-galaxy-skeleton/)

```
git clone https://github.com/while-true-do/ansible-galaxy-skeleton.git

```

BUG: Due to a bug in ansible-galaxy (please see below) you have to do the following after cloning/pulling:

```
rm -rf README.md
```

## Update

Updating the skeleton itself is as easy as

```
cd ansible-galaxy-skeleton
git fetch
git pull
```

This should be done from time to time.

## Usage

Here you will see how this whole thingy should be used.

### Using the skeleton

There are multiple ways described [here](http://docs.ansible.com/ansible/latest/galaxy.html#using-a-custom-role-skeleton).

```
# Edit global ansible.cfg
sudo vi /etc/ansible/ansible.cfg
# Edit local ansible
vi ~/.ansible.cfg
# Edit the current directory
vi ansible.cfg (in the current directory)
```

You have to add/edit the content.

```
[...]

[galaxy]
role_skeleton = /path/to/skeleton
role_skeleton_ignore = ^.git$,^.git_keep$,^README.md$

[...]
```

Alternatively you can use it directly. But ignoring of unwanted files does not work.

```
ansible-galaxy init --role-skeleton=/path/to/ansible-galaxy-skeleton <role-name>
```

### Bug included

Unfortunately there seems to be a bug in ansible-galaxy. It causes, that some files are not properly ignored/overwritten. As a workaround you have to do the following after updating the skeleton via `git pull` or `git clone`:

- https://github.com/ansible/galaxy/issues/316
- https://github.com/ansible/galaxy/issues/315

```
# Remove the original README.md (basically the file you are reading)
rm -rf README.md
```

After each `ansible-galaxy init <role-name>`, you have to cleanup/reinitialize the new directory:

```
rm -rf .git
git init
```

### Using the script

There is a script included, which should be used to keep meta-files up-to-date.

```
# Getting help
bash ./update-meta-files.sh -h

# Update the update script
bash ./update-meta-files.sh -s

# Update all meta files.
bash ./update-meta-files.sh -a
```

### Using the tests

All tests are located in [test directory](./tests/).

Basic testing:

```
bash ./tests/test-spelling.sh
bash ./tests/test-ansible.sh
```

You should also consider to use `ansible-review` from time to time.

## Contribute / Bugs

Thank you so much for considering to contribute. Every contribution helps us.
We are really happy, when somebody is joining the hard work. Please have a look 
at the links first.

-   [Contribution Guidelines](./docs/CONTRIBUTING.md)
-   [Create an issue or Request](https://github.com/while-true-do/ansible-galaxy-skeleton/issues)
-   [See who was contributing already](https://github.com/while-true-do/ansible-galaxy-skeleton/graphs/contributors)

## License

This work is licensed under a [BSD License](https://opensource.org/licenses/BSD-3-Clause).

## Author Information

Blog: [blog.while-true-do.org](https://blog.while-true-do.org)

Mail: [hello@while-true-do.org](mailto:hello@while-true-do.org)
