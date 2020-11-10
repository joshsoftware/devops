###Ansible role to setup Nagios client
Configure nagios client on server & add node to nagios server for monitoring

## Steps to setup nagios Client setup.

* Add [client:children] in existing hosts file And add existing hostgroup as a host member to it like below example
```sh
[web]                    #this is existing hostgroup in the hosts file
<server ip> ansible_ssh_user=ubuntu 

[nagios_client:children]     #Host group for nagios client
web

[nagios_server]     #Host group for nagios client
<nagios server ip> ansible_ssh_user=<ssh loginuser> ansible_ssh_privat_key_file="<private key file or .pem file path>"
```

### 

* Add nagios client role in new host block to sites.yml
```yaml

- name: setup ror server
  hosts: nagios_client,nagios_server
  roles:
    - "ansible-nagios-client"
```

* Add Nagios client role parameters values to vars.yml
```yaml
#Nagios lient setup parameters
nagios_client: true
nagios_server_ip: <nagios server ip>
nagios_add_node: false
nagios_hostgroup: '<project name can be use>'

##specify below details for redis plugin to monitor redis server
nagios_redis: true          #To enable plugin set this attr to true, if not required then keep it commented
redis:
  host: 'localhost'
  user: ''         #redis login user
  password: ''     #redis login password for above user

##Specify postgres login details for postgres check plugin to monitor postgres
nagios_postgres: false       #To enable plugin set this attr to true, if not required then keep it commented
postgresql:
  host: "DB-hostname"
  username: 'username'
  password: 'password'
  database: "database_to_monitor"

##Specify postgres login details for mongodb check plugin to monitor mongodb
nagios_mongodb: true       #To enable plugin? set this attr to true, if not required then keep it commented
mongodb:
  host: "localhost"
  username: 'username'
  password: 'password'
  database: 'db name'
```

* Run playbook
```sh
ansible-playbook -i hosts sites.yml --extra-vars "@./vars.yml" --sudo -vv
```

### To Add node to Nagios server after installing node? just set below parameter to "true" in vars.yml
* In the vars.yml search below paramter & set to true
```yaml
nagios_add_node: true
```

Now run the playbook
```sh
ansible-playbook -i hosts sites.yml --extra-vars "@./vars.yml" --sudo -vv
``` 
