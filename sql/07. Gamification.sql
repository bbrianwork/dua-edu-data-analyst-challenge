-- =============================================
-- 07_gamification.sql
-- =============================================
SELECT
    engaged_w1,
    COUNT(*)                                                   AS so_nguoi,
    CAST(AVG(retained_d7          * 100.0) AS DECIMAL(5,1))    AS d7_pct,
    CAST(AVG(retained_d7_learning * 100.0) AS DECIMAL(5,1))    AS d7_hoc_pct,
    CAST(AVG(activated            * 100.0) AS DECIMAL(5,1))    AS activation_pct
FROM user_summary
GROUP BY engaged_w1;

-- =============================================
-- người có gamification sẽ có D7 cao hơn người không có bao nhiêu điểm %?
-- =============================================
SELECT
    activated,
    engaged_w1,
    COUNT(*)                                                   AS so_nguoi,
    CAST(AVG(retained_d7          * 100.0) AS DECIMAL(5,1))    AS d7_pct,
    CAST(AVG(retained_d7_learning * 100.0) AS DECIMAL(5,1))    AS d7_hoc_pct
FROM user_summary
GROUP BY activated, engaged_w1
ORDER BY activated, engaged_w1;

