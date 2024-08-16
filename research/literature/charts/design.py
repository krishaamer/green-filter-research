import warnings
warnings.filterwarnings("ignore")

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import pandas as pd

def air_chart():

    # Data provided
    data = {
        "Country": ["Saudi Arabia", "UAE", "Taiwan", "Philippines", "South Korea", "Singapore", "Estonia", "Latvia", "Italy"],
        "VOC (ppm)": [0.429, 0.420, 0.324, 0.443, 0.681, 0.152, 0.646, 0.363, 0.708],
        "PM1 (µg/m³)": [22.48, 18.44, 12.01, 11.00, 8.18, 5.81, 4.53, 3.00, 3.11],
        "PM2.5 (µg/m³)": [25.08, 20.78, 14.05, 13.33, 10.23, 7.52, 6.22, 6.00, 4.84],
        "PM10 (µg/m³)": [26.23, 22.06, 15.19, 14.00, 11.59, 8.67, 7.41, 8.93, 6.02]
    }

    # Creating DataFrame
    df = pd.DataFrame(data)

    # Plotting the data as larger points for each indicator
    fig, ax = plt.subplots(figsize=(12, 8))

    # Plotting larger points for each air pollution metric
    ax.scatter(df["Country"], df["VOC (ppm)"], label='VOC (ppm)', marker='o', s=100)
    ax.scatter(df["Country"], df["PM1 (µg/m³)"], label='PM1 (µg/m³)', marker='x', s=100)
    ax.scatter(df["Country"], df["PM2.5 (µg/m³)"], label='PM2.5 (µg/m³)', marker='^', s=100)
    ax.scatter(df["Country"], df["PM10 (µg/m³)"], label='PM10 (µg/m³)', marker='s', s=100)

    # Adding title and labels
    ax.set_title('Air Pollution Data by Country')
    ax.set_xlabel('Country')
    ax.set_ylabel('Value')
    ax.legend(title='Pollutant')

    plt.xticks(rotation=45)
    plt.tight_layout()

    # Displaying the plot
    plt.show()

def fast_consumer_goods():
    # Data for the 10 largest FMCG companies by revenue in 2023 (in billion USD)
    companies = ['Nestlé', 'PepsiCo', 'Procter & Gamble', 'JBS Foods', 'Unilever', 
                'Anheuser-Busch InBev', 'Tyson Foods', 'Coca-Cola', 'L\'Oréal', 'British American Tobacco']
    revenues = [99.32, 91.47, 84.06, 72.92, 63.91, 59.40, 52.88, 45.75, 44.57, 34.80]

    # Custom colors for the bars
    colors = ['#FF6F61', '#6B5B95', '#88B04B', '#FFA07A', '#009B77', 
            '#FFD700', '#EFC050', '#45B8AC', '#5B5EA6', '#9B2335']

    # Create a bar chart with customized colors and add annotations
    plt.figure(figsize=(10,6))
    bars = plt.barh(companies, revenues, color=colors)

    # Add labels and title with improved styling
    plt.xlabel('Revenue (Billion USD)', fontsize=12, color='darkblue')
    plt.title('Top 10 FMCG Companies by Revenue in 2023', fontsize=14, color='darkgreen', fontweight='bold')
    plt.gca().invert_yaxis()  # Invert y-axis for better readability

    # Adding annotations to each bar
    for bar in bars:
        plt.text(bar.get_width() - 10, bar.get_y() + bar.get_height()/2, 
                f'{bar.get_width():.2f}B', va='center', ha='right', color='white', fontweight='bold')

    plt.tight_layout()

    # Show the chart
    plt.show()

def ant_forest():
    # data to be plotted
    x_years = [2016, 2017, 2018, 2019, 2020, 2021, 2022]
    y_trees = [0, 10000000, 55000000, 100000000, 200000000, 326000000, 400000000]
    y_users = [0, 23000000, 35000000, 500000000, 550000000, 600000000, 650000000]

    # plotting
    plt.title("Ant Forest Growth")
    plt.xlabel("Years")
    plt.ylabel("Trees and Users")
    plt.plot(x_years, y_trees, color = "green")
    plt.plot(x_years, y_users, color = "black")
    plt.legend(handles=[mpatches.Patch(color='black', label='Users'), mpatches.Patch(color='green', label='Trees')])
    plt.show()