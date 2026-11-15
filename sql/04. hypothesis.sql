-- =============================================
-- 04_hypothesis.sql
-- Giả thuyết 1: Người dùng bỏ dở vì độ khó bài không hợp trình độ
-- Đơn vị phân tích: lượt học = 1 cặp (người, bài)
-- =============================================
WITH bat_dau AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'start_lesson'
),
hoan_thanh AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'complete_lesson'
)
SELECT
    u.experience_level              AS trinh_do_nguoi_hoc,
    c.level                         AS do_kho_bai,
    COUNT(*)                        AS so_luot_bat_dau,
    COUNT(h.user_id)                AS so_luot_hoan_thanh,
    CAST(COUNT(h.user_id) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ty_le_hoan_thanh
FROM bat_dau b
JOIN Users   u ON b.user_id    = u.user_id
JOIN Content c ON b.content_id = c.content_id
LEFT JOIN hoan_thanh h
       ON h.user_id = b.user_id AND h.content_id = b.content_id
GROUP BY u.experience_level, c.level
ORDER BY u.experience_level, c.level;



-- Giả thuyết 2: Học trên điện thoại khó hoàn thành --
-- Đơn vị phân tích: lượt học = 1 cặp (người, bài) --
WITH bat_dau AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'start_lesson'
),
hoan_thanh AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'complete_lesson'
)
SELECT
    u.device_type                   AS nhom,
    COUNT(*)                        AS so_luot_bat_dau,
    COUNT(h.user_id)                AS so_luot_hoan_thanh,
    CAST(COUNT(h.user_id) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ty_le_hoan_thanh
FROM bat_dau b
JOIN Users   u ON b.user_id    = u.user_id
JOIN Content c ON b.content_id = c.content_id
LEFT JOIN hoan_thanh h
       ON h.user_id = b.user_id AND h.content_id = b.content_id
GROUP BY u.device_type
ORDER BY ty_le_hoan_thanh;


-- =============================================
-- Giả thuyết 3: Có chủ đề nào đặc biệt khó hoàn thành?
-- =============================================
WITH bat_dau AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'start_lesson'
),
hoan_thanh AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'complete_lesson'
)
SELECT
    c.topic                         AS nhom,          
    COUNT(*)                        AS so_luot_bat_dau,
    COUNT(h.user_id)                AS so_luot_hoan_thanh,
    CAST(COUNT(h.user_id) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ty_le_hoan_thanh
FROM bat_dau b
JOIN Users   u ON b.user_id    = u.user_id
JOIN Content c ON b.content_id = c.content_id
LEFT JOIN hoan_thanh h
       ON h.user_id = b.user_id AND h.content_id = b.content_id
GROUP BY c.topic                                     
ORDER BY ty_le_hoan_thanh;


-- =============================================
-- Giả thuyết 4: Nguồn người dùng nào bỏ dở nhiều hơn?
-- =============================================
WITH bat_dau AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'start_lesson'
),
hoan_thanh AS (
    SELECT DISTINCT user_id, content_id FROM Events WHERE event_name = 'complete_lesson'
)
SELECT
    u.acquisition_channel           AS nhom,          
    COUNT(*)                        AS so_luot_bat_dau,
    COUNT(h.user_id)                AS so_luot_hoan_thanh,
    CAST(COUNT(h.user_id) * 100.0 / COUNT(*) AS DECIMAL(5,1)) AS ty_le_hoan_thanh
FROM bat_dau b
JOIN Users   u ON b.user_id    = u.user_id
JOIN Content c ON b.content_id = c.content_id
LEFT JOIN hoan_thanh h
       ON h.user_id = b.user_id AND h.content_id = b.content_id
GROUP BY u.acquisition_channel                        
ORDER BY ty_le_hoan_thanh;