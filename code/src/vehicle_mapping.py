"""
vehicle_mapping.py
车架号与车辆类型映射（车300API）
"""

import requests
import pandas as pd
import time

# =====================================================
# 配置
# =====================================================
# 车300API配置（需要注册获取）
API_KEY = "YOUR_API_KEY"  # 替换为实际的API Key
API_URL = "https://api.che300.com/vin/query"

# 输入输出文件
INPUT_FILE = "unique_vin.csv"   # 唯一车架号列表
OUTPUT_FILE = "vehicle_mapping.csv"

# =====================================================
# 读取车架号列表
# =====================================================
def load_vin_list(file_path):
    """读取车架号列表"""
    df = pd.read_csv(file_path)
    return df['vin'].tolist()

# =====================================================
# 调用车300API查询车辆信息
# =====================================================
def query_vehicle_info(vin, retry=3):
    """查询单个车架号的车辆信息"""
    params = {
        'key': API_KEY,
        'vin': vin
    }
    
    for i in range(retry):
        try:
            response = requests.get(API_URL, params=params, timeout=10)
            if response.status_code == 200:
                data = response.json()
                if data.get('code') == 0:
                    return {
                        'vin': vin,
                        'brand': data.get('brand', ''),
                        'model': data.get('model', ''),
                        'fuel_type': data.get('fuel_type', ''),
                        'emission_standard': data.get('emission_standard', ''),
                        'vehicle_class': data.get('vehicle_class', ''),
                        'length_m': data.get('length', None),
                        'gross_mass_t': data.get('gross_mass', None),
                        'status': 'success'
                    }
                else:
                    return {
                        'vin': vin,
                        'status': 'failed',
                        'error': data.get('message', 'Unknown error')
                    }
            else:
                time.sleep(1)
        except Exception as e:
            print(f"Error querying {vin}: {e}")
            time.sleep(2)
    
    return {'vin': vin, 'status': 'failed', 'error': 'Max retries exceeded'}

# =====================================================
# 批量查询
# =====================================================
def batch_query(vin_list, batch_size=10, delay=1):
    """批量查询车辆信息"""
    results = []
    total = len(vin_list)
    
    for i, vin in enumerate(vin_list):
        print(f"Processing {i+1}/{total}: {vin}")
        result = query_vehicle_info(vin)
        results.append(result)
        
        # 每batch_size条暂停一下
        if (i + 1) % batch_size == 0:
            time.sleep(delay)
    
    return results

# =====================================================
# 保存结果
# =====================================================
def save_results(results, output_file):
    """保存查询结果"""
    df = pd.DataFrame(results)
    df.to_csv(output_file, index=False, encoding='utf-8')
    print(f"已保存到 {output_file}")
    
    # 统计
    success_count = len(df[df['status'] == 'success'])
    failed_count = len(df[df['status'] == 'failed'])
    print(f"成功: {success_count}, 失败: {failed_count}")

# =====================================================
# 主函数
# =====================================================
def main():
    print("开始车架号与车型映射...")
    
    # 1. 读取车架号
    vin_list = load_vin_list(INPUT_FILE)
    print(f"共 {len(vin_list)} 个唯一车架号")
    
    # 2. 批量查询
    results = batch_query(vin_list, batch_size=10, delay=1)
    
    # 3. 保存结果
    save_results(results, OUTPUT_FILE)
    
    print("完成！")

if __name__ == "__main__":
    main()