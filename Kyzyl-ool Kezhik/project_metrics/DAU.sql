# DAU

WITH RECURSIVE cte AS
(
    SELECT MAX(CAST(end AS DATE) - INTERVAL 1 YEAR ) AS dt FROM sessions
        UNION ALL
	  SELECT dt + INTERVAL 1 DAY
        FROM cte
        WHERE dt + INTERVAL 1 DAY <= (SELECT MAX(CAST(end AS DATE)) FROM sessions)
)
SELECT cte.dt as "Day", COUNT(DISTINCT sessions.id) as 'DAU'
    FROM sessions RIGHT JOIN cte ON CAST(sessions.end AS DATE) = cte.dt
    GROUP BY cte.dt
    order by 1
    limit 500;
