-- =====================================================
-- 05_traffic_volume.sql
-- 交通量统计（瞬时交通量、时段汇总）
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始交通量统计：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO

-- =====================================================
-- 1. 清空旧数据
-- =====================================================
PRINT '1. 清空旧数据...';

TRUNCATE TABLE dbo.TrafficStats_Jan_Timestamp;
TRUNCATE TABLE dbo.TrafficStats_Apr_Timestamp;
TRUNCATE TABLE dbo.TrafficStats_Jul_Timestamp;
TRUNCATE TABLE dbo.TrafficStats_Oct_Timestamp;

TRUNCATE TABLE dbo.TrafficStats_Jan;
TRUNCATE TABLE dbo.TrafficStats_Apr;
TRUNCATE TABLE dbo.TrafficStats_Jul;
TRUNCATE TABLE dbo.TrafficStats_Oct;

PRINT '旧数据清空完成';
GO


-- =====================================================
-- 2. 瞬时交通量统计（1月）
-- =====================================================
PRINT '2. 统计 1月 瞬时交通量...';

-- 1月 零碳区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号],
        LAG([零碳区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Jan_2025]
    WHERE [数据采集时间] BETWEEN '2025-01-06' AND '2025-01-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [零碳区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [零碳区代号])
)
INSERT INTO dbo.TrafficStats_Jan_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '1月',
    [数据采集时间],
    区域代号,
    COUNT(*) AS 交通量
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '1月零碳区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 1月 绿色区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号],
        LAG([绿色区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Jan_2025]
    WHERE [数据采集时间] BETWEEN '2025-01-06' AND '2025-01-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [绿色区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [绿色区代号])
)
INSERT INTO dbo.TrafficStats_Jan_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '1月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '1月绿色区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 1月 适度区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号],
        LAG([适度区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Jan_2025]
    WHERE [数据采集时间] BETWEEN '2025-01-06' AND '2025-01-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [适度区代号] != '0'
      AND (Prev_Zone IS NULL OR Prev_Zone != [适度区代号])
)
INSERT INTO dbo.TrafficStats_Jan_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '1月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '1月适度区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 3. 瞬时交通量统计（4月）
-- =====================================================
PRINT '3. 统计 4月 瞬时交通量...';

-- 4月 零碳区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号],
        LAG([零碳区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Apr_2025]
    WHERE [数据采集时间] BETWEEN '2025-04-07' AND '2025-04-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [零碳区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [零碳区代号])
)
INSERT INTO dbo.TrafficStats_Apr_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '4月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '4月零碳区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 4月 绿色区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号],
        LAG([绿色区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Apr_2025]
    WHERE [数据采集时间] BETWEEN '2025-04-07' AND '2025-04-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [绿色区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [绿色区代号])
)
INSERT INTO dbo.TrafficStats_Apr_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '4月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '4月绿色区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 4月 适度区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号],
        LAG([适度区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Apr_2025]
    WHERE [数据采集时间] BETWEEN '2025-04-07' AND '2025-04-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [适度区代号] != '0'
      AND (Prev_Zone IS NULL OR Prev_Zone != [适度区代号])
)
INSERT INTO dbo.TrafficStats_Apr_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '4月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '4月适度区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 4. 瞬时交通量统计（7月）
-- =====================================================
PRINT '4. 统计 7月 瞬时交通量...';

-- 7月 零碳区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号],
        LAG([零碳区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[July_2025]
    WHERE [数据采集时间] BETWEEN '2025-07-07' AND '2025-07-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [零碳区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [零碳区代号])
)
INSERT INTO dbo.TrafficStats_Jul_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '7月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '7月零碳区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 7月 绿色区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号],
        LAG([绿色区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[July_2025]
    WHERE [数据采集时间] BETWEEN '2025-07-07' AND '2025-07-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [绿色区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [绿色区代号])
)
INSERT INTO dbo.TrafficStats_Jul_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '7月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '7月绿色区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 7月 适度区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号],
        LAG([适度区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[July_2025]
    WHERE [数据采集时间] BETWEEN '2025-07-07' AND '2025-07-13'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [适度区代号] != '0'
      AND (Prev_Zone IS NULL OR Prev_Zone != [适度区代号])
)
INSERT INTO dbo.TrafficStats_Jul_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '7月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '7月适度区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 5. 瞬时交通量统计（10月）
-- =====================================================
PRINT '5. 统计 10月 瞬时交通量...';

-- 10月 零碳区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号],
        LAG([零碳区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Oct_2025]
    WHERE [数据采集时间] BETWEEN '2025-10-06' AND '2025-10-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [零碳区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [零碳区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [零碳区代号])
)
INSERT INTO dbo.TrafficStats_Oct_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '10月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '10月零碳区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 10月 绿色区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号],
        LAG([绿色区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Oct_2025]
    WHERE [数据采集时间] BETWEEN '2025-10-06' AND '2025-10-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [绿色区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [绿色区代号] IS NOT NULL
      AND (Prev_Zone IS NULL OR Prev_Zone != [绿色区代号])
)
INSERT INTO dbo.TrafficStats_Oct_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '10月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '10月绿色区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO

-- 10月 适度区
WITH VehicleEntries AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号],
        LAG([适度区代号]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS Prev_Zone
    FROM [dbo].[Oct_2025]
    WHERE [数据采集时间] BETWEEN '2025-10-06' AND '2025-10-12'
),
EntryEvents AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [适度区代号] AS 区域代号
    FROM VehicleEntries
    WHERE [适度区代号] != '0'
      AND (Prev_Zone IS NULL OR Prev_Zone != [适度区代号])
)
INSERT INTO dbo.TrafficStats_Oct_Timestamp (月份, 时间戳, 区域代号, 交通量)
SELECT 
    '10月',
    [数据采集时间],
    区域代号,
    COUNT(*)
FROM EntryEvents
GROUP BY [数据采集时间], 区域代号;
PRINT '10月适度区瞬时交通量统计完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 6. 时段汇总统计（1月）
-- =====================================================
PRINT '6. 统计 1月 时段汇总...';

INSERT INTO dbo.TrafficStats_Jan (
    统计日期, 区域类型,
    全天总车次, 全天总车辆数,
    早高峰车次, 早高峰车辆数,
    晚高峰车次, 晚高峰车辆数,
    上午平峰车次, 上午平峰车辆数,
    午后平峰车次, 午后平峰车辆数,
    傍晚平峰车次, 傍晚平峰车辆数,
    夜间时段车次, 夜间时段车辆数,
    上午配送车次, 上午配送车辆数,
    下午配送车次, 下午配送车辆数
)
SELECT 
    CAST(时间戳 AS DATE) AS 统计日期,
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END AS 区域类型,
    COUNT(*) AS 全天总车次,
    COUNT(DISTINCT 车架号) AS 全天总车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS 早高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 车架号 END) AS 早高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 1 ELSE 0 END) AS 晚高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 车架号 END) AS 晚高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 1 ELSE 0 END) AS 午后平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 车架号 END) AS 午后平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 1 ELSE 0 END) AS 傍晚平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 车架号 END) AS 傍晚平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 1 ELSE 0 END) AS 夜间时段车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 车架号 END) AS 夜间时段车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午配送车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 1 ELSE 0 END) AS 下午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 车架号 END) AS 下午配送车辆数
FROM (
    SELECT t.*, v.[车架号]
    FROM dbo.TrafficStats_Jan_Timestamp t
    LEFT JOIN [dbo].[Jan_2025] v ON t.时间戳 = v.[数据采集时间]
) s
GROUP BY CAST(时间戳 AS DATE),
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END;
PRINT '1月时段汇总完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 7. 时段汇总统计（4月）
-- =====================================================
PRINT '7. 统计 4月 时段汇总...';

INSERT INTO dbo.TrafficStats_Apr (
    统计日期, 区域类型,
    全天总车次, 全天总车辆数,
    早高峰车次, 早高峰车辆数,
    晚高峰车次, 晚高峰车辆数,
    上午平峰车次, 上午平峰车辆数,
    午后平峰车次, 午后平峰车辆数,
    傍晚平峰车次, 傍晚平峰车辆数,
    夜间时段车次, 夜间时段车辆数,
    上午配送车次, 上午配送车辆数,
    下午配送车次, 下午配送车辆数
)
SELECT 
    CAST(时间戳 AS DATE) AS 统计日期,
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END AS 区域类型,
    COUNT(*) AS 全天总车次,
    COUNT(DISTINCT 车架号) AS 全天总车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS 早高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 车架号 END) AS 早高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 1 ELSE 0 END) AS 晚高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 车架号 END) AS 晚高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 1 ELSE 0 END) AS 午后平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 车架号 END) AS 午后平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 1 ELSE 0 END) AS 傍晚平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 车架号 END) AS 傍晚平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 1 ELSE 0 END) AS 夜间时段车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 车架号 END) AS 夜间时段车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午配送车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 1 ELSE 0 END) AS 下午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 车架号 END) AS 下午配送车辆数
FROM (
    SELECT t.*, v.[车架号]
    FROM dbo.TrafficStats_Apr_Timestamp t
    LEFT JOIN [dbo].[Apr_2025] v ON t.时间戳 = v.[数据采集时间]
) s
GROUP BY CAST(时间戳 AS DATE),
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END;
PRINT '4月时段汇总完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 8. 时段汇总统计（7月）
-- =====================================================
PRINT '8. 统计 7月 时段汇总...';

INSERT INTO dbo.TrafficStats_Jul (
    统计日期, 区域类型,
    全天总车次, 全天总车辆数,
    早高峰车次, 早高峰车辆数,
    晚高峰车次, 晚高峰车辆数,
    上午平峰车次, 上午平峰车辆数,
    午后平峰车次, 午后平峰车辆数,
    傍晚平峰车次, 傍晚平峰车辆数,
    夜间时段车次, 夜间时段车辆数,
    上午配送车次, 上午配送车辆数,
    下午配送车次, 下午配送车辆数
)
SELECT 
    CAST(时间戳 AS DATE) AS 统计日期,
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END AS 区域类型,
    COUNT(*) AS 全天总车次,
    COUNT(DISTINCT 车架号) AS 全天总车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS 早高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 车架号 END) AS 早高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 1 ELSE 0 END) AS 晚高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 车架号 END) AS 晚高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 1 ELSE 0 END) AS 午后平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 车架号 END) AS 午后平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 1 ELSE 0 END) AS 傍晚平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 车架号 END) AS 傍晚平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 1 ELSE 0 END) AS 夜间时段车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 车架号 END) AS 夜间时段车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午配送车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 1 ELSE 0 END) AS 下午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 车架号 END) AS 下午配送车辆数
FROM (
    SELECT t.*, v.[车架号]
    FROM dbo.TrafficStats_Jul_Timestamp t
    LEFT JOIN [dbo].[July_2025] v ON t.时间戳 = v.[数据采集时间]
) s
GROUP BY CAST(时间戳 AS DATE),
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END;
PRINT '7月时段汇总完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 9. 时段汇总统计（10月）
-- =====================================================
PRINT '9. 统计 10月 时段汇总...';

INSERT INTO dbo.TrafficStats_Oct (
    统计日期, 区域类型,
    全天总车次, 全天总车辆数,
    早高峰车次, 早高峰车辆数,
    晚高峰车次, 晚高峰车辆数,
    上午平峰车次, 上午平峰车辆数,
    午后平峰车次, 午后平峰车辆数,
    傍晚平峰车次, 傍晚平峰车辆数,
    夜间时段车次, 夜间时段车辆数,
    上午配送车次, 上午配送车辆数,
    下午配送车次, 下午配送车辆数
)
SELECT 
    CAST(时间戳 AS DATE) AS 统计日期,
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END AS 区域类型,
    COUNT(*) AS 全天总车次,
    COUNT(DISTINCT 车架号) AS 全天总车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS 早高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 7 AND 8 THEN 车架号 END) AS 早高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 1 ELSE 0 END) AS 晚高峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 17 AND 18 THEN 车架号 END) AS 晚高峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 1 ELSE 0 END) AS 午后平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 12 AND 13 THEN 车架号 END) AS 午后平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 1 ELSE 0 END) AS 傍晚平峰车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 19 AND 21 THEN 车架号 END) AS 傍晚平峰车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 1 ELSE 0 END) AS 夜间时段车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) >= 22 OR DATEPART(HOUR, 时间戳) < 6 THEN 车架号 END) AS 夜间时段车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 1 ELSE 0 END) AS 上午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 9 AND 11 THEN 车架号 END) AS 上午配送车辆数,
    SUM(CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 1 ELSE 0 END) AS 下午配送车次,
    COUNT(DISTINCT CASE WHEN DATEPART(HOUR, 时间戳) BETWEEN 14 AND 17 THEN 车架号 END) AS 下午配送车辆数
FROM (
    SELECT t.*, v.[车架号]
    FROM dbo.TrafficStats_Oct_Timestamp t
    LEFT JOIN [dbo].[Oct_2025] v ON t.时间戳 = v.[数据采集时间]
) s
GROUP BY CAST(时间戳 AS DATE),
    CASE 
        WHEN 区域代号 LIKE 'LT-%' THEN '零碳区'
        WHEN 区域代号 LIKE 'LS-%' THEN '绿色区'
        WHEN 区域代号 LIKE 'SD-%' THEN '适度区'
    END;
PRINT '10月时段汇总完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


PRINT '========================================';
PRINT '交通量统计完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO