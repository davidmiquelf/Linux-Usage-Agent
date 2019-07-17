## Introduction
Linux Usage Agent is an internal tool that monitors the resources of hosts within a cluster. It could help the infrastructure team to better monitor, analyze, and allocate resources for each host. 
## Architecture and Design
A PostgreSQL database that contains the basic info and usage data of each host will be served from one of the hosts.
The hosts themselves have a bash script that is run periodically through crontab. The script gathers usage data to send to the
database.
![Architecture Diagram](https://github.com/davidmiquelf/Linux-Usage-Agent/blob/master/Usage-Agent-Diagram.png)
- The host_info table holds relatively static data such as total memory, cpu model, and hostname.
- The host_usage table holds frequently changing data such as memory usage, disk io, cpu idle time, etc...
- The script `host_info.sh` gathers static information of the host to populate the host_info table.
It should be run once when setting up a new host.
- The script  `host_usage.sh` gathers usage information of the host to populate the host_usage table. It should be run once per minute using crontab.

## Usage
- Run Postgresql through docker and use the init file to set up the tables, use any viable host, port, username, and password.
- Use `psql -h [host] -U [username]` to access the database locally.

```
CREATE DATABASE host_agent;

\c host_agent

\i init.sql
```
- Run `host_info.sh [host] host_agent [user] [password]` to add an entry in the host_info table for this host.
- Run `crontab -e` to open a VI of the crontab file.
- Write `* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh [host] [port] host_agent [username] [password] > /tmp/host_usage.log` to the file, then save and quit.
## Improvements
1. The initialization process could be fully automated: Program installs, running host_info.sh, updating the crontab, and creating the database can all be done in a single bash script.
2. Periodically run host_info.sh to check for hardware changes.
3. Add bash scripts the will execute sql queries and present the data in a meaningful way.
