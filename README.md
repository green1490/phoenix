# Project 

In this project im trying to learn pulumi and ansible by building an infrastructure.

The infrastructure has 3 machines:

- A webserver
- A database server
- A firewall/router

### Webserver

Runs Nginx and has access to the DB server

subnet: 192.168.100.0/24

### Database

Runs a postgres server with initailized data

subnet: 192.168.200.0/24

### Firewall/Router

Runs pfsense. Acts as a DMZ. Manages the request between the webserver and the database. Has two interface. One is managing the internal network the other is for accessing the internet.

subnet: 192.168.50.0/24