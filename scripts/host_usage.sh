#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo "Usage: host_info.sh psql_host psql_port db_name psql_user 
psql_password"
    exit;
fi

PGPASSWORD="$5"

function get_host_info {
    hostname=$(hostname -f)
    host_id=$(cat /home/centos/dev/jrvs/bootcamp/host_agent/scripts/host_id.txt)
    if [ -z "$host_id" ]; then
	id_stmnt="SELECT id from host_info WHERE hostname = '${hostname}'"
	host_id=$(psql -h "$1" -p "$2" -U "$4" -d "$3" -t -c "$id_stmnt")
    fi
}

function get_usage_data {
    vmstats=$(vmstat -t --unit M)
    iostats=$(vmstat -d)
    diskstats=$(df -BM)

    timestamp=$( echo "$vmstats" | tail -1 | awk '{print $18 " " $19}')
    memory_free=$( echo "$vmstats" | tail -1 | awk '{print $4}' )
    cpu_idle=$( echo "$vmstats" | tail -1 | awk '{print $15}' )
    cpu_kernel=$( echo "$vmstats" | tail -1 | awk '{print $14}' )
    disk_io=$( echo "$iostats" | tail -1 | awk '{print $2 + $6}' )
    disk_available=$( echo "$diskstats" | head -2 | tail -1 | awk '{print $4}' )
    
}

get_host_info
get_usage_data

insert_string="INSERT INTO host_usage(\"timestamp\", host_id, memory_free, cpu_idle,
cpu_kernel, disk_io, disk_available) VALUES('${timestamp}', '${host_id}', '${memory_free}', 
'${cpu_idle}', '${cpu_kernel}', '${disk_io}', '${disk_available::-1}')"

psql -h "$1" -p "$2" -U "$4" -d "$3" -c "$insert_string"
