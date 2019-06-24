## Introduction
Linux Usage Agent is an internal tool that monitors the resources of hosts within a cluster. It could help the infrastructure team to better monitor, analyze, and allocate resources for each host. 
## Architecture and Design
A PostgreSQL database that contains the basic info and usage data of each host will be served from one of the hosts.
The hosts themselves have a bash script that is run periodically through crontab. The script gathers usage data to send to the
database.
![Architecture Diagram](https://github.com/davidmiquelf/Linux-Usage-Agent/blob/master/Usage-Agent-Diagram.png)

## Usage
### Database Setup
Run Postgresql through docker and use the init file to set up the tables.
Use `psql -h Localhost -U postgres` to access the database locally.

```
CREATE DATABASE host_agent;

\c host_agent

\i init.sql
```
### `host_info.sh`
This script gathers static information of the host to populate the host_info table.
It should be run once when setting up a new host.
## Improvements

