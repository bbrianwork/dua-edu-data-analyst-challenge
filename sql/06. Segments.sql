-- =============================================
-- 06_segments.sql : KPI theo nhóm người dùng
-- =============================================

-- Theo nguồn người dùng
SELECT
    acquisition_channel,
    COUNT(*)                                            AS so_nguoi,
    CAST(AVG(activated    * 100.0) AS DECIMAL(5,1))     AS activation_pct,
    CAST(AVG(completed_w1 * 100.0) AS DECIMAL(5,1))     AS completion_w1_pct,
    CAST(AVG(retained_d7  * 100.0) AS DECIMAL(5,1))     AS d7_pct
FROM user_summary
GROUP BY acquisition_channel
ORDER BY d7_pct;
-- 2. Theo thiết bị
SELECT
    device_type,
    COUNT(*)                                            AS so_nguoi,
    CAST(AVG(activated    * 100.0) AS DECIMAL(5,1))     AS activation_pct,
    CAST(AVG(completed_w1 * 100.0) AS DECIMAL(5,1))     AS completion_w1_pct,
    CAST(AVG(retained_d7  * 100.0) AS DECIMAL(5,1))     AS d7_pct
FROM user_summary
GROUP BY device_type
ORDER BY d7_pct;

-- 3. Theo mục tiêu học
SELECT
    learning_goal,
    COUNT(*)                                            AS so_nguoi,
    CAST(AVG(activated    * 100.0) AS DECIMAL(5,1))     AS activation_pct,
    CAST(AVG(completed_w1 * 100.0) AS DECIMAL(5,1))     AS completion_w1_pct,
    CAST(AVG(retained_d7  * 100.0) AS DECIMAL(5,1))     AS d7_pct
FROM user_summary
GROUP BY learning_goal
ORDER BY d7_pct;

-- 4. Theo tỉnh/thành (chỉ tỉnh có từ 30 người trở lên)
SELECT
    province,
    COUNT(*)                                            AS so_nguoi,
    CAST(AVG(activated    * 100.0) AS DECIMAL(5,1))     AS activation_pct,
    CAST(AVG(completed_w1 * 100.0) AS DECIMAL(5,1))     AS completion_w1_pct,
    CAST(AVG(retained_d7  * 100.0) AS DECIMAL(5,1))     AS d7_pct
FROM user_summary
GROUP BY province
HAVING COUNT(*) >= 30
ORDER BY so_nguoi DESC;