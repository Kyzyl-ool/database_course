# REVENUE

WITH RECURSIVE cte AS
(
    SELECT MAX(CAST(begin AS DATE) - INTERVAL 1 YEAR ) AS dt FROM sessions
        UNION ALL
	  SELECT dt + INTERVAL 1 DAY
        FROM cte
        WHERE dt + INTERVAL 1 DAY <= (SELECT MAX(CAST(begin AS DATE)) FROM sessions)
)
select dt, sum(payment.sum)
from cte left join payment on cast(payment.dttm as date) = cte.dt
group by dt
order by 1