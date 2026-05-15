-- =====================================================
-- 01_create_tables.sql
-- 创建区域表、GPS表、统计结果表、速度表
-- =====================================================

USE [GPSData_WuHan];
GO

PRINT '========================================';
PRINT '开始创建所有表：' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO

-- =====================================================
-- 1. 零碳排放区表
-- =====================================================
IF OBJECT_ID('dbo.ZeroCarbonAreas', 'U') IS NOT NULL 
    DROP TABLE dbo.ZeroCarbonAreas;
GO

CREATE TABLE dbo.ZeroCarbonAreas (
    AreaID INT PRIMARY KEY,
    AreaCode NVARCHAR(10),
    AreaName NVARCHAR(100),
    Geometry GEOGRAPHY
);
GO

INSERT INTO dbo.ZeroCarbonAreas (AreaID, AreaCode, AreaName, Geometry) VALUES
(1, 'LT-01', '三阳路合围区域', geography::STGeomFromText('POLYGON((
    114.29805 30.58795, 114.29785 30.59235, 114.29765 30.59515,
    114.28925 30.59385, 114.28315 30.59255, 114.28295 30.58715,
    114.28265 30.58035, 114.28625 30.57945, 114.29135 30.57825,
    114.29575 30.57765, 114.29815 30.58415, 114.29805 30.58795
))', 4326)),

(2, 'LT-02', '东湖合围区域', geography::STGeomFromText('POLYGON((
    114.34145 30.54595, 114.35205 30.54535, 114.36475 30.54395,
    114.37605 30.54135, 114.37635 30.54745, 114.37615 30.55295,
    114.38225 30.55315, 114.39215 30.55285, 114.39965 30.55245,
    114.40555 30.55215, 114.40635 30.56055, 114.40445 30.56895,
    114.40065 30.57825, 114.39255 30.57865, 114.38615 30.57855,
    114.38345 30.57265, 114.37565 30.56875, 114.36395 30.55835,
    114.35845 30.55175, 114.35075 30.55115, 114.34145 30.54595
))', 4326)),

(3, 'LT-03', '澳门路合围区域', geography::STGeomFromText('POLYGON((
    114.29415 30.60535, 114.29435 30.60945, 114.29885 30.60925,
    114.30615 30.60895, 114.30485 30.60515, 114.30025 30.60495,
    114.29415 30.60535
))', 4326));
GO

CREATE SPATIAL INDEX SIndx_ZeroCarbonAreas ON dbo.ZeroCarbonAreas(Geometry)
WITH (SORT_IN_TEMPDB = ON);
GO

PRINT '零碳排放区表创建完成';
GO


-- =====================================================
-- 2. 绿色物流区表
-- =====================================================
IF OBJECT_ID('dbo.GreenLogisticsAreas', 'U') IS NOT NULL 
    DROP TABLE dbo.GreenLogisticsAreas;
GO

CREATE TABLE dbo.GreenLogisticsAreas (
    AreaID INT PRIMARY KEY,
    AreaCode NVARCHAR(10),
    AreaName NVARCHAR(100),
    Geometry GEOGRAPHY
);
GO

INSERT INTO dbo.GreenLogisticsAreas (AreaID, AreaCode, AreaName, Geometry) VALUES
(1, 'LS-01', '二环线内区域', geography::STGeomFromText('POLYGON((
    114.34615 30.62345, 114.35225 30.61615, 114.36315 30.60225,
    114.35615 30.58615, 114.34125 30.56415, 114.32215 30.55615,
    114.28615 30.55115, 114.24515 30.56615, 114.21515 30.58215,
    114.20515 30.60215, 114.23215 30.61515, 114.27615 30.62515,
    114.31215 30.62715, 114.34615 30.62345
))', 4326)),

(2, 'LS-02', '珞狮路-东湖合围区域', geography::STGeomFromText('POLYGON((
    114.34115 30.54815, 114.33815 30.53215, 114.32615 30.52415,
    114.35215 30.52115, 114.36815 30.52815, 114.38215 30.53615,
    114.39615 30.54615, 114.41015 30.55415, 114.40215 30.56715,
    114.38915 30.57115, 114.37615 30.57415, 114.36315 30.57715,
    114.35215 30.57115, 114.34115 30.54815
))', 4326)),

(3, 'LS-03', '杨春湖路-团结大道合围区域', geography::STGeomFromText('POLYGON((
    114.37425 30.60785, 114.37615 30.60525, 114.37965 30.60315,
    114.38425 30.59985, 114.39015 30.59725, 114.39455 30.59515,
    114.39725 30.59345, 114.39485 30.58975, 114.38975 30.58715,
    114.38455 30.58925, 114.37915 30.59265, 114.37555 30.59785,
    114.37325 30.60345, 114.37425 30.60785
))', 4326)),

(4, 'LS-04', '临江大道-建设八路合围区域', geography::STGeomFromText('POLYGON((
    114.38115 30.63215, 114.37515 30.62815, 114.36915 30.62515,
    114.36515 30.62715, 114.37215 30.63315, 114.38115 30.63215
))', 4326)),

(5, 'LS-05', '东西湖合围区域', geography::STGeomFromText('POLYGON((
    114.21515 30.64815, 114.21015 30.63515, 114.19515 30.63015,
    114.18815 30.62515, 114.18215 30.61815, 114.17515 30.61215,
    114.16815 30.60815, 114.18215 30.62215, 114.19815 30.63815,
    114.21515 30.64815
))', 4326)),

(6, 'LS-06', '光谷中心城区域', geography::STGeomFromText('POLYGON((
    114.41515 30.50815, 114.43215 30.50515, 114.43515 30.51515,
    114.44215 30.51815, 114.44515 30.51215, 114.44815 30.50815,
    114.45215 30.50215, 114.44815 30.49515, 114.43515 30.49215,
    114.42215 30.49615, 114.41515 30.50815
))', 4326)),

(7, 'LS-07', '江夏核心区', geography::STGeomFromText('POLYGON((
    114.31515 30.37515, 114.32215 30.36515, 114.33215 30.36215,
    114.34215 30.35815, 114.35215 30.35515, 114.35815 30.36215,
    114.34815 30.37215, 114.33515 30.37815, 114.31515 30.37515
))', 4326)),

(8, 'LS-08', '黄陂前川区域', geography::STGeomFromText('POLYGON((
    114.37515 30.88515, 114.37215 30.89215, 114.36815 30.89515,
    114.36515 30.89815, 114.36215 30.89515, 114.35815 30.89215,
    114.35515 30.88815, 114.35215 30.88515, 114.35815 30.88215,
    114.36515 30.88015, 114.37215 30.88215, 114.37515 30.88515
))', 4326)),

(9, 'LS-09', '康居路-和居路-宜居路区域', geography::STGeomFromText('POLYGON((
    114.38515 30.62515, 114.39215 30.62815, 114.39315 30.62515,
    114.38615 30.62215, 114.38815 30.61815, 114.39515 30.62215,
    114.38515 30.62515
))', 4326));
GO

CREATE SPATIAL INDEX SIndx_GreenAreas ON dbo.GreenLogisticsAreas(Geometry)
WITH (SORT_IN_TEMPDB = ON);
GO

PRINT '绿色物流区表创建完成';
GO


-- =====================================================
-- 3. 适度控制区表
-- =====================================================
IF OBJECT_ID('dbo.ModerateControlZones', 'U') IS NOT NULL 
    DROP TABLE dbo.ModerateControlZones;
GO

CREATE TABLE dbo.ModerateControlZones (
    ZoneID INT PRIMARY KEY,
    ZoneName NVARCHAR(100),
    ZoneType NVARCHAR(20),
    BigZoneCode NVARCHAR(10),
    BigZoneName NVARCHAR(50),
    Geometry GEOGRAPHY
);
GO

INSERT INTO dbo.ModerateControlZones (ZoneID, ZoneName, ZoneType, BigZoneCode, BigZoneName, Geometry) VALUES
(1, N'武汉长江大桥', N'桥梁', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('LINESTRING(114.28715 30.54515, 114.29515 30.55215)', 4326)),
(2, N'江汉桥', N'桥梁', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('LINESTRING(114.26515 30.56815, 114.26815 30.56215)', 4326)),
(3, N'武汉长江二桥', N'桥梁', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('LINESTRING(114.31515 30.61815, 114.32215 30.60515)', 4326)),
(4, N'长江隧道（汉口入口）', N'隧道', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('POINT(114.29515 30.58515)', 4326)),
(5, N'长江隧道（武昌出口）', N'隧道', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('POINT(114.30515 30.57515)', 4326)),
(6, N'东湖隧道', N'隧道', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('POINT(114.37515 30.56515)', 4326)),
(7, N'水果湖隧道', N'隧道', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('POINT(114.33515 30.55515)', 4326)),
(8, N'珞狮路隧道', N'隧道', N'SD-01', N'桥梁隧道控制区', geography::STGeomFromText('POINT(114.34515 30.52515)', 4326)),
(9, N'白沙洲长江大桥', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.23415 30.48515, 114.24415 30.48015)', 4326)),
(10, N'鹦鹉洲长江大桥', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.27215 30.52515, 114.28215 30.52815)', 4326)),
(11, N'二七长江大桥', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.31815 30.62815, 114.32615 30.62215)', 4326)),
(12, N'天兴洲长江大桥', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.35215 30.65815, 114.36215 30.65215)', 4326)),
(13, N'知音桥（江汉二桥）', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.22515 30.58215, 114.22815 30.57615)', 4326)),
(14, N'月湖桥（江汉三桥）', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.25515 30.56515, 114.25815 30.55815)', 4326)),
(15, N'晴川桥（江汉四桥）', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.28215 30.57215, 114.28515 30.56815)', 4326)),
(16, N'长丰桥（江汉五桥）', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.16594 30.60162, 114.17015 30.59515)', 4326)),
(17, N'古田桥（江汉六桥）', N'桥梁', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.19815 30.59815, 114.20215 30.59215)', 4326)),
(18, N'墨水湖大桥', N'跨湖桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.23215 30.54215, 114.23515 30.54515, 114.23815 30.54815)', 4326)),
(19, N'汉施立交主线桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.35015 30.67015, 114.36015 30.68015)', 4326)),
(20, N'和平大道立交主线桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.36015 30.63015, 114.37015 30.62015)', 4326)),
(21, N'和平-友谊高架桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.37015 30.62015, 114.38015 30.61015)', 4326)),
(22, N'友谊大道立交主线桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.38015 30.61015, 114.39015 30.60515)', 4326)),
(23, N'友谊-青化高架桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.39015 30.60515, 114.40015 30.60015)', 4326)),
(24, N'青化立交主线桥', N'高架桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('LINESTRING(114.40015 30.60015, 114.41015 30.59515)', 4326)),
(25, N'额头湾立交', N'立交桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('POINT(114.18515 30.61815)', 4326)),
(26, N'常青立交', N'立交桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('POINT(114.23515 30.63515)', 4326)),
(27, N'三金潭立交', N'立交桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('POINT(114.28515 30.65215)', 4326)),
(28, N'新武黄立交', N'立交桥', N'SD-02', N'其他桥梁高架区', geography::STGeomFromText('POINT(114.42515 30.50815)', 4326));
GO

CREATE SPATIAL INDEX SIndx_ModerateZones ON dbo.ModerateControlZones(Geometry)
WITH (SORT_IN_TEMPDB = ON);
GO

PRINT '适度控制区表创建完成';
GO


-- =====================================================
-- 4. GPS原始数据表（以4月为例，其他月份类似）
-- =====================================================
IF OBJECT_ID('dbo.Apr_2025', 'U') IS NOT NULL 
    DROP TABLE dbo.Apr_2025;
GO

CREATE TABLE dbo.Apr_2025 (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    定位状态编码 INT,
    定位状态说明 NVARCHAR(100),
    东经 FLOAT,
    北纬 FLOAT,
    企业ID INT,
    企业名称 NVARCHAR(100),
    数据采集时间 DATETIME,
    InZeroCarbon BIT NULL,
    InGreenLogistics BIT NULL,
    InModerateControl BIT NULL,
    ProcessedFlag TINYINT NULL,
    GeoPoint GEOGRAPHY NULL,
    零碳区代号 NVARCHAR(10) NULL,
    绿色区代号 NVARCHAR(10) NULL,
    适度区代号 NVARCHAR(10) NULL
);
GO

PRINT 'Apr_2025 表创建完成';
GO


-- 1月表
IF OBJECT_ID('dbo.Jan_2025', 'U') IS NOT NULL 
    DROP TABLE dbo.Jan_2025;
GO

CREATE TABLE dbo.Jan_2025 (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    定位状态编码 INT,
    定位状态说明 NVARCHAR(100),
    东经 FLOAT,
    北纬 FLOAT,
    企业ID INT,
    企业名称 NVARCHAR(100),
    数据采集时间 DATETIME,
    InZeroCarbon BIT NULL,
    InGreenLogistics BIT NULL,
    InModerateControl BIT NULL,
    ProcessedFlag TINYINT NULL,
    GeoPoint GEOGRAPHY NULL,
    零碳区代号 NVARCHAR(10) NULL,
    绿色区代号 NVARCHAR(10) NULL,
    适度区代号 NVARCHAR(10) NULL
);
GO

PRINT 'Jan_2025 表创建完成';
GO


-- 7月表
IF OBJECT_ID('dbo.July_2025', 'U') IS NOT NULL 
    DROP TABLE dbo.July_2025;
GO

CREATE TABLE dbo.July_2025 (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    定位状态编码 INT,
    定位状态说明 NVARCHAR(100),
    东经 FLOAT,
    北纬 FLOAT,
    企业ID INT,
    企业名称 NVARCHAR(100),
    数据采集时间 DATETIME,
    InZeroCarbon BIT NULL,
    InGreenLogistics BIT NULL,
    InModerateControl BIT NULL,
    ProcessedFlag TINYINT NULL,
    GeoPoint GEOGRAPHY NULL,
    零碳区代号 NVARCHAR(10) NULL,
    绿色区代号 NVARCHAR(10) NULL,
    适度区代号 NVARCHAR(10) NULL
);
GO

PRINT 'July_2025 表创建完成';
GO


-- 10月表
IF OBJECT_ID('dbo.Oct_2025', 'U') IS NOT NULL 
    DROP TABLE dbo.Oct_2025;
GO

CREATE TABLE dbo.Oct_2025 (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    定位状态编码 INT,
    定位状态说明 NVARCHAR(100),
    东经 FLOAT,
    北纬 FLOAT,
    企业ID INT,
    企业名称 NVARCHAR(100),
    数据采集时间 DATETIME,
    InZeroCarbon BIT NULL,
    InGreenLogistics BIT NULL,
    InModerateControl BIT NULL,
    ProcessedFlag TINYINT NULL,
    GeoPoint GEOGRAPHY NULL,
    零碳区代号 NVARCHAR(10) NULL,
    绿色区代号 NVARCHAR(10) NULL,
    适度区代号 NVARCHAR(10) NULL
);
GO

PRINT 'Oct_2025 表创建完成';
GO


-- =====================================================
-- 5. 道路长度表
-- =====================================================
IF OBJECT_ID('dbo.Road_Length', 'U') IS NOT NULL 
    DROP TABLE dbo.Road_Length;
GO

CREATE TABLE dbo.Road_Length (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    区域类型 NVARCHAR(20),
    区域代号 NVARCHAR(10),
    区域名称 NVARCHAR(100),
    道路长度_公里 FLOAT
);
GO

INSERT INTO dbo.Road_Length (区域类型, 区域代号, 区域名称, 道路长度_公里) VALUES
('零碳区', 'LT-01', '三阳路合围区域', 10.2),
('零碳区', 'LT-02', '东湖合围区域', 62.5),
('零碳区', 'LT-03', '澳门路合围区域', 5.4),
('绿色区', 'LS-01', '二环线内区域', 1224),
('绿色区', 'LS-02', '珞狮路-东湖合围区域', 111),
('绿色区', 'LS-03', '杨春湖路-团结大道合围区域', 17.6),
('绿色区', 'LS-04', '临江大道-建设八路合围区域', 28),
('绿色区', 'LS-05', '东西湖合围区域', 294),
('绿色区', 'LS-06', '光谷中心城区域', 68),
('绿色区', 'LS-07', '江夏核心区', 22.4),
('绿色区', 'LS-08', '黄陂前川区域', 19.6),
('绿色区', 'LS-09', '康居路-和居路-宜居路区域', 3.5),
('适度区', 'SD-01', '桥梁隧道控制区', 18.48),
('适度区', 'SD-02', '其他桥梁高架区', 35.78);
GO

PRINT '道路长度表创建完成';
GO


-- =====================================================
-- 6. 交通量统计结果表（以4月为例）
-- =====================================================
-- 瞬时交通量表
IF OBJECT_ID('dbo.TrafficStats_Apr_Timestamp', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Apr_Timestamp;
GO

CREATE TABLE dbo.TrafficStats_Apr_Timestamp (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    月份 NVARCHAR(10),
    时间戳 DATETIME,
    区域代号 NVARCHAR(10),
    交通量 INT,
    道路长度_公里 FLOAT,
    密度_辆每公里 FLOAT
);
GO

PRINT 'TrafficStats_Apr_Timestamp 表创建完成';
GO


-- 时段汇总表
IF OBJECT_ID('dbo.TrafficStats_Apr', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Apr;
GO

CREATE TABLE dbo.TrafficStats_Apr (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    统计日期 DATE,
    区域类型 NVARCHAR(20),
    全天总车次 INT,
    全天总车辆数 INT,
    早高峰车次 INT,
    早高峰车辆数 INT,
    晚高峰车次 INT,
    晚高峰车辆数 INT,
    上午平峰车次 INT,
    上午平峰车辆数 INT,
    午后平峰车次 INT,
    午后平峰车辆数 INT,
    傍晚平峰车次 INT,
    傍晚平峰车辆数 INT,
    夜间时段车次 INT,
    夜间时段车辆数 INT,
    上午配送车次 INT,
    上午配送车辆数 INT,
    下午配送车次 INT,
    下午配送车辆数 INT,
    记录时间 DATETIME DEFAULT GETDATE()
);
GO

PRINT 'TrafficStats_Apr 表创建完成';
GO


-- 1月瞬时交通量表
IF OBJECT_ID('dbo.TrafficStats_Jan_Timestamp', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Jan_Timestamp;
GO

CREATE TABLE dbo.TrafficStats_Jan_Timestamp (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    月份 NVARCHAR(10),
    时间戳 DATETIME,
    区域代号 NVARCHAR(10),
    交通量 INT,
    道路长度_公里 FLOAT,
    密度_辆每公里 FLOAT
);
GO

PRINT 'TrafficStats_Jan_Timestamp 表创建完成';
GO


-- 1月时段汇总表
IF OBJECT_ID('dbo.TrafficStats_Jan', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Jan;
GO

CREATE TABLE dbo.TrafficStats_Jan (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    统计日期 DATE,
    区域类型 NVARCHAR(20),
    全天总车次 INT,
    全天总车辆数 INT,
    早高峰车次 INT,
    早高峰车辆数 INT,
    晚高峰车次 INT,
    晚高峰车辆数 INT,
    上午平峰车次 INT,
    上午平峰车辆数 INT,
    午后平峰车次 INT,
    午后平峰车辆数 INT,
    傍晚平峰车次 INT,
    傍晚平峰车辆数 INT,
    夜间时段车次 INT,
    夜间时段车辆数 INT,
    上午配送车次 INT,
    上午配送车辆数 INT,
    下午配送车次 INT,
    下午配送车辆数 INT,
    记录时间 DATETIME DEFAULT GETDATE()
);
GO

PRINT 'TrafficStats_Jan 表创建完成';
GO


-- 7月瞬时交通量表
IF OBJECT_ID('dbo.TrafficStats_Jul_Timestamp', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Jul_Timestamp;
GO

CREATE TABLE dbo.TrafficStats_Jul_Timestamp (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    月份 NVARCHAR(10),
    时间戳 DATETIME,
    区域代号 NVARCHAR(10),
    交通量 INT,
    道路长度_公里 FLOAT,
    密度_辆每公里 FLOAT
);
GO

PRINT 'TrafficStats_Jul_Timestamp 表创建完成';
GO


-- 7月时段汇总表
IF OBJECT_ID('dbo.TrafficStats_Jul', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Jul;
GO

CREATE TABLE dbo.TrafficStats_Jul (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    统计日期 DATE,
    区域类型 NVARCHAR(20),
    全天总车次 INT,
    全天总车辆数 INT,
    早高峰车次 INT,
    早高峰车辆数 INT,
    晚高峰车次 INT,
    晚高峰车辆数 INT,
    上午平峰车次 INT,
    上午平峰车辆数 INT,
    午后平峰车次 INT,
    午后平峰车辆数 INT,
    傍晚平峰车次 INT,
    傍晚平峰车辆数 INT,
    夜间时段车次 INT,
    夜间时段车辆数 INT,
    上午配送车次 INT,
    上午配送车辆数 INT,
    下午配送车次 INT,
    下午配送车辆数 INT,
    记录时间 DATETIME DEFAULT GETDATE()
);
GO

PRINT 'TrafficStats_Jul 表创建完成';
GO


-- 10月瞬时交通量表
IF OBJECT_ID('dbo.TrafficStats_Oct_Timestamp', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Oct_Timestamp;
GO

CREATE TABLE dbo.TrafficStats_Oct_Timestamp (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    月份 NVARCHAR(10),
    时间戳 DATETIME,
    区域代号 NVARCHAR(10),
    交通量 INT,
    道路长度_公里 FLOAT,
    密度_辆每公里 FLOAT
);
GO

PRINT 'TrafficStats_Oct_Timestamp 表创建完成';
GO


-- 10月时段汇总表
IF OBJECT_ID('dbo.TrafficStats_Oct', 'U') IS NOT NULL 
    DROP TABLE dbo.TrafficStats_Oct;
GO

CREATE TABLE dbo.TrafficStats_Oct (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    统计日期 DATE,
    区域类型 NVARCHAR(20),
    全天总车次 INT,
    全天总车辆数 INT,
    早高峰车次 INT,
    早高峰车辆数 INT,
    晚高峰车次 INT,
    晚高峰车辆数 INT,
    上午平峰车次 INT,
    上午平峰车辆数 INT,
    午后平峰车次 INT,
    午后平峰车辆数 INT,
    傍晚平峰车次 INT,
    傍晚平峰车辆数 INT,
    夜间时段车次 INT,
    夜间时段车辆数 INT,
    上午配送车次 INT,
    上午配送车辆数 INT,
    下午配送车次 INT,
    下午配送车辆数 INT,
    记录时间 DATETIME DEFAULT GETDATE()
);
GO

PRINT 'TrafficStats_Oct 表创建完成';
GO


-- =====================================================
-- 7. 速度计算表（分月）
-- =====================================================
IF OBJECT_ID('dbo.Apr_2025_Speed', 'U') IS NOT NULL 
    DROP TABLE dbo.Apr_2025_Speed;
GO

CREATE TABLE dbo.Apr_2025_Speed (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    起点时间 DATETIME,
    终点时间 DATETIME,
    起点经度 FLOAT,
    起点纬度 FLOAT,
    终点经度 FLOAT,
    终点纬度 FLOAT,
    距离_公里 FLOAT,
    时间差_秒 FLOAT,
    速度_公里每小时 FLOAT
);
GO

PRINT 'Apr_2025_Speed 表创建完成';
GO


IF OBJECT_ID('dbo.Jan_2025_Speed', 'U') IS NOT NULL 
    DROP TABLE dbo.Jan_2025_Speed;
GO

CREATE TABLE dbo.Jan_2025_Speed (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    起点时间 DATETIME,
    终点时间 DATETIME,
    起点经度 FLOAT,
    起点纬度 FLOAT,
    终点经度 FLOAT,
    终点纬度 FLOAT,
    距离_公里 FLOAT,
    时间差_秒 FLOAT,
    速度_公里每小时 FLOAT
);
GO

PRINT 'Jan_2025_Speed 表创建完成';
GO


IF OBJECT_ID('dbo.Jul_2025_Speed', 'U') IS NOT NULL 
    DROP TABLE dbo.Jul_2025_Speed;
GO

CREATE TABLE dbo.Jul_2025_Speed (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    起点时间 DATETIME,
    终点时间 DATETIME,
    起点经度 FLOAT,
    起点纬度 FLOAT,
    终点经度 FLOAT,
    终点纬度 FLOAT,
    距离_公里 FLOAT,
    时间差_秒 FLOAT,
    速度_公里每小时 FLOAT
);
GO

PRINT 'Jul_2025_Speed 表创建完成';
GO


IF OBJECT_ID('dbo.Oct_2025_Speed', 'U') IS NOT NULL 
    DROP TABLE dbo.Oct_2025_Speed;
GO

CREATE TABLE dbo.Oct_2025_Speed (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    车架号 NVARCHAR(50),
    起点时间 DATETIME,
    终点时间 DATETIME,
    起点经度 FLOAT,
    起点纬度 FLOAT,
    终点经度 FLOAT,
    终点纬度 FLOAT,
    距离_公里 FLOAT,
    时间差_秒 FLOAT,
    速度_公里每小时 FLOAT
);
GO

PRINT 'Oct_2025_Speed 表创建完成';
GO


-- =====================================================
-- 8. 进度日志表
-- =====================================================
IF OBJECT_ID('dbo.AreaJudge_Log', 'U') IS NOT NULL 
    DROP TABLE dbo.AreaJudge_Log;
GO

CREATE TABLE dbo.AreaJudge_Log (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),
    AreaType NVARCHAR(20),
    StartTime DATETIME,
    EndTime DATETIME,
    RowsUpdated BIGINT,
    Status NVARCHAR(20)
);
GO

PRINT 'AreaJudge_Log 表创建完成';
GO


PRINT '========================================';
PRINT '所有表创建完成！' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '========================================';
GO