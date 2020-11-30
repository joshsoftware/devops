# Ansible Playbooks
This repo contains multiple ansible roles. See the description below
- ansible-ruby : To install ruby from source code
- ansible-ngin-passenger : To install nginx with passenger module & setup startup script
- ansible-ror-deploy : To deploy ROR app with basic conf file
- ansible-redis : Setup redis standalone, can be setup master slave replication with sentinal top manage failover
- ansible-mongo : Setup mongDB server standalone, manage relicaset

### Ansible installation
* For MacOSX : http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip
* For Ubuntu : http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-apt-ubuntu

### Latest Ansible installation using pip3 with python3
* For Ubuntu https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html

Note : Install python3 & pip3 if not present before upgrading ansible using pip3. 

## Below are the steps to setup different services & configuration.

* Clone Repo
```sh
git clone https://github.com/joshsoftware/devops.git
```
you will see, all roles has benn cloned in "roles" folder

### To install ruby with  nginx passenger
*   Create hosts inventory file : hosts
```sh
[web]
<server ip> ansible_ssh_user=<ssh loginuser> ansible_ssh_privat_key_file="<private key file or .pem file path>"
```
Note: You can use host.example file as a template

* Create sites.yml
```yaml
---
################################################################
#Do not remove below host block, this is to check python binary#
################################################################
- hosts: all
  gather_facts: False
  tasks:
   - name: install python 3 
     raw: test -e /usr/bin/python3 || (apt -y update && apt install -y python3-minimal)

################################################################
#Do not remove below host block, this is to gather server facts#
################################################################
- hosts: all
  tasks:
  - name: Fake task to get facts
    service: name={{ item }} state=present
    with_items:
    - []

# Use below host block & uncomment ansible roles which you wants to run on target host group
- name: setup nagios client
  hosts: appserver
  roles:
#    - "ansible-rvm-ruby"                # Delete this line if you are not installing ruby using RVM, for variables refer vars.yml
#    - "ansible-monit"
#    - "ansible-nginx-passenger"         # Configure nginx with passenger, for variables refer vars.yml
#    - "ansible-redis"                   # Configure redis stand alone, for variables refer vars.yml
#    - "ansible-mongo"                   # Configure mongo standalone, for variables refer vars.yml
#    - "ansible-postgresql"              # Setup postgres, for variables refer vars.yml
#    - "ansible-nagios-client"           # Configure nagios client, for variables refer vars.yml

##To add node to Nagios server? just enable beow block as it is but dont forget to add nagios_server,nagios_client in hosts file as mentioned in example file.
#- name: setup nagios 
#  hosts: nagios_server,nagios_client
#  roles:
#   - ansible-nagios-client

#Note: To setup a component on separate server? create new host block & add role in it like below example
#Install elasticsearch on single/separate server

#- name: setup elasticsearch server node
#  hosts: appserver
#  roles:
#  - "ansible-elasticsearch"           # Adding elasticsearch role for standalone standalone, for variables refer vars.yml                                               
```

Note: You can use sites.yml.example file & uncomment required roles for installation

* Create vars file to pass custom parameters values : vars.yml
```yaml
#Nginx + passenger parameters
nginx_version: "1.6.2"
nginx_extra_configure_flags: '--with-stream'
#nginx_passenger: true                           #uncomment only when you use nginx with passenger or just keep it commented or deleted
#nginx_unicorn: true                             #uncomment only when you use nginx with unicorn or just keep it commented or deleted
#Passenger version
passenger_version: "4.0.53"

#ruby compatible rack version
rack_version: '1.6.4'


#source code or rvm installation decision happens on below parameters
ruby_install_from_source: false        #Set true if wants to setup using source
ruby_install_using_rvm: true            #Set true if wants to setup using rvm

#Ruby version parameters
ruby_version:           "2.1.2"

#rvm setup parameters
rvm1_user: 'root'
rvm1_install_flags: '--auto-dotfiles'
rvm1_install_path: '/usr/local/rvm'

#rvm gemset name
rvm1_gemset: 'dealsignal'

extra_packages: ['vim']

#vhost & sidekiq configuration parameters

app_domain_name: 'abc.example.com'
rails_env: 'development'
deploy_to: '/var/www/dealsignal'              #this will be the document root for 'app_domain_name' virtual host with suffix 'current/public' for ROR
ssh_private_key_file_path: '/tmp/id_rsa'

#sidekiq config parameters
sidekiq_enable: true
sidekiq_queue: 'default'
sidekiq_threads: 5

#change below param to true if you want to reconfigure nginx
nginx_reconfigure: false
```

Note: You can use vars.yml.example file & uncomment & set value for required vars

* Run playbook
```sh
ansible-playbook -i hosts sites.yml --extra-vars "@./vars.yml" -b -vv

#to reconfigure nginx add tag to playbook command
ansible-playbook -i hosts sites.yml --extra-vars "@./vars.yml" -b -vv --tags 'nginx_reconfigure'
```

### For redis installation
* Add an host group entry for redis server
```sh
[redis_master]
<server ip> ansible_ssh_user=<ssh loginuser> ansible_ssh_privat_key_file="<private key file or .pem file path>"
```
* Add redis role to sites.yml host block
```yaml
- name: setup redis server
  hosts: redis_master
  roles:
    - "ansible-redis"            #Install redis service standalone(Use ubuntu 16.04)
```
* To install specific version of redis? add below variable to vars.yml
```yaml
redis_version: <version>          # like '2.8.9' or '3.0.9'
```
* Run playbook
```sh
ansible-playbook -i hosts sites.yml --extra-vars "@./vars.yml" -b -vv
```

### To setup mongo setup
```sh
[mongo_master]
<server ip> ansible_ssh_user=<ssh loginuser> ansible_ssh_privat_key_file="<private key file or .pem file path>"
```
* Add Mongo role to sites.yml host block
 ```yaml
- name: setup mongo server
  hosts: mongo_master
  roles:
    - "ansible-mongo"           #Install mongo 4.4
```
Note : To specify mongodb version, add below parameter by keeping any needed version.
```yaml
mongodb_version: '<MongoDB Version>'
``` 
Note : To change mongodb datadir? add below parameter to vars.yml file
```yaml
mongodb_storage_dbpath: '<path on the server>'
```
*  Run playbook
```sh
ansible-playbook -i hosts sites.yml -b --extra-vars "@./vars.yml" -vv
```
#### Final sites.yml will script install Ruby, Nginx + Passenger, Redis, Mongo

#### For elastic search playbook, refer sites.yml, vars.yml, hosts example files
.
