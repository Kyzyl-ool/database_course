select t1.dt as "Date", truncate(DPU/DAU, 5) as "PPU"
from (
       WITH RECURSIVE cte AS
         (
         SELECT MAX(CAST(begin AS DATE) - INTERVAL 1 YEAR) AS dt
         FROM sessions
         UNION ALL
         SELECT dt + INTERVAL 1 DAY
         FROM cte
         WHERE dt + INTERVAL 1 DAY <= (SELECT MAX(CAST(begin AS DATE)) FROM sessions)
         )
         SELECT cte.dt, COUNT(DISTINCT sessions.id) as "DAU"
         FROM sessions
                RIGHT JOIN cte ON CAST(sessions.begin AS DATE) = cte.dt
         GROUP BY cte.dt
         ORDER BY 1
     ) as t1 left join (

WITH RECURSIVE cte AS
(
    SELECT MAX(CAST(begin AS DATE) - INTERVAL 1 YEAR) AS dt FROM sessions
        UNION ALL
	SELECT dt + INTERVAL 1 DAY
      FROM cte
     WHERE dt + INTERVAL 1 DAY <= (SELECT MAX(CAST(begin AS DATE)) FROM sessions)
)
select cte.dt, count(distinct id) as "DPU"
from payment left join cte on cast(payment.dttm as date) = cte.dt
group by cte.dt
order by 1
  ) as t2 on t1.dt = t2.dt


