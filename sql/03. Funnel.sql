-- =============================================
-- 03_funnel.sql
-- Phân tích funnel: sign_up > log_in > view_content > start_lesson > complete_lesson--
-- =============================================
SELECT
    e.event_name,
    COUNT(DISTINCT e.user_id) AS so_nguoi
FROM Events e
JOIN Users u ON e.user_id = u.user_id
WHERE e.event_name IN ('sign_up','log_in','view_content','start_lesson','complete_lesson')
  AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6
GROUP BY e.event_name
ORDER BY so_nguoi DESC;


-----------------------------------------------
SELECT 
e.event_name,
COUNT(DISTINCT e.user_id) AS so_nguoi
FROM Events e
JOIN Users u ON e.user_id=u.user_id
WHERE e.event_name IN ('sign_up','log_in','view_content','start_lesson','complete_lesson')
AND
DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6
GROUP BY e.event_name
ORDER BY CASE e.event_name
  WHEN 'sign_up'         THEN 1
  WHEN 'log_in'          THEN 2
  WHEN 'view_content'    THEN 3
  WHEN 'start_lesson'    THEN 4
  WHEN 'complete_lesson' THEN 5
END; 


-- =============================================
-- funnel: Funnel 7 ngày đầu (ngày 0–6)
-- =============================================
WITH funnel AS (
    SELECT
        e.event_name,
        COUNT(DISTINCT e.user_id) AS so_nguoi,
        CASE e.event_name
            WHEN 'sign_up'         THEN 1
            WHEN 'log_in'          THEN 2
            WHEN 'view_content'    THEN 3
            WHEN 'start_lesson'    THEN 4
            WHEN 'complete_lesson' THEN 5
        END AS buoc
    FROM Events e
    JOIN Users u ON e.user_id = u.user_id
    WHERE e.event_name IN ('sign_up','log_in','view_content','start_lesson','complete_lesson')
      AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6
    GROUP BY e.event_name
)
SELECT
    buoc,
    event_name,
    so_nguoi,
    -- Overall: so với sign_up
    CAST(ROUND(so_nguoi * 100.0 / (SELECT so_nguoi FROM funnel WHERE buoc = 1), 1) AS DECIMAL(5,1)) AS pct_so_voi_signup,
    -- Step: so với bước ngay trước
    CAST(ROUND(so_nguoi * 100.0 / LAG(so_nguoi) OVER (ORDER BY buoc), 1) AS DECIMAL(5,1))           AS pct_so_voi_buoc_truoc
FROM funnel
ORDER BY buoc;
