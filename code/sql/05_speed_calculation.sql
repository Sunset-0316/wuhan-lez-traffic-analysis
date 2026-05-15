-- =====================================================
-- 06_speed_calculation.sql
-- 速度计算（相邻轨迹点距离、瞬时速度）
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始速度计算：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO


-- =====================================================
-- 1. 清空旧数据
-- =====================================================
PRINT '1. 清空旧数据...';

TRUNCATE TABLE dbo.Jan_2025_Speed;
TRUNCATE TABLE dbo.Apr_2025_Speed;
TRUNCATE TABLE dbo.Jul_2025_Speed;
TRUNCATE TABLE dbo.Oct_2025_Speed;

PRINT '旧数据清空完成';
GO


-- =====================================================
-- 2. 计算1月相邻点距离和速度
-- =====================================================
PRINT '2. 计算 1月 相邻点速度...';

WITH OrderedPoints AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [东经],
        [北纬],
        LAG([数据采集时间]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前一时间,
        LAG([东经]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前经度,
        LAG([北纬]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前纬度
    FROM [dbo].[Jan_2025]
    WHERE [数据采集时间] BETWEEN '2025-01-06' AND '2025-01-12'
),
DistanceCalc AS (
    SELECT 
        [车架号],
        前一时间 AS 起点时间,
        [数据采集时间] AS 终点时间,
        前经度 AS 起点经度,
        前纬度 AS 起点纬度,
        [东经] AS 终点经度,
        [北纬] AS 终点纬度,
        -- 将经纬度转换为弧度
        前纬度 * PI() / 180 AS lat1_rad,
        [北纬] * PI() / 180 AS lat2_rad,
        (前纬度 - [北纬]) * PI() / 180 AS dlat,
        (前经度 - [东经]) * PI() / 180 AS dlng,
        DATEDIFF(SECOND, 前一时间, [数据采集时间]) AS 时间差_秒
    FROM OrderedPoints
    WHERE 前一时间 IS NOT NULL
)
INSERT INTO dbo.Jan_2025_Speed (
    车架号, 起点时间, 终点时间,
    起点经度, 起点纬度, 终点经度, 终点纬度,
    距离_公里, 时间差_秒, 速度_公里每小时
)
SELECT 
    [车架号],
    起点时间,
    终点时间,
    起点经度,
    起点纬度,
    终点经度,
    终点纬度,
    -- 半正矢公式计算球面距离
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(dlat / 2), 2) + 
        COS(lat1_rad) * COS(lat2_rad) * 
        POWER(SIN(dlng / 2), 2)
    )) AS 距离_公里,
    时间差_秒,
    CASE 
        WHEN 时间差_秒 > 0 
        THEN 6371 * 2 * ASIN(SQRT(
            POWER(SIN(dlat / 2), 2) + 
            COS(lat1_rad) * COS(lat2_rad) * 
            POWER(SIN(dlng / 2), 2)
        )) / (时间差_秒 / 3600.0)
        ELSE 0
    END AS 速度_公里每小时
FROM DistanceCalc
WHERE 时间差_秒 > 0 AND 时间差_秒 <= 1800;  -- 只保留时间间隔≤30分钟的记录

PRINT '1月速度计算完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 3. 计算4月相邻点距离和速度
-- =====================================================
PRINT '3. 计算 4月 相邻点速度...';

WITH OrderedPoints AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [东经],
        [北纬],
        LAG([数据采集时间]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前一时间,
        LAG([东经]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前经度,
        LAG([北纬]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前纬度
    FROM [dbo].[Apr_2025]
    WHERE [数据采集时间] BETWEEN '2025-04-07' AND '2025-04-13'
),
DistanceCalc AS (
    SELECT 
        [车架号],
        前一时间 AS 起点时间,
        [数据采集时间] AS 终点时间,
        前经度 AS 起点经度,
        前纬度 AS 起点纬度,
        [东经] AS 终点经度,
        [北纬] AS 终点纬度,
        前纬度 * PI() / 180 AS lat1_rad,
        [北纬] * PI() / 180 AS lat2_rad,
        (前纬度 - [北纬]) * PI() / 180 AS dlat,
        (前经度 - [东经]) * PI() / 180 AS dlng,
        DATEDIFF(SECOND, 前一时间, [数据采集时间]) AS 时间差_秒
    FROM OrderedPoints
    WHERE 前一时间 IS NOT NULL
)
INSERT INTO dbo.Apr_2025_Speed (
    车架号, 起点时间, 终点时间,
    起点经度, 起点纬度, 终点经度, 终点纬度,
    距离_公里, 时间差_秒, 速度_公里每小时
)
SELECT 
    [车架号],
    起点时间,
    终点时间,
    起点经度,
    起点纬度,
    终点经度,
    终点纬度,
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(dlat / 2), 2) + 
        COS(lat1_rad) * COS(lat2_rad) * 
        POWER(SIN(dlng / 2), 2)
    )) AS 距离_公里,
    时间差_秒,
    CASE 
        WHEN 时间差_秒 > 0 
        THEN 6371 * 2 * ASIN(SQRT(
            POWER(SIN(dlat / 2), 2) + 
            COS(lat1_rad) * COS(lat2_rad) * 
            POWER(SIN(dlng / 2), 2)
        )) / (时间差_秒 / 3600.0)
        ELSE 0
    END AS 速度_公里每小时
FROM DistanceCalc
WHERE 时间差_秒 > 0 AND 时间差_秒 <= 1800;

PRINT '4月速度计算完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 4. 计算7月相邻点距离和速度
-- =====================================================
PRINT '4. 计算 7月 相邻点速度...';

WITH OrderedPoints AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [东经],
        [北纬],
        LAG([数据采集时间]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前一时间,
        LAG([东经]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前经度,
        LAG([北纬]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前纬度
    FROM [dbo].[July_2025]
    WHERE [数据采集时间] BETWEEN '2025-07-07' AND '2025-07-13'
),
DistanceCalc AS (
    SELECT 
        [车架号],
        前一时间 AS 起点时间,
        [数据采集时间] AS 终点时间,
        前经度 AS 起点经度,
        前纬度 AS 起点纬度,
        [东经] AS 终点经度,
        [北纬] AS 终点纬度,
        前纬度 * PI() / 180 AS lat1_rad,
        [北纬] * PI() / 180 AS lat2_rad,
        (前纬度 - [北纬]) * PI() / 180 AS dlat,
        (前经度 - [东经]) * PI() / 180 AS dlng,
        DATEDIFF(SECOND, 前一时间, [数据采集时间]) AS 时间差_秒
    FROM OrderedPoints
    WHERE 前一时间 IS NOT NULL
)
INSERT INTO dbo.Jul_2025_Speed (
    车架号, 起点时间, 终点时间,
    起点经度, 起点纬度, 终点经度, 终点纬度,
    距离_公里, 时间差_秒, 速度_公里每小时
)
SELECT 
    [车架号],
    起点时间,
    终点时间,
    起点经度,
    起点纬度,
    终点经度,
    终点纬度,
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(dlat / 2), 2) + 
        COS(lat1_rad) * COS(lat2_rad) * 
        POWER(SIN(dlng / 2), 2)
    )) AS 距离_公里,
    时间差_秒,
    CASE 
        WHEN 时间差_秒 > 0 
        THEN 6371 * 2 * ASIN(SQRT(
            POWER(SIN(dlat / 2), 2) + 
            COS(lat1_rad) * COS(lat2_rad) * 
            POWER(SIN(dlng / 2), 2)
        )) / (时间差_秒 / 3600.0)
        ELSE 0
    END AS 速度_公里每小时
FROM DistanceCalc
WHERE 时间差_秒 > 0 AND 时间差_秒 <= 1800;

PRINT '7月速度计算完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 5. 计算10月相邻点距离和速度
-- =====================================================
PRINT '5. 计算 10月 相邻点速度...';

WITH OrderedPoints AS (
    SELECT 
        [车架号],
        [数据采集时间],
        [东经],
        [北纬],
        LAG([数据采集时间]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前一时间,
        LAG([东经]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前经度,
        LAG([北纬]) OVER (PARTITION BY [车架号] ORDER BY [数据采集时间]) AS 前纬度
    FROM [dbo].[Oct_2025]
    WHERE [数据采集时间] BETWEEN '2025-10-06' AND '2025-10-12'
),
DistanceCalc AS (
    SELECT 
        [车架号],
        前一时间 AS 起点时间,
        [数据采集时间] AS 终点时间,
        前经度 AS 起点经度,
        前纬度 AS 起点纬度,
        [东经] AS 终点经度,
        [北纬] AS 终点纬度,
        前纬度 * PI() / 180 AS lat1_rad,
        [北纬] * PI() / 180 AS lat2_rad,
        (前纬度 - [北纬]) * PI() / 180 AS dlat,
        (前经度 - [东经]) * PI() / 180 AS dlng,
        DATEDIFF(SECOND, 前一时间, [数据采集时间]) AS 时间差_秒
    FROM OrderedPoints
    WHERE 前一时间 IS NOT NULL
)
INSERT INTO dbo.Oct_2025_Speed (
    车架号, 起点时间, 终点时间,
    起点经度, 起点纬度, 终点经度, 终点纬度,
    距离_公里, 时间差_秒, 速度_公里每小时
)
SELECT 
    [车架号],
    起点时间,
    终点时间,
    起点经度,
    起点纬度,
    终点经度,
    终点纬度,
    6371 * 2 * ASIN(SQRT(
        POWER(SIN(dlat / 2), 2) + 
        COS(lat1_rad) * COS(lat2_rad) * 
        POWER(SIN(dlng / 2), 2)
    )) AS 距离_公里,
    时间差_秒,
    CASE 
        WHEN 时间差_秒 > 0 
        THEN 6371 * 2 * ASIN(SQRT(
            POWER(SIN(dlat / 2), 2) + 
            COS(lat1_rad) * COS(lat2_rad) * 
            POWER(SIN(dlng / 2), 2)
        )) / (时间差_秒 / 3600.0)
        ELSE 0
    END AS 速度_公里每小时
FROM DistanceCalc
WHERE 时间差_秒 > 0 AND 时间差_秒 <= 1800;

PRINT '10月速度计算完成，记录数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 6. 速度分布统计
-- =====================================================
PRINT '6. 速度分布统计...';

SELECT '1月' AS 月份, COUNT(*) AS 总记录数,
    AVG(速度_公里每小时) AS 平均速度,
    MIN(速度_公里每小时) AS 最小速度,
    MAX(速度_公里每小时) AS 最大速度,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY 速度_公里每小时) OVER () AS 中位数速度
FROM dbo.Jan_2025_Speed
UNION ALL
SELECT '4月', COUNT(*), AVG(速度_公里每小时), MIN(速度_公里每小时), MAX(速度_公里每小时),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY 速度_公里每小时) OVER ()
FROM dbo.Apr_2025_Speed
UNION ALL
SELECT '7月', COUNT(*), AVG(速度_公里每小时), MIN(速度_公里每小时), MAX(速度_公里每小时),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY 速度_公里每小时) OVER ()
FROM dbo.Jul_2025_Speed
UNION ALL
SELECT '10月', COUNT(*), AVG(速度_公里每小时), MIN(速度_公里每小时), MAX(速度_公里每小时),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY 速度_公里每小时) OVER ()
FROM dbo.Oct_2025_Speed;
GO


PRINT '========================================';
PRINT '速度计算完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO