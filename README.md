# cloud-1 - 42 project
## :open_file_folder: Project Overview
Introductory project to Ansible  
An extension on another 42 project - Inception  
Automation of the deployment of a website on a server via Ansible
## :triangular_ruler: Prerequisites
### Cloud Server
A server machine where the application files will be stored and where docker will be launched.  
In this project, we are using a server provided by a partnership between 42 and Scaleway.
Openssh must be installed on the server(s) (and the host) to be able to create a connection between them
### Domain Name (Optional)
A memorable domain name would be appreciated, but in this project, we are using the IP of the server machine.
## :pushpin: Learning Objectives
### Ansible
- Inventory
- Modules
- Playbook syntax
- Roles
- SSH key checks
### Docker
- Dockerfiles
- Images, containers
- Docker-Compose
- Volumes, networks
## :card_index_dividers: Contents
### cloud-1.sh
- Installation of Ansible
- Creation of inventory
- Tailored .env files
### Ansible
All roles are self-written. They divide the tasks into blocks of clear functionalities.
#### `inventory.ini`
Simple structure containing Ansible target hosts
#### `playbook.yml`
Main tasks are split into roles
#### `roles/`
- Setup: Handle SSH key checks and delay gathering of facts
- Environment: Install required dependencies
- Docker: Install and launch dockers
- Application: Directory preparations, certificate creations, and application deployment
- Checks: Simple checks to ensure site is properly deployed
### Docker Services
All images used are built by self-written Dockerfiles to fully understand what goes on under the hood when the containers are built.
#### `roles/application/files/`
- MariaDB: Installation, initialisation of tables, xatabase Configurations
- WordPress: Installation, utilisation of WP CLI, configuration for both Wordpress & php
- phpMyAdmin: Installation, server Configurations
- NGINX: Installation, serving from multiple containers, TSL Certificates
- docker-compose.yml: Container dependencies, healthchecks, volumes, networks, secrets, etc.
## :building_construction: Deployment
```
# Single server deployment
./cloud-1.sh <server IP>

# Multiple server deployment
./cloud-1.sh <server1 IP> <server2 IP> ...
```
## :mag: Resources
### Ansible
#### Documentation
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html  
#### Tutorials
SSH: https://youtu.be/-Q4T9wLsvOQ?si=jPiGsBPAb8cHZiIU  
Playbooks: https://youtu.be/VANub3AhZpI?si=3oHGU1g1kQ_pJzYL  
Roles: https://youtu.be/tq9sCeQNVYc?si=TQS3q3pfihO37Pji  