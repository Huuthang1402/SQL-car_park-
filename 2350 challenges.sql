WITH Shifts AS (
    SELECT
        start_time,
        finish_time,
        LAG(finish_time) OVER (ORDER BY start_time) AS prev_finish_time
    FROM
        sample
  
)
, Gaps AS (
    SELECT
        start_time,
        finish_time,
        CASE
            WHEN start_time >= prev_finish_time THEN 1
            ELSE 0
        END AS is_contiguous
    FROM
        Shifts
)
, ContiguousGroups AS (
    SELECT
        start_time,
        finish_time,
        SUM(is_contiguous) OVER (ORDER BY start_time) AS group_id
    FROM
        Gaps
)
, CoveredPeriods AS (
    SELECT
        MIN(start_time) AS start_time,
        MAX(finish_time) AS finish_time,
        TIMESTAMPDIFF(SECOND, MIN(start_time), MAX(finish_time)) AS covered_seconds
    FROM
        ContiguousGroups
    GROUP BY
        group_id
)
SELECT
    start_time,
    finish_time,
    SEC_TO_TIME(covered_seconds) AS covered_time
FROM
    CoveredPeriods
ORDER BY
    covered_seconds DESC


