-- =============================================
-- 02_data_quality.sql
-- Mục đích: kiểm tra dữ liệu trước khi phân tích
-- =============================================

SELECT user_id, COUNT(*) AS so_lan
FROM Users
GROUP BY user_id
HAVING COUNT(*) > 1;

--Kiểm tra có sự kiện nào xảy ra trước đăng  ký ko--
SELECT COUNT(*) AS so_su_kien_loi 
FROM Events e
JOIN Users u ON e.user_id=u.user_id
WHERE e.occurred_at < u.registered_at;

--kiểm tra sự kiện sign_up--
SELECT user_id, COUNT(*) AS so_lan
FROM Events
WHERE event_name = 'sign_up'
GROUP BY user_id 
HAVING COUNT(*) > 1;

SELECT COUNT(DISTINCT user_id) FROM Events WHERE event_name='sign_up';

--kiểm tra khoảng dữ liệu--
SELECT MIN(registered_at), MAX(registered_at) FROM Users;
SELECT MIN(occurred_at) AS su_kien_bat_dau, MAX(occurred_at) FROM Events;

--kiểm tra xem có users nào chưa start_lesson mà đã complete_lesson chưa-- 
SELECT user_id, content_id FROM Events WHERE event_name = 'complete_lesson' 
EXCEPT 
SELECT user_id, content_id FROM Events WHERE event_name = 'start_lesson';