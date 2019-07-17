#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    echo "Usage: host_info.sh psql_host psql_port db_name psql_user \
psql_password"
    exit;
fi

HOST="$1"
PORT="$2"
DATABASE="$3"
PSQLUSER="$4"
PGPASSWORD="$5"

function get_hostname {
hostname=$(hostname -f)
}

function get_cpu_info {
specs=$( lscpu )
cpu_number=$( echo "$specs" | egrep '^CPU\(s\):' | awk '{print $2}')
cpu_architecture=$(echo "$specs" | grep "Architecture:" | awk '{print $2}')
cpu_model=$(echo "$specs" | egrep "^Model name:" | 
    awk '{for (i=3; i<=NF; i++) print $i}')
cpu_mhz=$(echo "$specs" | grep "CPU MHz:" | awk '{print $3}')
l2_cache=$(echo "$specs" | grep "L2 cache:" | awk '{print $3}')
total_mem=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}')
}

function timestamp {
    date +"%Y-%m-%d %T"
}

get_hostname
get_cpu_info
ts=$(timestamp)



insert_stmnt="INSERT INTO host_info (hostname, cpu_number,
cpu_architecture, cpu_model, cpu_mhz, l2_cache, \"timestamp\", total_mem)
VALUES('${hostname}', '${cpu_number}', '${cpu_architecture}', 
'${cpu_model}', '${cpu_mhz}', '${l2_cache::-1}', '${ts}', '${total_mem}');"

psql -h "$HOST" -p "$PORT" -U "$PSQLUSER" -d "$DATABASE" -c "$insert_stmnt" 2>/dev/null

id_stmnt="SELECT id from host_info WHERE hostname = '${hostname}'"

id=$(psql -h "$HOST" -p "$PORT" -U "$PSQLUSER" -d "$DATABASE" -t -c "$id_stmnt")

echo $id >./host_id.txt
