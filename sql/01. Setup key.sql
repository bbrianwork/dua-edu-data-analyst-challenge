-- =============================================
-- 01_setup_keys.sql
-- =============================================
SELECT 'Users' AS bang, COUNT(*) AS so_dong FROM Users
UNION ALL SELECT 'Events', COUNT(*) FROM Events
UNION ALL SELECT 'Content', COUNT(*) FROM Content
UNION ALL SELECT 'Campaigns', COUNT(*) FROM Campaigns;

-- 1. Chuẩn hóa kiểu dữ liệu
ALTER TABLE Users     ALTER COLUMN user_id     nvarchar(10) NOT NULL;
ALTER TABLE Content   ALTER COLUMN content_id  nvarchar(10) NOT NULL;
ALTER TABLE Campaigns ALTER COLUMN campaign_id nvarchar(10) NOT NULL;
ALTER TABLE Events    ALTER COLUMN event_id    nvarchar(10) NOT NULL;
ALTER TABLE Events    ALTER COLUMN user_id     nvarchar(10) NOT NULL;
ALTER TABLE Events    ALTER COLUMN content_id  nvarchar(10) NULL;
ALTER TABLE Events    ALTER COLUMN campaign_id nvarchar(10) NULL;

-- 2. Primary Key
ALTER TABLE Users     ADD CONSTRAINT PK_Users     PRIMARY KEY (user_id);
ALTER TABLE Content   ADD CONSTRAINT PK_Content   PRIMARY KEY (content_id);
ALTER TABLE Campaigns ADD CONSTRAINT PK_Campaigns PRIMARY KEY (campaign_id);
ALTER TABLE Events    ADD CONSTRAINT PK_Events    PRIMARY KEY (event_id);

-- 3. Foreign Key
ALTER TABLE Events ADD CONSTRAINT FK_Events_Users
    FOREIGN KEY (user_id) REFERENCES Users(user_id);
ALTER TABLE Events ADD CONSTRAINT FK_Events_Content
    FOREIGN KEY (content_id) REFERENCES Content(content_id);
ALTER TABLE Events ADD CONSTRAINT FK_Events_Campaigns
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id);