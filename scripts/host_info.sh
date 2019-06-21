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
total_mem=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2 $3}')
}

function timestamp {
    date +"%Y-%m-%d %T"
}

get_hostname
get_cpu_info
echo $hostname
echo $cpu_number
echo $cpu_architecture
echo $cpu_model
echo $cpu_mhz
echo ${l2_cache::-1}
echo ${total_mem::-2}
ts=$(timestamp)

id_stmnt="SELECT id from host_info WHERE hostname = '${hostname}'"

id=$(psql -h localhost -U postgres -d host_agent -t -c "$id_stmnt")

echo $id >./host_id.txt

insert_stmnt="INSERT INTO host_info (id, hostname, cpu_number,
cpu_architecture, cpu_model, cpu_mhz, l2_cache, \"timestamp\", total_mem)
VALUES(${id}, '${hostname}', '${cpu_number}', '${cpu_architecture}', 
'${cpu_model}', '${cpu_mhz}', '${l2_cache::-1}', '${ts}', '${total_mem::-2}');"

psql -h localhost -U postgres -d host_agent -c "$insert_stmnt" 2>/dev/null
