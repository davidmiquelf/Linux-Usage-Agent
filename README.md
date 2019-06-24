## Introduction
Linux Usage Agent is an internal tool that monitors the resources of hosts within a cluster. It could help the infrastructure team to better monitor, analyze, and allocate resources for each host. 
## Architecture and Design
A PostgreSQL database that contains the basic info and usage data of each host will be served from one of the hosts.
The hosts themselves have a bash script that is run periodically through crontab. The script gathers usage data to send to the
database.
![Architecture Diagram](https://github.com/davidmiquelf/Linux-Usage-Agent/blob/master/Usage-Agent-Diagram.png)
### Database Setup
Run Postgresql through docker and use the init file to set up the tables.
```
cd /home/<username>/dev/jrvs/bootcamp/host_agent/scripts

su <username>

systemctl status docker || systemctl start docker

docker pull postgres

export PGPASSWORD='password'

docker run --rm --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD -d -v 
pgdata:/var/lib/postgresql/data -p 5432:5432 postgres

sudo yum install -y postgresql

psql -h Localhost -U postgres

CREATE DATABASE host_agent;

\c host_agent

\i init.sql
```
## Usage

## Improvements

