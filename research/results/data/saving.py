import warnings
warnings.filterwarnings("ignore")

import pandas as pd
from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt
from matplotlib.sankey import Sankey

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, 'clean.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
df = pd.read_csv(csv_path)
chinese_font = FontProperties(fname=font_path, size=12)


def saving_to_investing():
    saving_col = "你/妳會經常存錢嗎？"
    invest_col = "你/妳覺得目前有任何投資嗎？"
    df = df[[saving_col, invest_col]].dropna()
    df = df[df[saving_col].astype(str).str.isdigit()]
    df[saving_col] = df[saving_col].astype(int)
    df['invest_bin'] = df[invest_col].apply(lambda x: 'Yes' if str(x).strip() == '有' else 'No')

    # Compute counts for each saving level
    levels = [1, 2, 3, 4, 5]
    counts = df.groupby([saving_col, 'invest_bin']).size().unstack(fill_value=0)

    # Palette matched earlier
    palette = ['#8bc9d1', '#d5c374', '#be7cb1', '#c5a17f', '#79b880']

    # Draw static Sankey with clear labels
    fig, ax = plt.subplots(figsize=(8, 6))
    sankey = Sankey(ax=ax, unit=None, gap=0.4)

    for idx, lvl in enumerate(levels):
        yes = counts.loc[lvl, 'Yes']
        no = counts.loc[lvl, 'No']
        total = yes + no
        sankey.add(
            flows=[-total, yes, no],
            labels=[f'Level {lvl} savers\n(total {total})', f'Yes {yes}', f'No {no}'],
            orientations=[0, 1, -1],
            pathlengths=[0.3, 0.3, 0.3],
            trunklength=1.0,
            facecolor=palette[idx],
            alpha=0.7
        )

    sankey.finish()
    ax.set_title('Savings Frequency → Investment Status', fontsize=14)
    ax.axis('off')
    plt.tight_layout()
    plt.show()