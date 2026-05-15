-- =====================================================
-- 07_density_calculation.sql
-- 交通密度计算（交通量 / 道路长度）
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始交通密度计算：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO


-- =====================================================
-- 1. 更新道路长度到瞬时交通量表
-- =====================================================
PRINT '1. 更新道路长度...';

-- 1月
UPDATE t
SET 道路长度_公里 = r.道路长度_公里
FROM dbo.TrafficStats_Jan_Timestamp t
INNER JOIN dbo.Road_Length r ON t.区域代号 = r.区域代号;
PRINT '1月道路长度更新完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 4月
UPDATE t
SET 道路长度_公里 = r.道路长度_公里
FROM dbo.TrafficStats_Apr_Timestamp t
INNER JOIN dbo.Road_Length r ON t.区域代号 = r.区域代号;
PRINT '4月道路长度更新完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 7月
UPDATE t
SET 道路长度_公里 = r.道路长度_公里
FROM dbo.TrafficStats_Jul_Timestamp t
INNER JOIN dbo.Road_Length r ON t.区域代号 = r.区域代号;
PRINT '7月道路长度更新完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 10月
UPDATE t
SET 道路长度_公里 = r.道路长度_公里
FROM dbo.TrafficStats_Oct_Timestamp t
INNER JOIN dbo.Road_Length r ON t.区域代号 = r.区域代号;
PRINT '10月道路长度更新完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 2. 计算密度
-- =====================================================
PRINT '2. 计算密度...';

-- 1月
UPDATE dbo.TrafficStats_Jan_Timestamp
SET 密度_辆每公里 = 交通量 / 道路长度_公里
WHERE 道路长度_公里 IS NOT NULL AND 道路长度_公里 > 0;
PRINT '1月密度计算完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 4月
UPDATE dbo.TrafficStats_Apr_Timestamp
SET 密度_辆每公里 = 交通量 / 道路长度_公里
WHERE 道路长度_公里 IS NOT NULL AND 道路长度_公里 > 0;
PRINT '4月密度计算完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 7月
UPDATE dbo.TrafficStats_Jul_Timestamp
SET 密度_辆每公里 = 交通量 / 道路长度_公里
WHERE 道路长度_公里 IS NOT NULL AND 道路长度_公里 > 0;
PRINT '7月密度计算完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);

-- 10月
UPDATE dbo.TrafficStats_Oct_Timestamp
SET 密度_辆每公里 = 交通量 / 道路长度_公里
WHERE 道路长度_公里 IS NOT NULL AND 道路长度_公里 > 0;
PRINT '10月密度计算完成，影响行数：' + CAST(@@ROWCOUNT AS VARCHAR);
GO


-- =====================================================
-- 3. 密度统计
-- =====================================================
PRINT '3. 密度统计...';

SELECT '1月' AS 月份,
    区域代号,
    AVG(密度_辆每公里) AS 平均密度,
    MIN(密度_辆每公里) AS 最小密度,
    MAX(密度_辆每公里) AS 最大密度,
    COUNT(*) AS 记录数
FROM dbo.TrafficStats_Jan_Timestamp
WHERE 密度_辆每公里 IS NOT NULL
GROUP BY 区域代号
ORDER BY 平均密度 DESC;
GO

SELECT '4月' AS 月份,
    区域代号,
    AVG(密度_辆每公里) AS 平均密度,
    MIN(密度_辆每公里) AS 最小密度,
    MAX(密度_辆每公里) AS 最大密度,
    COUNT(*) AS 记录数
FROM dbo.TrafficStats_Apr_Timestamp
WHERE 密度_辆每公里 IS NOT NULL
GROUP BY 区域代号
ORDER BY 平均密度 DESC;
GO

SELECT '7月' AS 月份,
    区域代号,
    AVG(密度_辆每公里) AS 平均密度,
    MIN(密度_辆每公里) AS 最小密度,
    MAX(密度_辆每公里) AS 最大密度,
    COUNT(*) AS 记录数
FROM dbo.TrafficStats_Jul_Timestamp
WHERE 密度_辆每公里 IS NOT NULL
GROUP BY 区域代号
ORDER BY 平均密度 DESC;
GO

SELECT '10月' AS 月份,
    区域代号,
    AVG(密度_辆每公里) AS 平均密度,
    MIN(密度_辆每公里) AS 最小密度,
    MAX(密度_辆每公里) AS 最大密度,
    COUNT(*) AS 记录数
FROM dbo.TrafficStats_Oct_Timestamp
WHERE 密度_辆每公里 IS NOT NULL
GROUP BY 区域代号
ORDER BY 平均密度 DESC;
GO


PRINT '========================================';
PRINT '交通密度计算完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO