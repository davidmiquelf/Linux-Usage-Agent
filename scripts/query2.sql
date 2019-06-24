CREATE OR REPLACE FUNCTION round_minutes(TIMESTAMP WITHOUT TIME ZONE, integer) 
RETURNS TIMESTAMP WITHOUT TIME ZONE AS $$ 
  SELECT 
     date_trunc('hour', $1) 
     +  cast(($2::varchar||' min') as interval) 
     * round( 
     (date_part('minute',$1)::float + date_part('second',$1)/ 60.)::float 
     / $2::float
      )
$$ LANGUAGE SQL IMMUTABLE;

SELECT prcnt, "interval"
FROM (
     SELECT AVG(((total_mem/1000.0) - memory_free)*100 / (total_mem/1000)) as "prcnt",
     round_minutes(u.timestamp, 5) as "interval"
     FROM host_info i inner join host_usage u ON i.id = u.host_id
     GROUP BY u.timestamp
     WINDOW w AS (PARTITION BY round_minutes(u.timestamp, 5))
     
     ) as sub1
GROUP BY "interval", prcnt
ORDER BY "interval", prcnt
;
