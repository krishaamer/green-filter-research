import warnings
warnings.filterwarnings("ignore")

import pandas as pd
from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, 'clean.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
df = pd.read_csv(csv_path)
chinese_font = FontProperties(fname=font_path, size=12)

def ecosystem_sensitivity():

    # Field related to ecosystem sensitivity to environmental degradation
    ecosystem_field = "你/妳覺得如何依照生態系對環境惡化的敏感度來排名？"

    # Summarize the data
    ecosystem_data = df[ecosystem_field].value_counts().head(20)  # Adjust the number as needed
    
    # Plot the data
    plt.figure(figsize=(10, 6))
    ecosystem_data.plot(kind='bar', color='forestgreen')
    plt.title('Ecosystem Sensitivity to Environmental Degradation', fontproperties=chinese_font)
    plt.xlabel('Sensitivity Ranking', fontproperties=chinese_font)
    plt.ylabel('Number of Responses', fontproperties=chinese_font)
    plt.xticks(rotation=45, ha='right', fontproperties=chinese_font)
    plt.tight_layout()
    plt.show()