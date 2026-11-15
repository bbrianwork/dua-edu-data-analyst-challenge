-- =============================================
-- 05_activation_retention.sql
-- D7 Retention: có hoạt động (trừ sign_up) đúng ngày đăng ký + 7
-- =============================================
SELECT
    COUNT(DISTINCT u.user_id) AS tong_nguoi,
    COUNT(DISTINCT CASE
            WHEN DATEDIFF(DAY, u.registered_at, e.occurred_at) = 7
             AND e.event_name <> 'sign_up'
            THEN u.user_id
         END) AS nguoi_quay_lai_d7,
    CAST(
        COUNT(DISTINCT CASE
                WHEN DATEDIFF(DAY, u.registered_at, e.occurred_at) = 7
                 AND e.event_name <> 'sign_up'
                THEN u.user_id
             END) * 100.0
        / COUNT(DISTINCT u.user_id)
    AS DECIMAL(5,1)) AS d7_retention_pct
FROM Users u
LEFT JOIN Events e ON e.user_id = u.user_id;

-- =============================================
-- Bảng tổng hợp: mỗi người dùng 1 dòng, các cờ 0/1 cho từng KPI
-- =============================================
GO
CREATE OR ALTER VIEW user_summary AS
SELECT
    u.user_id,
    u.acquisition_channel,
    u.device_type,
    u.province,
    u.learning_goal,
    u.experience_level,
    MAX(CASE WHEN e.event_name = 'start_lesson'    AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6 THEN 1 ELSE 0 END) AS activated,
    MAX(CASE WHEN e.event_name = 'complete_lesson' AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6 THEN 1 ELSE 0 END) AS completed_w1,
    MAX(CASE WHEN e.event_name <> 'sign_up'        AND DATEDIFF(DAY, u.registered_at, e.occurred_at) = 7  THEN 1 ELSE 0 END) AS retained_d7,
    MAX(CASE WHEN e.event_name = 'check_in'        AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6 THEN 1 ELSE 0 END) AS checked_in_w1,
    MAX(CASE WHEN e.event_name = 'join_campaign'   AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6 THEN 1 ELSE 0 END) AS joined_campaign_w1,
    MAX(CASE WHEN e.event_name IN ('check_in','join_campaign','share_content')
                                                   AND DATEDIFF(DAY, u.registered_at, e.occurred_at) <= 6 THEN 1 ELSE 0 END) AS engaged_w1,
    MAX(CASE WHEN e.event_name IN ('start_lesson','complete_lesson','submit_quiz')
                                                   AND DATEDIFF(DAY, u.registered_at, e.occurred_at) = 7  THEN 1 ELSE 0 END) AS retained_d7_learning
FROM Users u
LEFT JOIN Events e ON e.user_id = u.user_id
GROUP BY u.user_id, u.acquisition_channel, u.device_type,
         u.province, u.learning_goal, u.experience_level;
GO
---------------------------------------------------------------------------------------

    SELECT
    activated,
    COUNT(*)                                          AS so_nguoi,
    SUM(retained_d7)                                  AS quay_lai_d7,
    CAST(AVG(retained_d7 * 100.0) AS DECIMAL(5,1))    AS d7_pct
FROM user_summary
GROUP BY activated;


SELECT TOP 5 * FROM user_summary;