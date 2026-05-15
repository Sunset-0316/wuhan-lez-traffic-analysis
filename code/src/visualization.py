"""
visualization.py
可视化脚本（热力图、轨迹图、交通量分布图）
"""

import pandas as pd
import geopandas as gpd
import folium
from folium.plugins import HeatMap
import matplotlib.pyplot as plt
import seaborn as sns

# =====================================================
# 1. 加载数据
# =====================================================
def load_traffic_data(file_path):
    """加载交通量数据"""
    df = pd.read_csv(file_path)
    df['时间戳'] = pd.to_datetime(df['时间戳'])
    return df

def load_gps_data(file_path, nrows=None):
    """加载GPS轨迹数据（可选抽样）"""
    df = pd.read_csv(file_path, nrows=nrows)
    return df

# =====================================================
# 2. 热力图（轨迹点分布）
# =====================================================
def create_heatmap(gps_df, output_file='heatmap.html'):
    """创建轨迹点热力图"""
    # 创建地图
    m = folium.Map(location=[30.57, 114.30], zoom_start=12)
    
    # 准备热力图数据
    heat_data = [[row['北纬'], row['东经']] for _, row in gps_df.iterrows()]
    
    # 添加热力图层
    HeatMap(heat_data, radius=10, blur=15, max_zoom=1).add_to(m)
    
    # 保存
    m.save(output_file)
    print(f"热力图已保存到 {output_file}")

# =====================================================
# 3. 轨迹图（单辆车）
# =====================================================
def plot_trajectory(gps_df, vehicle_id, output_file='trajectory.html'):
    """绘制单辆车的轨迹"""
    # 筛选车辆
    vehicle_traj = gps_df[gps_df['车架号'] == vehicle_id].sort_values('数据采集时间')
    
    if len(vehicle_traj) == 0:
        print(f"未找到车辆 {vehicle_id}")
        return
    
    # 创建地图
    center_lat = vehicle_traj['北纬'].mean()
    center_lon = vehicle_traj['东经'].mean()
    m = folium.Map(location=[center_lat, center_lon], zoom_start=13)
    
    # 添加轨迹线
    points = list(zip(vehicle_traj['北纬'], vehicle_traj['东经']))
    folium.PolyLine(points, color='blue', weight=3, opacity=0.8).add_to(m)
    
    # 添加起点和终点标记
    start = points[0]
    end = points[-1]
    folium.Marker(start, popup='起点', icon=folium.Icon(color='green')).add_to(m)
    folium.Marker(end, popup='终点', icon=folium.Icon(color='red')).add_to(m)
    
    m.save(output_file)
    print(f"轨迹图已保存到 {output_file}")

# =====================================================
# 4. 交通量时间序列图
# =====================================================
def plot_traffic_volume(traffic_df, area_code, output_file='traffic_volume.png'):
    """绘制交通量时间序列"""
    # 筛选区域
    area_traffic = traffic_df[traffic_df['区域代号'] == area_code].copy()
    area_traffic.set_index('时间戳', inplace=True)
    
    # 绘图
    plt.figure(figsize=(14, 6))
    plt.plot(area_traffic.index, area_traffic['交通量'], linewidth=1)
    plt.title(f'交通量时间序列 - {area_code}')
    plt.xlabel('时间')
    plt.ylabel('交通量（辆/秒）')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(output_file, dpi=150)
    plt.show()
    print(f"交通量图已保存到 {output_file}")

# =====================================================
# 5. 各区域交通量柱状图
# =====================================================
def plot_volume_by_area(traffic_df, output_file='volume_by_area.png'):
    """绘制各区域交通量柱状图"""
    # 汇总
    area_volume = traffic_df.groupby('区域代号')['交通量'].sum().sort_values(ascending=False)
    
    # 绘图
    plt.figure(figsize=(12, 6))
    area_volume.plot(kind='bar')
    plt.title('各区域总交通量')
    plt.xlabel('区域代号')
    plt.ylabel('总交通量（辆）')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(output_file, dpi=150)
    plt.show()
    print(f"柱状图已保存到 {output_file}")

# =====================================================
# 6. 时段交通量堆叠图
# =====================================================
def plot_hourly_volume(traffic_df, output_file='hourly_volume.png'):
    """绘制时段交通量堆叠图"""
    # 提取小时
    traffic_df['小时'] = pd.to_datetime(traffic_df['时间戳']).dt.hour
    
    # 按小时和区域汇总
    hourly = traffic_df.groupby(['小时', '区域代号'])['交通量'].sum().unstack()
    
    # 绘图
    plt.figure(figsize=(14, 6))
    hourly.plot(kind='area', stacked=True, alpha=0.7)
    plt.title('各小时交通量分布')
    plt.xlabel('小时')
    plt.ylabel('交通量（辆）')
    plt.legend(title='区域代号', bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.tight_layout()
    plt.savefig(output_file, dpi=150)
    plt.show()
    print(f"时段图已保存到 {output_file}")

# =====================================================
# 7. 速度分布箱线图
# =====================================================
def plot_speed_distribution(speed_df, output_file='speed_distribution.png'):
    """绘制速度分布箱线图"""
    plt.figure(figsize=(10, 6))
    
    # 箱线图
    speed_df.boxplot(column='速度_公里每小时', by='区域类型')
    plt.title('各区域速度分布')
    plt.suptitle('')
    plt.xlabel('区域类型')
    plt.ylabel('速度（公里/小时）')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(output_file, dpi=150)
    plt.show()
    print(f"速度分布图已保存到 {output_file}")

# =====================================================
# 8. 密度热力图
# =====================================================
def plot_density_heatmap(traffic_df, output_file='density_heatmap.png'):
    """绘制密度热力图"""
    # 计算平均密度
    density = traffic_df.groupby('区域代号')['密度_辆每公里'].mean().sort_values(ascending=False)
    
    # 绘图
    plt.figure(figsize=(10, 8))
    sns.heatmap(density.to_frame(), annot=True, fmt='.2f', cmap='YlOrRd', cbar_kws={'label': '密度（辆/公里）'})
    plt.title('各区域平均交通密度')
    plt.xlabel('区域代号')
    plt.tight_layout()
    plt.savefig(output_file, dpi=150)
    plt.show()
    print(f"密度热力图已保存到 {output_file}")

# =====================================================
# 9. 添加政策区域边界到地图
# =====================================================
def add_zones_to_map(m, zones_gdf):
    """在地图上添加政策区域边界"""
    for _, row in zones_gdf.iterrows():
        # 获取几何
        geom = row['geometry']
        area_code = row['AreaCode']
        
        # 添加到地图
        folium.GeoJson(
            geom,
            name=area_code,
            style_function=lambda x: {
                'fillColor': 'red',
                'color': 'red',
                'weight': 2,
                'fillOpacity': 0.1
            }
        ).add_to(m)
    
    return m

# =====================================================
# 主函数
# =====================================================
def main():
    print("开始可视化分析...")
    
    # 加载数据
    # traffic_df = load_traffic_data('traffic_data.csv')
    # gps_df = load_gps_data('gps_sample.csv', nrows=10000)
    # speed_df = pd.read_csv('speed_data.csv')
    
    # 创建热力图
    # create_heatmap(gps_df, 'heatmap.html')
    
    # 绘制交通量图
    # plot_traffic_volume(traffic_df, 'LT-01', 'lt01_traffic.png')
    
    # 绘制柱状图
    # plot_volume_by_area(traffic_df, 'volume_by_area.png')
    
    print("可视化完成！")

if __name__ == "__main__":
    main()