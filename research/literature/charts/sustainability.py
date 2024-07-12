import warnings
warnings.filterwarnings("ignore")

import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
chinese_font = FontProperties(fname=font_path, size=12)

def biodiversity_chart():

    categories = ['Worldwide', 'Latin America', 'Freshwater Species']
    declines = [69, 94, 83]
    colors = ['#fb81cb', '#3ec7b8', '#fee566']

    plt.figure(figsize=(10, 6))
    bars = plt.bar(categories, declines, color=colors)

    for bar in bars:
        yval = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2, yval - 5, f"{yval}%", ha='center', va='bottom', fontproperties=chinese_font, fontsize=20, color='black')

    plt.show()