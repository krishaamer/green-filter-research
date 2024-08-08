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


def carbon_credits_chart():
    
    # Create the combined bar chart with a logarithmic scale
    fig, ax = plt.subplots(figsize=(12, 6))

    # Data for combined markets
    markets_combined = ["EU", "UK", "US (California)", "Australia", "New Zealand", "South Korea", "China",
                        "Aviation Industry Offset", "Nature Based Offset", "Tech Based Offset"]
    prices_combined = [83, 40, 29, 32, 50, 5.84, 8.29, 0.93, 1.80, 0.77]
    colors_combined = ['skyblue'] * 7 + ['lightcoral'] * 3

    # Plotting the combined bar chart
    bars_combined = ax.bar(markets_combined, prices_combined, color=colors_combined)
    ax.set_yscale('log')
    ax.set_title('Compliance vs Voluntary Market CO2 Prices (August 12, 2023)')
    ax.set_xlabel('Markets')
    ax.set_ylabel('Price (log scale, in respective currency)')
    ax.grid(axis='y', linestyle='--', alpha=0.7)

    # Adding the price labels on top of the bars
    for bar, price in zip(bars_combined, prices_combined):
        ax.text(bar.get_x() + bar.get_width() / 2, price * 1.2, f'{price}', ha='center', color='black')

    # Display the chart
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.show()


def emergency_chart():
    
    # Data for the 2020 survey results
    data_2020 = {
        'Age Group': ['18-35', '36-59', 'Over 60'],
        'Agree': [65, 66, 58],
        'Neutral or Disagree': [35, 34, 42]
    }

    # Creating dataframe
    df_2020 = pd.DataFrame(data_2020)

    # Enhancing the stacked bar chart for better aesthetics
    fig, ax = plt.subplots(figsize=(10, 6))

    # Define colors
    colors = ['#2ca02c', '#d62728']

    # Plot the data
    ax.bar(df_2020['Age Group'], df_2020['Agree'], label='Agree', color=colors[0])
    ax.bar(df_2020['Age Group'], df_2020['Neutral or Disagree'], bottom=df_2020['Agree'], label='Neutral or Disagree', color=colors[1])

    # Add data labels
    for i in range(len(df_2020)):
        ax.text(i, df_2020['Agree'][i] / 2, f"{df_2020['Agree'][i]}%", ha='center', va='center', color='white', fontweight='bold')
        ax.text(i, df_2020['Agree'][i] + df_2020['Neutral or Disagree'][i] / 2, f"{df_2020['Neutral or Disagree'][i]}%", ha='center', va='center', color='white', fontweight='bold')

    # Adding titles and labels
    ax.set_xlabel('Age Group', fontsize=14)
    ax.set_ylabel('Percentage', fontsize=14)
    ax.set_title('2020 Survey Results: "Climate change is an emergency"', fontsize=16)
    ax.legend()

    # Customize gridlines and background
    ax.grid(axis='y', linestyle='--', alpha=0.7)
    ax.set_axisbelow(True)
    ax.set_facecolor('#f2f2f2')

    plt.show()


def ndc_chart():
    # Data for the chart
    countries = [
        "Japan", "USA", "EU", "Saudi Arabia", 
        "South Korea", "United Arab Emirates", 
        "Indonesia", "China", "Iran", "Russia"
    ]
    ndc_targets = [
        "Insufficient", "Insufficient", "Insufficient", 
        "Highly insufficient", "Highly insufficient", 
        "Highly insufficient", "Highly insufficient", 
        "Highly insufficient", "Critically insufficient", 
        "Critically insufficient"
    ]

    # Color mapping for NDC target categories
    color_mapping = {
        "Critically insufficient": "red",
        "Highly insufficient": "orange",
        "Insufficient": "yellow"
    }
    colors = [color_mapping[target] for target in ndc_targets]

    # Create the chart
    plt.figure(figsize=(10, 6))
    bars = plt.barh(countries, [1]*len(countries), color=colors)

    # Add labels to the bars
    for bar, target in zip(bars, ndc_targets):
        plt.text(bar.get_width() + 0.02, bar.get_y() + bar.get_height()/2, target, va='center')

    # Set chart title and labels
    plt.title("Climate Action Tracker: Top 10 Polluters' NDC Targets (Clustered)")
    plt.xlabel("NDC Target Category")
    plt.xticks([])
    plt.ylabel("Country or Region")

    # Show the chart
    plt.show()
