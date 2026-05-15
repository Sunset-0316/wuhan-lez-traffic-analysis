-- =====================================================
-- 04_spatial_matching.sql
-- 空间匹配打标（零碳区、绿色区、适度区）
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始空间匹配打标：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO


-- =====================================================
-- 1. 更新零碳区代号（零碳区 BIT 标记 + 代号）
-- =====================================================
PRINT '1. 开始更新零碳区...';

-- 1月
PRINT '  1月 零碳区更新（分批处理）...';

-- 初始化处理标记
UPDATE [dbo].[Jan_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [零碳区代号] = z.AreaCode,
        [InZeroCarbon] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Jan_2025] v
    INNER JOIN [dbo].[ZeroCarbonAreas] z
        ON z.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    1月零碳区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  1月零碳区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 4月
PRINT '  4月 零碳区更新（分批处理）...';

UPDATE [dbo].[Apr_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [零碳区代号] = z.AreaCode,
        [InZeroCarbon] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Apr_2025] v
    INNER JOIN [dbo].[ZeroCarbonAreas] z
        ON z.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    4月零碳区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  4月零碳区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 7月
PRINT '  7月 零碳区更新（分批处理）...';

UPDATE [dbo].[July_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [零碳区代号] = z.AreaCode,
        [InZeroCarbon] = 1,
        ProcessedFlag = 1
    FROM [dbo].[July_2025] v
    INNER JOIN [dbo].[ZeroCarbonAreas] z
        ON z.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    7月零碳区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  7月零碳区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 10月
PRINT '  10月 零碳区更新（分批处理）...';

UPDATE [dbo].[Oct_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [零碳区代号] = z.AreaCode,
        [InZeroCarbon] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Oct_2025] v
    INNER JOIN [dbo].[ZeroCarbonAreas] z
        ON z.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    10月零碳区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  10月零碳区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO


-- =====================================================
-- 2. 更新绿色区代号
-- =====================================================
PRINT '2. 开始更新绿色区...';

-- 1月
PRINT '  1月 绿色区更新（分批处理）...';

UPDATE [dbo].[Jan_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [绿色区代号] = g.AreaCode,
        [InGreenLogistics] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Jan_2025] v
    INNER JOIN [dbo].[GreenLogisticsAreas] g
        ON g.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    1月绿色区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  1月绿色区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 4月
PRINT '  4月 绿色区更新（分批处理）...';

UPDATE [dbo].[Apr_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [绿色区代号] = g.AreaCode,
        [InGreenLogistics] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Apr_2025] v
    INNER JOIN [dbo].[GreenLogisticsAreas] g
        ON g.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    4月绿色区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  4月绿色区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 7月
PRINT '  7月 绿色区更新（分批处理）...';

UPDATE [dbo].[July_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [绿色区代号] = g.AreaCode,
        [InGreenLogistics] = 1,
        ProcessedFlag = 1
    FROM [dbo].[July_2025] v
    INNER JOIN [dbo].[GreenLogisticsAreas] g
        ON g.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    7月绿色区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  7月绿色区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 10月
PRINT '  10月 绿色区更新（分批处理）...';

UPDATE [dbo].[Oct_2025] SET ProcessedFlag = 0 WHERE ProcessedFlag IS NULL;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [绿色区代号] = g.AreaCode,
        [InGreenLogistics] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Oct_2025] v
    INNER JOIN [dbo].[GreenLogisticsAreas] g
        ON g.Geometry.STIntersects(v.GeoPoint) = 1
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    10月绿色区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  10月绿色区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO


-- =====================================================
-- 3. 更新适度区代号
-- =====================================================
PRINT '3. 开始更新适度区...';

-- 1月
PRINT '  1月 适度区更新（先设0，再更新）...';

UPDATE [dbo].[Jan_2025] SET [适度区代号] = '0', [InModerateControl] = 0;
UPDATE [dbo].[Jan_2025] SET ProcessedFlag = 0;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [适度区代号] = m.BigZoneCode,
        [InModerateControl] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Jan_2025] v
    INNER JOIN [dbo].[ModerateControlZones] m
        ON m.Geometry.STDistance(v.GeoPoint) < 30
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    1月适度区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  1月适度区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 4月
PRINT '  4月 适度区更新（先设0，再更新）...';

UPDATE [dbo].[Apr_2025] SET [适度区代号] = '0', [InModerateControl] = 0;
UPDATE [dbo].[Apr_2025] SET ProcessedFlag = 0;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [适度区代号] = m.BigZoneCode,
        [InModerateControl] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Apr_2025] v
    INNER JOIN [dbo].[ModerateControlZones] m
        ON m.Geometry.STDistance(v.GeoPoint) < 30
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    4月适度区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  4月适度区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 7月
PRINT '  7月 适度区更新（先设0，再更新）...';

UPDATE [dbo].[July_2025] SET [适度区代号] = '0', [InModerateControl] = 0;
UPDATE [dbo].[July_2025] SET ProcessedFlag = 0;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [适度区代号] = m.BigZoneCode,
        [InModerateControl] = 1,
        ProcessedFlag = 1
    FROM [dbo].[July_2025] v
    INNER JOIN [dbo].[ModerateControlZones] m
        ON m.Geometry.STDistance(v.GeoPoint) < 30
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    7月适度区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  7月适度区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO

-- 10月
PRINT '  10月 适度区更新（先设0，再更新）...';

UPDATE [dbo].[Oct_2025] SET [适度区代号] = '0', [InModerateControl] = 0;
UPDATE [dbo].[Oct_2025] SET ProcessedFlag = 0;

DECLARE @BatchSize INT = 500000;
DECLARE @RowsAffected INT = 1;
DECLARE @TotalUpdated BIGINT = 0;
DECLARE @BatchNumber INT = 1;

WHILE @RowsAffected > 0
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE TOP (@BatchSize) v
    SET 
        [适度区代号] = m.BigZoneCode,
        [InModerateControl] = 1,
        ProcessedFlag = 1
    FROM [dbo].[Oct_2025] v
    INNER JOIN [dbo].[ModerateControlZones] m
        ON m.Geometry.STDistance(v.GeoPoint) < 30
    WHERE v.ProcessedFlag = 0;
    
    SET @RowsAffected = @@ROWCOUNT;
    SET @TotalUpdated = @TotalUpdated + @RowsAffected;
    
    COMMIT TRANSACTION;
    
    IF @BatchNumber % 100 = 0
    BEGIN
        PRINT '    10月适度区: 已更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
    END
    
    SET @BatchNumber = @BatchNumber + 1;
    WAITFOR DELAY '00:00:00.5';
END

PRINT '  10月适度区完成，共更新 ' + CAST(@TotalUpdated AS VARCHAR) + ' 行';
GO


-- =====================================================
-- 4. 验证打标结果
-- =====================================================
PRINT '4. 验证打标结果...';

SELECT '1月' AS 月份,
    COUNT(*) AS 总点数,
    SUM(CASE WHEN [零碳区代号] IS NOT NULL THEN 1 ELSE 0 END) AS 零碳区点数,
    SUM(CASE WHEN [绿色区代号] IS NOT NULL THEN 1 ELSE 0 END) AS 绿色区点数,
    SUM(CASE WHEN [适度区代号] != '0' THEN 1 ELSE 0 END) AS 适度区点数
FROM [dbo].[Jan_2025]
UNION ALL
SELECT '4月',
    COUNT(*),
    SUM(CASE WHEN [零碳区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [绿色区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [适度区代号] != '0' THEN 1 ELSE 0 END)
FROM [dbo].[Apr_2025]
UNION ALL
SELECT '7月',
    COUNT(*),
    SUM(CASE WHEN [零碳区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [绿色区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [适度区代号] != '0' THEN 1 ELSE 0 END)
FROM [dbo].[July_2025]
UNION ALL
SELECT '10月',
    COUNT(*),
    SUM(CASE WHEN [零碳区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [绿色区代号] IS NOT NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN [适度区代号] != '0' THEN 1 ELSE 0 END)
FROM [dbo].[Oct_2025];
GO


PRINT '========================================';
PRINT '空间匹配打标完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO