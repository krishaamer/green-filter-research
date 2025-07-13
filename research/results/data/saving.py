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

def saving_to_investing_sankey():

    saving_col = "你/妳會經常存錢嗎？"
    invest_col = "你/妳覺得目前有任何投資嗎？"
    df_filtered = df[[saving_col, invest_col]].dropna()
    df_filtered = df_filtered[df_filtered[saving_col].astype(str).str.isdigit()]
    df_filtered[saving_col] = df_filtered[saving_col].astype(int)
    df_filtered['invest_bin'] = df_filtered[invest_col].apply(lambda x: 'Yes' if str(x).strip() == '有' else 'No')

    # Compute counts for each saving level
    levels = [1, 2, 3, 4, 5]
    counts = df_filtered.groupby([saving_col, 'invest_bin']).size().unstack(fill_value=0)

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


def saving_to_investing_bars():

    saving_col = "你/妳會經常存錢嗎？"
    invest_col = "你/妳覺得目前有任何投資嗎？"
    df_filtered = df[[saving_col, invest_col]].dropna()
    df_filtered = df_filtered[df_filtered[saving_col].astype(str).str.isdigit()]
    df_filtered[saving_col] = df_filtered[saving_col].astype(int)
    df_filtered['invest_bin'] = df_filtered[invest_col].apply(lambda x: 'Yes' if str(x).strip() == '有' else 'No')

    df_filtered[saving_col] = df_filtered[saving_col].astype(int)
    df_filtered["invest_bin"] = df_filtered[invest_col].apply(
        lambda x: "Yes" if str(x).strip() == "有" else "No"
    )

    counts = (
        df_filtered.groupby([saving_col, "invest_bin"])
        .size()
        .unstack(fill_value=0)
        .reindex(range(1, 6))
        .fillna(0)
        .astype(int)
    )

    # ---------- Plot ----------
    levels     = counts.index
    yes_counts = counts["Yes"]
    no_counts  = counts["No"]

    plt.figure(figsize=(8, 6), dpi=100)
    plt.bar(levels, yes_counts, label="Already invests")
    plt.bar(levels, no_counts, bottom=yes_counts, label="Not yet investing")

    # counts inside bars
    for idx, lvl in enumerate(levels):
        plt.text(
            lvl, yes_counts.iloc[idx] / 2,
            str(yes_counts.iloc[idx]),
            ha="center", va="center", fontsize=9
        )
        plt.text(
            lvl,
            yes_counts.iloc[idx] + no_counts.iloc[idx] / 2,
            str(no_counts.iloc[idx]),
            ha="center", va="center", fontsize=9
        ) 

    plt.xlabel("Saving frequency level (1 = rarely, 5 = always)")
    plt.ylabel("Number of students")

    plt.title("How saving frequency relates to having investments")
    plt.xticks(levels)
    plt.legend()
    plt.tight_layout()
    plt.show()
