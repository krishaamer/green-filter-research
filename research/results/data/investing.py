import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

import pandas as pd
from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('data/clean.csv') 
chinese_font = FontProperties(fname='data/fonts/notosans.ttf', size=12)

def investment_count():
    # Count the number of people who have invested and who have not
    investment_count = df["你/妳覺得目前有任何投資嗎？"].value_counts().reset_index()
    investment_count.columns = ['Investment', 'Count']

    # Create a bar chart using seaborn
    plt.figure(figsize=(10, 6))
    barplot = sns.barplot(x='Investment', y='Count', data=investment_count, palette='viridis')
    ax = plt.gca()  # Get the current Axes instance on the current figure matching the given keyword args, or create one.

    tick_positions = range(len(investment_count['Investment']))  # Assuming 'Investment' is the correct column
    ax.set_xticks(tick_positions)  # This explicitly sets tick positions
    ax.set_xticklabels(investment_count['Investment'], fontproperties=chinese_font)  # Then, set custom labels

    # Add labels and title
    plt.xlabel('Do you currently have any investment?', fontsize=12, fontproperties=chinese_font)
    plt.ylabel('Count', fontsize=12, fontproperties=chinese_font)
    plt.title("Number of People Who Have/Haven't Invested", fontsize=16, fontproperties=chinese_font)

    # Display values on the bars
    for index, value in enumerate(investment_count['Count']):
        plt.text(index, value, str(value), ha='center', va='bottom', fontproperties=chinese_font)

    plt.show()

def investment_data():

    # Field related to investment choices
    investment_field = "你/妳選哪個投資？"
    title = "Investment Choices"

    # Summarize the data
    investment_data = df[investment_field].value_counts().head(100)  # Adjust the number as needed
    
    # Plot the data
    plt.figure(figsize=(10, 6))
    investment_data.plot(kind='bar', color='skyblue')
    plt.title(title, fontproperties=chinese_font)
    plt.xlabel('Investment Options', fontproperties=chinese_font)
    plt.ylabel('Number of Responses', fontproperties=chinese_font)
    plt.xticks(rotation=45, ha='right', fontproperties=chinese_font)
    plt.tight_layout()

    plt.show()