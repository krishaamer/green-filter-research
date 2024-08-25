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

def eu_energy_breakdown():
    # Data for the first chart: Electricity Generation Breakdown (2024 H1)
    labels_1 = ['Wind & Solar', 'Fossil Fuels', 'Hydropower', 'Nuclear']
    sizes_1 = [30, 27, 21, 3]
    explode_1 = (0.1, 0, 0, 0)  # Explode the wind & solar slice

    # Pie Chart: Electricity Generation Breakdown
    plt.figure(figsize=(7,7))
    plt.pie(sizes_1, explode=explode_1, labels=labels_1, autopct='%1.1f%%', shadow=True, startangle=90)
    plt.title('EU Electricity Generation Breakdown (H1 2024)')
    plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
    plt.show()

def eu_renewable_vs_fossil():
    # Data for the third chart: Renewable vs. Fossil Energy Share Over Time
    years_3 = [2019, 2020, 2021, 2022, 2023, 2024]
    renewables_share_3 = [25, 27, 28, 29, 30, 30]
    fossil_share_3 = [40, 38, 35, 33, 27, 27]

    # Line Chart: Renewable vs. Fossil Energy Share Over Time
    plt.figure(figsize=(10,6))
    plt.plot(years_3, renewables_share_3, label='Renewables', marker='o', color='green')
    plt.plot(years_3, fossil_share_3, label='Fossil Fuels', marker='o', color='red')
    plt.title('Renewable vs. Fossil Energy Share Over Time in the EU')
    plt.xlabel('Year')
    plt.ylabel('Percentage of Electricity Generation')
    plt.legend()
    plt.show()

def eu_coal_reduction():
    # Data for the fourth chart: Country-Specific Reductions in Fossil Fuel Use
    countries_4 = ['Germany', 'Italy', 'Spain', 'Belgium', 'France', 'Poland']
    coal_use_2019 = [26, 30, 10, 15, 10, 80]
    coal_use_2024 = [20, 15, 5, 7, 5, 57]

    # Bar Chart: Country-Specific Reductions in Fossil Fuel Use
    plt.figure(figsize=(12,6))
    bar_width = 0.35
    index = range(len(countries_4))

    plt.bar(index, coal_use_2019, bar_width, label='2019', color='blue')
    plt.bar([i + bar_width for i in index], coal_use_2024, bar_width, label='2024', color='orange')

    plt.xlabel('Country')
    plt.ylabel('Coal Share (%)')
    plt.title('Country-Specific Coal Use Reduction (2019 vs 2024)')
    plt.xticks([i + bar_width / 2 for i in index], countries_4)
    plt.legend()
    plt.show()

def microplastics_body_chart():
    # Adjusting the figure for a more anatomically correct representation of the human body

    fig, ax = plt.subplots(figsize=(6, 9))  # Adjusting figure size to give more space

    # Head (ellipse)
    head = plt.Circle((0.5, 0.85), 0.08, edgecolor='black', facecolor='none')

    # Body (rectangle for torso)
    torso = plt.Rectangle((0.4, 0.55), 0.2, 0.3, edgecolor='black', facecolor='none')

    # Left arm (rectangle)
    left_arm = plt.Rectangle((0.25, 0.6), 0.15, 0.05, edgecolor='black', facecolor='none')

    # Right arm (rectangle)
    right_arm = plt.Rectangle((0.6, 0.6), 0.15, 0.05, edgecolor='black', facecolor='none')

    # Left leg (rectangle)
    left_leg = plt.Rectangle((0.43, 0.25), 0.05, 0.3, edgecolor='black', facecolor='none')

    # Right leg (rectangle)
    right_leg = plt.Rectangle((0.52, 0.25), 0.05, 0.3, edgecolor='black', facecolor='none')

    # Brain (ellipse inside head)
    brain = plt.Circle((0.5, 0.85), 0.05, edgecolor='blue', facecolor='none', linestyle='dashed')

    # Lungs (ellipses inside torso)
    left_lung = plt.Circle((0.45, 0.7), 0.03, edgecolor='green', facecolor='none', linestyle='dashed')
    right_lung = plt.Circle((0.55, 0.7), 0.03, edgecolor='green', facecolor='none', linestyle='dashed')

    # Digestive tissues (inside torso as part of stomach area)
    digestive_tissues = plt.Rectangle((0.45, 0.55), 0.1, 0.15, edgecolor='orange', facecolor='none', linestyle='dashed')

    # Bone marrow (represented in both legs)
    left_leg_bone_marrow = plt.Line2D([0.445, 0.445], [0.25, 0.55], color='purple', linestyle='dashed')
    right_leg_bone_marrow = plt.Line2D([0.545, 0.545], [0.25, 0.55], color='purple', linestyle='dashed')

    # Placenta (represented inside the torso below digestive area)
    placenta = plt.Rectangle((0.45, 0.45), 0.1, 0.05, edgecolor='pink', facecolor='none', linestyle='dashed')

    # Penis and testis (located in lower body more anatomically correct)
    penis = plt.Rectangle((0.48, 0.2), 0.04, 0.07, edgecolor='brown', facecolor='none', linestyle='dashed')
    testis_left = plt.Circle((0.485, 0.17), 0.02, edgecolor='brown', facecolor='none', linestyle='dashed')
    testis_right = plt.Circle((0.515, 0.17), 0.02, edgecolor='brown', facecolor='none', linestyle='dashed')

    # Add shapes to plot
    ax.add_artist(head)
    ax.add_artist(torso)
    ax.add_artist(left_arm)
    ax.add_artist(right_arm)
    ax.add_artist(left_leg)
    ax.add_artist(right_leg)

    # Add organs
    ax.add_artist(brain)
    ax.add_artist(left_lung)
    ax.add_artist(right_lung)
    ax.add_artist(digestive_tissues)
    ax.add_line(left_leg_bone_marrow)
    ax.add_line(right_leg_bone_marrow)
    ax.add_artist(penis)
    ax.add_artist(testis_left)
    ax.add_artist(testis_right)
    ax.add_artist(placenta)

    # Add labels for the organs mentioned in the text using arrows pointing to the body parts
    ax.annotate('Brain', xy=(0.5, 0.85), xytext=(0.75, 0.9),
                arrowprops=dict(facecolor='blue', shrink=0.05), fontsize=10, color='blue')

    ax.annotate('Lungs', xy=(0.45, 0.7), xytext=(0.2, 0.7),
                arrowprops=dict(facecolor='green', shrink=0.05), fontsize=10, color='green')

    ax.annotate('Digestive Tissues', xy=(0.5, 0.6), xytext=(0.75, 0.6),
                arrowprops=dict(facecolor='orange', shrink=0.05), fontsize=10, color='orange')

    ax.annotate('Bone Marrow', xy=(0.445, 0.4), xytext=(0.1, 0.4),
                arrowprops=dict(facecolor='purple', shrink=0.05), fontsize=10, color='purple')

    ax.annotate('Penis', xy=(0.5, 0.22), xytext=(0.8, 0.25),
                arrowprops=dict(facecolor='brown', shrink=0.05), fontsize=10, color='brown')

    ax.annotate('Testis', xy=(0.5, 0.17), xytext=(0.2, 0.15),
                arrowprops=dict(facecolor='brown', shrink=0.05), fontsize=10, color='brown')

    ax.annotate('Placenta', xy=(0.5, 0.47), xytext=(0.8, 0.5),
                arrowprops=dict(facecolor='pink', shrink=0.05), fontsize=10, color='pink')

    # Add title
    plt.title('Microplastics Inside the Human Body', fontsize=14)

    # Set limits for better viewing
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)

    # Remove axis for cleaner look
    ax.set_xticks([])
    ax.set_yticks([])

    # Show the plot
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()
