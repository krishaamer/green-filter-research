import warnings
warnings.filterwarnings("ignore")

from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, 'clean.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
df = pd.read_csv(csv_path)
chinese_font = FontProperties(fname=font_path, size=12)

def boycott_count():
    # Count the number of people who have invested and who have not
    boycott_count = df["你/妳有沒有抵制過某公司？"].value_counts().reset_index()
    boycott_count.columns = ['Boycott', 'Count']

    # Create a bar chart using seaborn
    plt.figure(figsize=(10, 6))
    sns.barplot(x='Boycott', y='Count', data=boycott_count, palette='viridis')
    ax = plt.gca()  # Get the current Axes instance on the current figure matching the given keyword args, or create one.
    ax.set_xticklabels(ax.get_xticklabels(), fontproperties=chinese_font)

    # Add labels and title
    plt.xlabel('Have you ever boycotted a company?', fontsize=12, fontproperties=chinese_font)
    plt.ylabel('Count', fontsize=12, fontproperties=chinese_font)
    plt.title("Number of People Who Have/Haven't Boycotted a Company", fontsize=16, fontproperties=chinese_font)

    # Display values on the bars
    for index, value in enumerate(boycott_count['Count']):
        plt.text(index, value, str(value), ha='center', va='bottom', fontproperties=chinese_font)

    plt.show()


def why_boycott():
    # Count the reasons for boycotting
    boycott_reasons = df["為什麼抵制？"].value_counts()
    summary = boycott_reasons.sort_values(ascending=False).to_frame()
    summary.reset_index(inplace=True)
    summary.columns = ['Reason', 'Count']

    return summary


def trusted_brands():

    trusted_brands = df["你/妳有信任的品牌嗎？"].value_counts()
    no_brand_responses = ["無", "沒有", "沒有特別", "🈚️", "目前沒有", "No", "沒", "沒有特別關注", "沒有特別信任的", "不知道", "無特別選擇", "目前沒有完全信任的", "沒有特定的", "沒有特定", "沒有特別研究", "目前沒有特別關注的品牌","N", "none", "無特別", "目前無", "沒有特別想到", "沒有固定的", "x", "沒在買", "nope", "一時想不到…", "沒有特別注意", "無特別的品牌", "無絕對信任的品牌", "不確定你說的範圍", "還沒有"]
    no_brand_count = trusted_brands[no_brand_responses].sum()
    trusted_brands_combined = trusted_brands.drop(no_brand_responses)
    trusted_brands_combined['No trusted brand'] = no_brand_count

    have_but_not_specified = ["有", "Yes", "應該有"]
    have_but_not_specified_count = trusted_brands_combined[have_but_not_specified].sum()
    trusted_brands_combined = trusted_brands_combined.drop(have_but_not_specified)
    trusted_brands_combined['Have but not specified'] = have_but_not_specified_count

    summary_df = trusted_brands_combined.reset_index()
    summary_df.columns = ['Brand', 'Count']
    summary_df = summary_df.sort_values('Count', ascending=False)

    return summary_df


def visualize_shopping_data():
    # Shopping fields with their corresponding titles
    shopping_fields = {
        "你/妳會買哪一種番茄？": "Which Type of Tomatoes Would You Buy?",
        "你/妳買哪種牛奶？": "Which Type of Milk Would You Buy?",
        "你/妳會買哪種雞蛋？": "Which Type of Eggs Would You Buy?"
    }
    
    # Create a figure and a set of subplots
    _, axes = plt.subplots(len(shopping_fields), 1, figsize=(10, 6 * len(shopping_fields)))
    
    # If there's only one field to plot, axes will not be an array, so we wrap it in a list
    if not isinstance(axes, np.ndarray):
        axes = [axes]
    
    for ax, (column_name, title) in zip(axes, shopping_fields.items()):
        # Summarize the data
        data = df[column_name].value_counts().head(20)  # Adjust the number as needed
        
        # Plot the data
        data.plot(kind='bar', color='skyblue', ax=ax, fontsize=12)
        ax.set_title(title, fontproperties=chinese_font)
        ax.set_xlabel('Options', fontproperties=chinese_font)
        ax.set_ylabel('Count', fontproperties=chinese_font)

        # Set the properties for the x-tick labels
        ax.set_xticklabels(data.index, rotation=45, ha='right', fontproperties=chinese_font)
    
    plt.tight_layout()
    plt.show()