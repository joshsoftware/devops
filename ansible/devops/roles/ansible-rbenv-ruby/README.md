Rbenv ansible role
=========
[![Build Status](https://travis-ci.org/spitfast/ansible-role-rbenv.svg?branch=master)](https://travis-ci.org/spitfast/ansible-role-rbenv)

An ansible role that installs [rbenv](https://github.com/rbenv/rbenv) and rbenv [ruby-build](https://github.com/rbenv/ruby-build) plugin for specified user.

Requirements
------------

Ansible version **2.0.1**

Role Variables
--------------
List of default variables. You can override variables in your playbook.
```yaml
---
rbenv_version: v1.0.0
rbenv_repo_path: https://github.com/rbenv/rbenv.git
rbenv_ruby_build_repo_path: https://github.com/sstephenson/ruby-build.git
rbenv_user: vagrant
rbenv_root_path: "/home/{{ rbenv_user }}/.rbenv"
rbenv_ruby_version: 2.3.0
rbenv_gems:
  - bundler
```

Dependencies
------------

None.

Example Playbook
----------------
```yaml
---
- hosts: localhost
  roles:
	- spitfast.rbenv
```

Usage
----
Create your playbook (described in the section above) and run one of the following commands:

`$ ansible-playbook playbook.yml` - to run all tasks in role

`$ ansible-playbook playbook.yml --tags=gems` - to run only gems installation task

`$ ansible-playbook playbook.yml --skip-tags=gems` - to run only rbenv installation task (without gems)

License
-------

MIT

Author Information
------------------

[Gordon Shumway](https://github.com/spitfast/)
