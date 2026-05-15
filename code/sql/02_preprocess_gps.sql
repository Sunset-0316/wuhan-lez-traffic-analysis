-- =====================================================
-- 03_preprocess_gps.sql
-- GPS数据预处理（空间索引、字段添加、分批更新策略）
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始GPS数据预处理：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO


-- =====================================================
-- 1. 添加空间计算列
-- =====================================================
PRINT '1. 添加空间计算列...';

-- 1月
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Jan_2025') AND name = 'GeoPoint')
BEGIN
    ALTER TABLE [dbo].[Jan_2025] ADD 
        [GeoPoint] AS (geography::Point([北纬], [东经], 4326)) PERSISTED;
    PRINT 'Jan_2025 GeoPoint 列添加成功';
END

-- 4月
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Apr_2025') AND name = 'GeoPoint')
BEGIN
    ALTER TABLE [dbo].[Apr_2025] ADD 
        [GeoPoint] AS (geography::Point([北纬], [东经], 4326)) PERSISTED;
    PRINT 'Apr_2025 GeoPoint 列添加成功';
END

-- 7月
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.July_2025') AND name = 'GeoPoint')
BEGIN
    ALTER TABLE [dbo].[July_2025] ADD 
        [GeoPoint] AS (geography::Point([北纬], [东经], 4326)) PERSISTED;
    PRINT 'July_2025 GeoPoint 列添加成功';
END

-- 10月
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Oct_2025') AND name = 'GeoPoint')
BEGIN
    ALTER TABLE [dbo].[Oct_2025] ADD 
        [GeoPoint] AS (geography::Point([北纬], [东经], 4326)) PERSISTED;
    PRINT 'Oct_2025 GeoPoint 列添加成功';
END
GO


-- =====================================================
-- 2. 创建空间索引
-- =====================================================
PRINT '2. 创建空间索引...';

-- 1月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'SIndx_Jan2025_GeoPoint' AND object_id = OBJECT_ID('dbo.Jan_2025'))
BEGIN
    CREATE SPATIAL INDEX [SIndx_Jan2025_GeoPoint] 
    ON [dbo].[Jan_2025]([GeoPoint])
    WITH (BOUNDING_BOX = (114.0, 30.4, 114.6, 30.8));
    PRINT 'Jan_2025 空间索引创建完成';
END

-- 4月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'SIndx_Apr2025_GeoPoint' AND object_id = OBJECT_ID('dbo.Apr_2025'))
BEGIN
    CREATE SPATIAL INDEX [SIndx_Apr2025_GeoPoint] 
    ON [dbo].[Apr_2025]([GeoPoint])
    WITH (BOUNDING_BOX = (114.0, 30.4, 114.6, 30.8));
    PRINT 'Apr_2025 空间索引创建完成';
END

-- 7月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'SIndx_July2025_GeoPoint' AND object_id = OBJECT_ID('dbo.July_2025'))
BEGIN
    CREATE SPATIAL INDEX [SIndx_July2025_GeoPoint] 
    ON [dbo].[July_2025]([GeoPoint])
    WITH (BOUNDING_BOX = (114.0, 30.4, 114.6, 30.8));
    PRINT 'July_2025 空间索引创建完成';
END

-- 10月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'SIndx_Oct2025_GeoPoint' AND object_id = OBJECT_ID('dbo.Oct_2025'))
BEGIN
    CREATE SPATIAL INDEX [SIndx_Oct2025_GeoPoint] 
    ON [dbo].[Oct_2025]([GeoPoint])
    WITH (BOUNDING_BOX = (114.0, 30.4, 114.6, 30.8));
    PRINT 'Oct_2025 空间索引创建完成';
END
GO


-- =====================================================
-- 3. 创建普通索引
-- =====================================================
PRINT '3. 创建普通索引...';

-- 1月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Jan2025_ProcessedFlag' AND object_id = OBJECT_ID('dbo.Jan_2025'))
BEGIN
    CREATE INDEX [IX_Jan2025_ProcessedFlag] ON [dbo].[Jan_2025]([ProcessedFlag]) WHERE [ProcessedFlag] IS NULL;
    PRINT 'Jan_2025 ProcessedFlag 索引创建完成';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Jan2025_采集时间' AND object_id = OBJECT_ID('dbo.Jan_2025'))
BEGIN
    CREATE INDEX [IX_Jan2025_采集时间] ON [dbo].[Jan_2025]([数据采集时间]);
    PRINT 'Jan_2025 采集时间索引创建完成';
END

-- 4月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Apr2025_ProcessedFlag' AND object_id = OBJECT_ID('dbo.Apr_2025'))
BEGIN
    CREATE INDEX [IX_Apr2025_ProcessedFlag] ON [dbo].[Apr_2025]([ProcessedFlag]) WHERE [ProcessedFlag] IS NULL;
    PRINT 'Apr_2025 ProcessedFlag 索引创建完成';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Apr2025_采集时间' AND object_id = OBJECT_ID('dbo.Apr_2025'))
BEGIN
    CREATE INDEX [IX_Apr2025_采集时间] ON [dbo].[Apr_2025]([数据采集时间]);
    PRINT 'Apr_2025 采集时间索引创建完成';
END

-- 7月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_July2025_ProcessedFlag' AND object_id = OBJECT_ID('dbo.July_2025'))
BEGIN
    CREATE INDEX [IX_July2025_ProcessedFlag] ON [dbo].[July_2025]([ProcessedFlag]) WHERE [ProcessedFlag] IS NULL;
    PRINT 'July_2025 ProcessedFlag 索引创建完成';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_July2025_采集时间' AND object_id = OBJECT_ID('dbo.July_2025'))
BEGIN
    CREATE INDEX [IX_July2025_采集时间] ON [dbo].[July_2025]([数据采集时间]);
    PRINT 'July_2025 采集时间索引创建完成';
END

-- 10月
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Oct2025_ProcessedFlag' AND object_id = OBJECT_ID('dbo.Oct_2025'))
BEGIN
    CREATE INDEX [IX_Oct2025_ProcessedFlag] ON [dbo].[Oct_2025]([ProcessedFlag]) WHERE [ProcessedFlag] IS NULL;
    PRINT 'Oct_2025 ProcessedFlag 索引创建完成';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Oct2025_采集时间' AND object_id = OBJECT_ID('dbo.Oct_2025'))
BEGIN
    CREATE INDEX [IX_Oct2025_采集时间] ON [dbo].[Oct_2025]([数据采集时间]);
    PRINT 'Oct_2025 采集时间索引创建完成';
END
GO


-- =====================================================
-- 4. 初始化处理标记
-- =====================================================
PRINT '4. 初始化处理标记...';

UPDATE [dbo].[Jan_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;
PRINT 'Jan_2025 初始化完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

UPDATE [dbo].[Apr_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;
PRINT 'Apr_2025 初始化完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

UPDATE [dbo].[July_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;
PRINT 'July_2025 初始化完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

UPDATE [dbo].[Oct_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;
PRINT 'Oct_2025 初始化完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 5. 验证预处理结果
-- =====================================================
PRINT '5. 验证预处理结果...';

SELECT 
    'Jan_2025' AS 表名,
    COUNT(*) AS 总记录数,
    SUM(CASE WHEN GeoPoint IS NOT NULL THEN 1 ELSE 0 END) AS GeoPoint非空数
FROM [dbo].[Jan_2025]
UNION ALL
SELECT 
    'Apr_2025',
    COUNT(*),
    SUM(CASE WHEN GeoPoint IS NOT NULL THEN 1 ELSE 0 END)
FROM [dbo].[Apr_2025]
UNION ALL
SELECT 
    'July_2025',
    COUNT(*),
    SUM(CASE WHEN GeoPoint IS NOT NULL THEN 1 ELSE 0 END)
FROM [dbo].[July_2025]
UNION ALL
SELECT 
    'Oct_2025',
    COUNT(*),
    SUM(CASE WHEN GeoPoint IS NOT NULL THEN 1 ELSE 0 END)
FROM [dbo].[Oct_2025];
GO


PRINT '========================================';
PRINT 'GPS数据预处理完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO