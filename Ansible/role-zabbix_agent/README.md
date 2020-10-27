role-zabbix-agent
=========
Latest version: '1.0.0-0'
---------

A brief description of the role goes here.

Requirements
------------

Docker
Python 2.7+

Role Variables
--------------

port - to specify port

zabbix_server - to cpecify zabbix server host

Example Playbook
----------------
---
1) Create playbook file with name: "test.yml"
---
```
---
- hosts: localhost
  connection: local
  roles:
    - role-zabbix_agent
```
2) Create requirements file "requirements.yml"
```
- src: 'ssh://git@gitlab.infra.computerstein.net:40022/deployment/role-zabbix_agent.git'
  scm: 'git'
  version: '1.0.0-0'
  name: 'role-zabbix_agent'
```
3) Install the role
```
ansible-galaxy install --force --roles-path ./roles -r requirements.yml
```

4. Run the playbook:

   * When you use balancer :
   ```
   ansible-playbook -i roles/role-zabbix_agent/tests/inventory test.yml
   ```
   * When you want set port and zabbix-server-name variables (replace "variable" with your variables) :
   ```
   ansible-playbook -i roles/role-zabbix_agent/tests/inventory test.yml -e "port=variable zabbix_server=variable"
   ```
License
-------

BSD

Author Information
------------------

author: Stas Polovnoy
description: role for raising up zabbix-agent in docker
company: Computerstein & Co
