import warnings
warnings.filterwarnings("ignore")

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import pandas as pd
import networkx as nx
import os
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')

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

def dfs_history():
    # Updated timeline and data to start from the mid-20th century
    years_extended = [1950, 1980, 1990, 2000, 2010]

    # Corrected data to ensure the lowest area touches the axis
    product_innovation_corrected = [0, 1, 1, 0.8, 0.6]
    product_service_system_extended = [0, 0, 0.5, 1, 1]
    spatio_social_extended = [0, 0, 0, 0.7, 1]
    socio_technical_system_extended = [0, 0, 0, 0, 1]

    # Create the plot
    fig, ax = plt.subplots(figsize=(10, 6))

    # Plot the stacked area chart
    ax.stackplot(years_extended, product_innovation_corrected, product_service_system_extended, spatio_social_extended, socio_technical_system_extended, 
                labels=[
                    'Product Innovation Level', 
                    'Product-Service System Innovation',
                    'Spatio-Social Innovation', 
                    'Socio-Technical System Innovation'
                ])

    # Repositioning annotations for designers
    ax.text(1955, 0.3, 'Buckminster Fuller\n& Victor Papanek', fontsize=10, color='black', ha='center')
    ax.text(1990, 0.6, 'Arnold Tukker\n(Product-Service System)', fontsize=10, color='black', ha='center')
    ax.text(2005, 0.95, 'John Chapman\n(Spatio-Social Innovation)', fontsize=10, color='black', ha='center')
    ax.text(2015, 0.15, '(Socio-Technical System)', fontsize=10, color='black', ha='center')

    # Update labels
    ax.set_xlabel('Year')
    ax.set_ylabel('Innovation Levels') 
    ax.set_title('Evolution of design for sustainability:\nFrom product design to design for system innovations and transitions')
    ax.legend(loc='upper left')

    # Show the chart
    plt.tight_layout()
    plt.show()


def compare_ps_epr_ecodesign():
    # Define the categories for the radar chart (including proactive vs reactive concepts)
    categories = ["End of Life Focus (Reactive)", "Producer Responsibility", "Comprehensive Design (Proactive)"]

    # Assign values for proactive vs reactive comparison (scaled 1 to 5)
    values_proactive_reactive = {
        'Product Stewardship': [4, 3, 1],  # More reactive, less proactive
        'EPR': [4, 4, 2],  # Slightly more proactive, still mostly reactive
        'Eco-Design': [1, 5, 5],  # Highly proactive, focuses on design and sustainability
    }

    # Number of variables/categories
    num_vars = len(categories)

    # Compute angle for each axis
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]  # Complete the loop for radar chart

    # Create radar chart with label adjustments
    fig, ax = plt.subplots(figsize=(6, 6), subplot_kw=dict(polar=True))

    # Plot each line and fill with background for the labels
    for label, value in values_proactive_reactive.items():
        stats = value + value[:1]
        ax.fill(angles, stats, alpha=0.25, label=label)
        ax.plot(angles, stats, linewidth=2)

    # Set axis labels with better visibility (background and multiple rows)
    labels = ["End of Life Focus\n(Reactive)", "Producer\nResponsibility", "Comprehensive Design\n(Proactive)"]
    ax.set_yticklabels([])
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(labels, bbox=dict(facecolor="white", edgecolor="black", boxstyle="round,pad=0.5"))

    # Add title and legend (clean labels)
    plt.legend(loc='upper right', bbox_to_anchor=(1.1, 1.1))

    # Display the updated chart
    plt.show()

def eu_green_deal():
    # Define the edges for the combined mind map
    combined_edges = [
        ("European Green Deal", "Fit for 55"),
        ("European Green Deal", "EUDR"),
        ("European Green Deal", "ESPR"),
        ("European Green Deal", "Circular Economy Action Plan"),
        ("European Green Deal", "Farm to Fork Strategy"),
        ("European Green Deal", "Biodiversity Strategy 2030"),
        ("European Green Deal", "EU Climate Law"),
        ("European Green Deal", "Waste Framework Directive"),
        ("European Green Deal", "Corporate Sustainability Due Diligence"),
        ("European Green Deal", "Sustainable Finance (EU Taxonomy)"),
        ("European Green Deal", "Energy Taxation Directive"),
        ("European Green Deal", "Carbon Border Adjustment Mechanism"),
        ("European Green Deal", "EU Emissions Trading System"),
    ]

    # Initialize the graph for the combined structure
    G_combined = nx.Graph()
    G_combined.add_edges_from(combined_edges)

    # Generate the layout for the graph
    pos_combined = nx.spring_layout(G_combined, seed=42)

    # Define a color scheme for different categories
    node_colors_combined = {
        'European Green Deal': 'lightgreen',
        'Fit for 55': 'lightcoral',
        'EUDR': 'lightblue',
        'ESPR': 'lightblue',
        'Circular Economy Action Plan': 'lightcoral',
        'Farm to Fork Strategy': 'lightyellow',
        'Biodiversity Strategy 2030': 'lightyellow',
        'EU Climate Law': 'lightgreen',
        'Waste Framework Directive': 'lightcoral',
        'Corporate Sustainability Due Diligence': 'lightblue',
        'Sustainable Finance (EU Taxonomy)': 'lightgreen',
        'Energy Taxation Directive': 'lightcoral',
        'Carbon Border Adjustment Mechanism': 'lightcoral',
        'EU Emissions Trading System': 'lightcoral',
    }

    # Define node border color and edge color
    node_border_color_combined = 'gray'
    edge_colors_combined = 'lightgray'

    # Create the combined visualization
    plt.figure(figsize=(12, 12))

    # Draw the graph with a spring layout to make it visually appealing and incorporate categories
    nx.draw(
        G_combined, pos_combined, 
        with_labels=True, 
        node_size=4000, 
        node_color=[node_colors_combined.get(node, 'skyblue') for node in G_combined.nodes()], 
        font_size=10, 
        font_weight='bold', 
        edge_color=edge_colors_combined, 
        arrowsize=20,
        linewidths=2,
        edgecolors=node_border_color_combined,
    )

    # Adding a title for clarity
    plt.title("Combined Concept Map of EU Green Deal Regulations and Categories", fontsize=16, fontweight='bold')

    # Show the chart
    plt.show()

def open_data_vs_civic_engagement():
    hello = "plap"

def open_data_index():
    # Load the data
    data = pd.read_csv(os.path.join(data_dir, 'open-data.csv'))

    # Sorting data so that the highest score country (best) is at the top
    sorted_data = data.sort_values(by='score', ascending=False)

    # Increase the figure height and padding to improve legibility
    plt.figure(figsize=(10, 16))  # Further increase height for better spacing

    # Set the bar width and spacing between the bars
    bar_width = 0.7
    bar_spacing = 1  # Increase the padding for better legibility

    # Plot the bars with the increased spacing
    bars = plt.barh(sorted_data['name'], sorted_data['score'], color='lightblue', height=bar_width)

    # Highlight Taiwan with a red bar
    taiwan_sorted = sorted_data[sorted_data['name'] == 'Taiwan']
    plt.barh(taiwan_sorted['name'], taiwan_sorted['score'], color='red', height=bar_width)

    # Set title and labels
    plt.title('Scores by Country (Best at the Top, Taiwan Highlighted)')
    plt.xlabel('Score')
    plt.ylabel('Country')

    # Adjust spacing between the bars
    plt.tight_layout(pad=bar_spacing)
    plt.gca().invert_yaxis()  # Invert y-axis so the best is at the top
    plt.show()

def open_data_compare():
    # Data from the rankings across different open data benchmarks
    countries = ['Canada', 'UK', 'Taiwan', 'Australia', 'Ireland', 'Spain', 'Denmark', 'Norway', 'Korea', 'France', 'Singapore']
    ranks_barometer = [1, 1, None, None, None, None, None, None, None, None, None]  # Open Data Barometer
    ranks_index = [None, None, 1, 2, None, None, None, None, None, None, None]  # Open Data Index
    ranks_maturity = [None, None, None, None, 1, 2, None, None, None, None, None]  # Open Data Maturity
    ranks_wjp = [None, None, None, None, None, None, 1, 2, None, None, None]  # WJP Open Government Index
    ranks_oecd = [None, None, None, None, None, None, None, None, 1, 2, None]  # OECD Report
    ranks_watch = [None, None, None, None, None, None, None, None, None, None, 1]  # Open Data Watch

    # Plotting the ranking comparison for each country across the benchmarks
    plt.figure(figsize=(12, 6))
    plt.plot(countries, ranks_barometer, marker='o', label='Open Data Barometer', color='blue')
    plt.plot(countries, ranks_index, marker='o', label='Open Data Index', color='green')
    plt.plot(countries, ranks_maturity, marker='o', label='Open Data Maturity', color='orange')
    plt.plot(countries, ranks_wjp, marker='o', label='WJP Open Government Index', color='purple')
    plt.plot(countries, ranks_oecd, marker='o', label='OECD Report', color='red')
    plt.plot(countries, ranks_watch, marker='o', label='Open Data Watch', color='cyan')

    # Adding titles and labels
    plt.title('Comparative Ranking of Countries in Various Open Data Benchmarks')
    plt.xlabel('Country')
    plt.ylabel('Rank (1 = Best)')
    plt.legend()
    plt.xticks(rotation=45)
    plt.gca().invert_yaxis()  # Invert y-axis so that Rank 1 appears at the top
    plt.grid(True)
    plt.tight_layout()
    plt.show()

def pandemic():
    # Data for incidents before and after the pandemic
    bp_counts = [1643, 16850, 21386, 750, 1481]
    pp_counts = [1938, 22366, 26656, 670, 1522]
    categories = ['Urination & Defecation', 'Littering', 'Graffiti & Physical Damage', 'Abandoned Cars', 'Poor Bike Parking']

    # Radar chart requires the data to be circular, so append the first value to the end
    bp_counts_circular = bp_counts + [bp_counts[0]]  # Append first value to close the loop
    pp_counts_circular = pp_counts + [pp_counts[0]]  # Append first value to close the loop
    labels = categories + [categories[0]]  # Append first category to close the loop

    # Set up the radar chart
    angles = np.linspace(0, 2 * np.pi, len(categories), endpoint=False).tolist()
    angles += angles[:1]  # Close the loop in the angles

    fig, ax = plt.subplots(figsize=(6, 6), subplot_kw=dict(polar=True))
    ax.fill(angles, bp_counts_circular, color='blue', alpha=0.25, label='Before Pandemic')
    ax.plot(angles, bp_counts_circular, color='blue', linewidth=2)

    ax.fill(angles, pp_counts_circular, color='green', alpha=0.25, label='After Pandemic')
    ax.plot(angles, pp_counts_circular, color='green', linewidth=2)

    # Add labels and title
    ax.set_yticklabels([])
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(categories, size=12, rotation=30, ha='right')
    ax.set_title('Incidents Distribution (Before vs After)', size=15, color='darkblue')
    ax.legend(loc='upper right', bbox_to_anchor=(1.1, 1.1))

    plt.tight_layout()
    plt.show()

def malaysia_forests():
    forest_reserve_data = pd.read_csv(os.path.join(data_dir, 'malaysia-forest-reserve.csv'))

    # Convert the date column to datetime format for better plotting
    forest_reserve_data['date'] = pd.to_datetime(forest_reserve_data['date'])

    # Create the plot
    plt.figure(figsize=(10, 6))
    plt.plot(forest_reserve_data['date'], forest_reserve_data['area'], marker='o', linestyle='-', color='b')
    plt.title('Decline in Malaysian Permanent Forest Reserves (2003 onwards)')
    plt.xlabel('Year')
    plt.ylabel('Area of Forest Reserves (in hectares)')
    plt.grid(True)

    # Show the plot
    plt.show()
