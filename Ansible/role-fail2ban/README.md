role-fail2ban
=========
Latest version: '1.0.0-0'
---------

### Role for set up fail2ban with ssh protection on Debian and RedHat based systems:
 - install fail2ban
 - enable fail2ban service startup
 - add jail for ssh protection

Requirements
------------

 - Python2/3 installed on the destination host.
 - Ansible 2.0+ for executing

Role Variables
--------------
 - ssh_port: SSH port which used in the remote machine. Default value 22.

Usage:
----------------

**1. Create the inventory file with the name: "inventory" and replace variables: "remote_machine_ip", "remote_user", "ssh_port", "private_key"**

```
fail2ban:
  hosts:
     some_host:
        ansible_host: remote_machine_ip
        ansible_port: ssh_port
        ansible_user: remote_user
        ansible_ssh_private_key_file: private_key
```

**2. Create playbook file with the name: "fail2ban.yml" and uncomment needed sections**
```
---
- hosts: fail2ban
  roles:
    - fail2ban
  vars:
      ssh_port: 22
  ### Uncomment the line below for Ubuntu:
  #    ansible_python_interpreter: /usr/bin/python3
```

**3. Create requirements file "requirements.yml"**
```
- src: 'ssh://git@gitlab.infra.computerstein.net:40022/deployment/role-fail2ban.git'
  scm: 'git'
  version: '1.0.0-0'
  name: 'fail2ban'
```
**4. Install the role**
```
ansible-galaxy install --force --roles-path ./roles -r requirements.yml
```
**5. Run the playbook:**
```
ansible-playbook -i inventory fail2ban.yml
```
License
-------

BSD

Author Information
------------------


*author: Stas Polovnoy*

*description: role for set up fail2ban on Debian and RedHat*

*company: Computerstein & Co*
