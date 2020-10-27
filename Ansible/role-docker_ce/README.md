role-docker_ce
=========
Latest version: '1.0.0-18'
---------

### Role for set up docker-ce on Debian and RedHat based systems:
 - install docker-ce
 - enable docker service startup
 - open tcp socket on 0.0.0.0:2376 if required
 - add users to the docker group

Requirements
------------

 - Python2/3 installed on the destination host.
 - Ansible 2.5+ for executing

Role Variables
--------------
 - docker_repository: The repository from which you install docker
 - docker_users: User who will be added in docker group to use docker commands without sudo. By default remote user will be added.
 - docker_group: Group in which users are added
 - docker_compose_version: Version of docker-compose what will be installed
 - open_socket: Default meaning is false. Change to true for enabling tcp://0.0.0.0:2376 docker socket for remote connection

 Install Ansible
  ------------
For Debian and Ubuntu:
 - sudo apt update && sudo apt install -y python3-pip && pip3 install ansible

For RedHat and Centos:
 - sudo yum -y update && sudo yum install -y epel-release && sudo yum install -y ansible

For MAC:
- brew install ansible

 Install local dependencies
  ------------
 For Debian and Ubuntu:
  - sudo apt update && sudo apt install -y sshpass

 For RedHat and Centos:
  - sudo yum install -y install sshpass

  For MAC:
  - brew install sshpass

Usage:
----------------

**1. Create the inventory file with the name: "inventory" and replace variables: "remote_machine_ip", "remote_user", "ssh_port", "remote_password"**

```
docker:
  hosts:
     some_host:
        ansible_host: remote_machine_ip
        ansible_port: ssh_port
        ansible_user: remote_user
        ansible_password: remote_password
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no'

```

**2. Create playbook file with the name: "docker_ce.yml" and uncomment needed sections**
```
---
- hosts: docker
  roles:
    - docker_ce
  vars:
    open_socket: false
  ### Uncomment the line below and add configuration for adding apt proxy:
  #  http_proxy: "http_proxy="
  #  https_proxy: "https_proxy="
  #  ftp_proxy: "ftp_proxy="

  ### Uncomment the line below for Ubuntu:
  #  ansible_python_interpreter: /usr/bin/python3

  #  docker_users:
  #    - "{{ ansible_facts.env.USER }}"

  #  docker_group: docker

  #  docker_compose_version: "1.23.2"
```

**3. Create requirements file "requirements.yml"**
```
- src: 'ssh://git@gitlab.infra.computerstein.net:40022/deployment/role-docker_ce.git'
  scm: 'git'
  version: '1.0.0-18'
  name: 'docker_ce'
```
**4. Install the role**
```
ansible-galaxy install --force --roles-path ./roles -r requirements.yml
```
**5. Run the playbook:**
```
ansible-playbook -i inventory docker_ce.yml
```
License
-------

BSD

Author Information
------------------


*author: Stas Polovnoy*

*description: role for set up docker-ce on Debian and RedHat*

*company: Computerstein & Co*
