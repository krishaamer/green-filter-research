import os
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import font_manager as fm

script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, 'air.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')

# Load the data
air_quality_data = pd.read_csv(csv_path)
air_quality_data['Date'] = pd.to_datetime(air_quality_data['Date'])

# Set 'Date' as the index
time_series_data = air_quality_data.set_index('Date')

# Resample data by day and compute mean for daily trends
daily_data = time_series_data.resample('D').mean()

prop = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = prop.get_name()

# Plotting the trends for AQS and VOC
plt.figure(figsize=(15, 7))
plt.subplot(2, 1, 1)
plt.plot(daily_data.index, daily_data['AQS'], label='Daily Average AQS', color='green')
plt.title('Daily Average Air Quality Score (AQS)', fontproperties=prop)
plt.ylabel('AQS', fontproperties=prop)
plt.xlabel('Date', fontproperties=prop)
plt.legend(prop=prop)

plt.subplot(2, 1, 2)
plt.plot(daily_data.index, daily_data['VOC, ppm'], label='Daily Average VOC', color='red')
plt.title('Daily Average Volatile Organic Compounds (VOC)', fontproperties=prop)
plt.ylabel('VOC (ppm)', fontproperties=prop)
plt.xlabel('Date', fontproperties=prop)
plt.legend(prop=prop)

plt.tight_layout()
plt.show()
