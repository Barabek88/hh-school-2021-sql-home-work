SELECT a.name,
       avg(compensation_from) AS compensation_from_avg,
       avg(compensation_to)   AS compensation_to_avg,
       avg(nullif(coalesce(compensation_from, 0) + coalesce(compensation_to, 0), 0)) AS compensation_from_to_avg
FROM vacancy v
INNER JOIN area a ON v.area_id = a.area_id
GROUP BY a.name
ORDER BY a.name;



