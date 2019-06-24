SELECT
	cpu_number, id, total_mem
FROM
	host_info
	WINDOW w as (PARTITION BY cpu_number ORDER BY total_mem DESC);
