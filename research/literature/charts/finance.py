import warnings
warnings.filterwarnings("ignore")
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import numpy as np
import pandas as pd
import os
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')

def money_chart():

    assets_with_climate_reversed = [
        "Global Real Estate", "Global Equity Markets", "Global GDP (2023)", "Global GDP (2022)",
        "Global Pension Funds", "U.S. Equity Markets", "U.S. National Debt", 
        "Millennials Inheriting Money", "Global Retail Sales", "GDP of U.S.A.",
        "GDP of China", "Global Private Market Assets", "Unpriced Externalities", 
        "Global E-Commerce Sales", "Missing Climate Investment", "Industrial & Commercial Bank of China",
        "Global Real Estate Sales", "Apple Computers", "GDP of Japan", "GDP of Germany",
        "GDP of India", "U.S. Gen-Z and Millennials Consumer Spending", "NVIDIA 英偉達",
        "Retail Investors", "Blackstone", "Bitcoin", "GDP of Taiwan", "GDP of Finland",
        "Ethereum", "GDP of Estonia"
    ][::-1]

    values_with_climate_reversed = [
        326, 108, 105, 100, 47.9, 46.2, 32.6, 30, 28.2, 26.8, 19.3, 11.7, 7.3, 5.2, 4.1,
        4, 3.7, 3.1, 4.5, 4.3, 3.7, 2.5, 2.5, 1.8, 1, 1, 0.8, 0.3, 0.3, 0.04
    ][::-1]

    # Combine assets and values for display
    assets_with_values_reversed = [f"{assets_with_climate_reversed[i]} ({values_with_climate_reversed[i]}T USD)" for i in range(len(assets_with_climate_reversed))]

    # Generate a unique color for each bubble, ensuring the missing climate investment is highlighted in red
    colors = plt.cm.viridis(np.linspace(0, 1, len(assets_with_climate_reversed)))
    highlight_index = assets_with_climate_reversed.index("Missing Climate Investment")
    colors[highlight_index] = np.array([1, 0, 0, 1])  # Red color

    # Data for bubble chart
    x = np.zeros(len(assets_with_climate_reversed))
    y = np.arange(len(assets_with_climate_reversed))
    sizes = np.array(values_with_climate_reversed) * 100  # Scale bubble sizes

    plt.figure(figsize=(14,10))
    plt.scatter(x, y, s=sizes, alpha=0.6, color=colors, edgecolors='black', linewidth=1.5)
    for i, value in enumerate(values_with_climate_reversed):
        plt.text(x[i], y[i], f'{value}T', ha='center', va='center', fontsize=10 if i != highlight_index else 12, fontweight='bold' if i == highlight_index else 'normal', color='white')

    plt.yticks(y, assets_with_values_reversed)
    plt.xticks([])
    plt.ylabel('Assets', fontsize=14, fontweight='bold', color='black')
    plt.title('High-Value Assets (Trillions of USD) with Missing Climate Investment Highlighted', fontsize=16, fontweight='bold', color='black')

    plt.show()


def fintech_chart():
    # Adding the new events to the data
    new_events = {
        "Date": ["2010-01-01", "2014-01-01", "2020-12-01", "2021-01-01", "2023-01-01", "2023-11-01", "2024-01-01"],
        "Event": [
            "eToro releases copy-trading",
            "Acorn micro-investing app launched",
            "Thesis Proposal",
            "App Release",
            "Acorn launches savings debit card",
            "Feature Release",
            "Revolut launches stocks, ETFs, bonds, crypto"
        ]
    }

    # Creating a new DataFrame
    df_new_events = pd.DataFrame(new_events)

    # Convert dates to datetime format for plotting
    df_new_events['Date'] = pd.to_datetime(df_new_events['Date'])

    # Calculate the number of days since the first event
    days_since_start = (df_new_events['Date'] - df_new_events['Date'].min()).dt.days

    # Apply a square root transformation to days to adjust spacing
    adjusted_positions = np.sqrt(days_since_start).astype(float)

    # Normalize positions to fit within the vertical space, ensuring minimum pixel distance
    fig_height = 8  # Same height as used in the figure
    min_pixel_gap = 100 / fig_height  # Minimum gap as a fraction of figure height
    total_height = (len(df_new_events) - 1) * min_pixel_gap
    adjusted_positions = np.linspace(0, total_height, len(adjusted_positions))

    # Plotting with the new events
    plt.figure(figsize=(10, 8))
    plt.plot([1] * len(df_new_events), adjusted_positions, 'ro')  # Plot points on y-axis
    plt.xticks([])  # Remove x-axis ticks
    plt.gca().get_xaxis().set_visible(False)  # Hide x-axis

    # Adding relevant dates manually for clearer spacing
    relevant_dates = pd.to_datetime(["2010-01-01", "2014-01-01", "2020-12-01", "2021-01-01", "2023-01-01", "2023-11-01", "2024-01-01"])
    relevant_days_since_start = (relevant_dates - df_new_events['Date'].min()).days
    relevant_adjusted_positions = np.linspace(0, total_height, len(relevant_dates))

    # Adjust relevant dates for plotting
    plt.yticks(relevant_adjusted_positions, ["2010", "2014", "Dec 2020", "Jan 2021", "Jan 2023", "Nov 2023", "Jan 2024"], fontsize=10)

    # Adding annotations with staggered positions to prevent overlap
    for i, (date, event) in enumerate(zip(adjusted_positions, df_new_events['Event'])):
        offset = -10 if i % 2 == 0 else 10  # Increase offset for more spacing
        plt.annotate(event, (1, date), textcoords="offset points", xytext=(offset, 0), ha='left' if offset > 0 else 'right', fontsize=10)

    plt.title('Shopping + Investing apps', fontsize=14)
    plt.grid(axis='y', linestyle='--')
    plt.tight_layout()
    plt.show()


def asset_classes():

    fig, ax = plt.subplots(figsize=(6, 8))

    # Re-defining a simple list for years and corresponding asset classes
    years = [
        "Pre-1600s", "1600s–1700s", "1800s", "1900s",
        "2000s", "2010s", "2020s"
    ]
    asset_classes = [
        "Precious Metals, Land, Livestock",
        "Government Bonds, Stocks",
        "Corporate Bonds, Commodities Futures",
        "Mutual Funds, Derivatives, Venture Capital, REITs",
        "Hedge Funds, Private Equity, Cryptocurrencies, P2P Lending",
        "ETFs, Green Bonds, ICOs, NFTs",
        "DeFi, Metaverse Land, Tokenized Real Assets, ESG Investing, Data as an Asset"
    ]

    # Create a simplified vertical timeline
    for i, (year, assets) in enumerate(zip(years, asset_classes)):
        y_pos = (len(years) - i - 1) * 0.26  # Adjust spacing by multiplying by 0.35
        ax.text(0.5, y_pos, year, ha='center', va='center', fontsize=12, bbox=dict(facecolor='white', edgecolor='black'))
        ax.text(0.5, y_pos - 0.1, assets, ha='center', va='center', fontsize=10)

    # Draw a central line to indicate the timeline
    ax.axvline(x=0.5, ymin=0, ymax=1, color='red', linestyle='-', linewidth=1)

    # Remove axes for clarity
    ax.axis('off')

    # Display the graph
    plt.tight_layout()
    plt.show()

def shopping_growth():

    # Data from the Forrester report
    years = [2023, 2028]
    global_sales = [4.4, 6.8]  # in trillion USD
    us_sales = [1.4, 1.6]  # in trillion USD
    canada_sales = [72, 83]  # in billion USD
    latam_sales = [109, 192]  # in billion USD
    western_europe_sales = [508, 773]  # in billion USD
    eastern_europe_sales = [72, 126]  # in billion USD
    asia_pacific_sales = [2.2, 3.2]  # in trillion USD
    sea_sales = [93, 193]  # in billion USD

    # Create a figure and axis for each region
    fig, ax = plt.subplots(figsize=(10, 6))

    # Plot data
    ax.plot(years, global_sales, marker='o', label='Global')
    ax.plot(years, us_sales, marker='o', label='US')
    ax.plot(years, [x/1000 for x in canada_sales], marker='o', label='Canada')
    ax.plot(years, [x/1000 for x in latam_sales], marker='o', label='Latin America')
    ax.plot(years, [x/1000 for x in western_europe_sales], marker='o', label='Western Europe')
    ax.plot(years, [x/1000 for x in eastern_europe_sales], marker='o', label='Eastern Europe')
    ax.plot(years, asia_pacific_sales, marker='o', label='Asia-Pacific')
    ax.plot(years, [x/1000 for x in sea_sales], marker='o', label='Southeast Asia')

    # Labels and title
    ax.set_xlabel('Year')
    ax.set_ylabel('Online Retail Sales (Trillion USD)')
    ax.set_title('Projected Growth of Online Retail Sales (2023-2028)')
    ax.legend()

    # Show plot
    plt.tight_layout()
    plt.show()

def world_bank_bonds():
    # Data for the bond issuances
    years = [2018, 2019, 2024]
    amounts_usd = [110 * 0.75, 50 * 0.75, 200 * 1.1]  # Converted to USD
    maturity_years = [2020, 2020, 2031]
    labels_with_countries = [
        'Australia - First Blockchain Bond-i',
        'Australia - Second Tranche of Bond-i',
        'Switzerland - CHF Digital Bond'
    ]

    # Plotting the data with adjustments to ensure text visibility
    plt.figure(figsize=(12, 8))
    plt.plot(years, amounts_usd, marker='o', linestyle='-', color='b')

    # Adding data labels with countries, amounts, and maturity years
    for i, label in enumerate(labels_with_countries):
        plt.text(
            years[i], amounts_usd[i] + 15, 
            f'{label}\n{amounts_usd[i]:.2f} million USD\nMatures: {maturity_years[i]}', 
            ha='center', fontsize=10, bbox=dict(facecolor='white', alpha=0.8, edgecolor='black')
        )

    plt.title('World Bank Blockchain Bond Issuances (2018-2024)', fontsize=14)
    plt.xlabel('Year', fontsize=12)
    plt.ylabel('Amount Raised (in million USD)', fontsize=12)
    plt.xticks(years, fontsize=10)
    plt.yticks(fontsize=10)
    plt.grid(True)

    # Display the updated plot
    plt.show()

def growth_vietnam():
    years = range(1990, 2020)

    # Simulating data trends based on the paper's description
    vietnam_data = {
        'Year': years,
        'CO2_emissions_per_capita': np.linspace(2, 8, len(years)) + np.random.rand(len(years)) * 0.5,
        'GDP_per_capita': np.linspace(1, 6, len(years)) + np.random.rand(len(years)) * 0.3,
        'Energy_consumption': np.linspace(1.5, 7.5, len(years)) + np.random.rand(len(years)) * 0.4,
        'Agricultural_value_added': np.linspace(4, 5.5, len(years)) + np.random.rand(len(years)) * 0.2,
        'Forest_cover': np.linspace(3, 2, len(years)) + np.random.rand(len(years)) * 0.1,
        'Technological_innovation': np.linspace(0.5, 4, len(years)) + np.random.rand(len(years)) * 0.2
    }

    df_vietnam = pd.DataFrame(vietnam_data)

    # Plotting the data for Vietnam
    plt.figure(figsize=(14, 8))

    # Plot CO2 emissions per capita
    plt.plot(df_vietnam['Year'], df_vietnam['CO2_emissions_per_capita'], label='CO2 Emissions per Capita', marker='o')

    # Plot GDP per capita
    plt.plot(df_vietnam['Year'], df_vietnam['GDP_per_capita'], label='GDP per Capita', marker='x')

    # Plot Energy consumption
    plt.plot(df_vietnam['Year'], df_vietnam['Energy_consumption'], label='Energy Consumption', marker='s')

    # Plot Agricultural value added
    plt.plot(df_vietnam['Year'], df_vietnam['Agricultural_value_added'], label='Agricultural Value Added', marker='d')

    # Plot Forest cover
    plt.plot(df_vietnam['Year'], df_vietnam['Forest_cover'], label='Forest Cover', marker='^')

    # Plot Technological innovation
    plt.plot(df_vietnam['Year'], df_vietnam['Technological_innovation'], label='Technological Innovation', marker='p')

    plt.title('Trends in CO2 Emissions, GDP per Capita, Energy Consumption, and Other Variables in Vietnam (1990-2019)')
    plt.xlabel('Year')
    plt.ylabel('Values')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

def growth_brics():
    # Original data for GDP per capita and CO2 emissions per capita
    years = [1990, 1995, 2000, 2005, 2010, 2015, 2018]

    china_gdp_per_capita = [1000, 2000, 4000, 6000, 8000, 10000, 12000]
    china_co2_per_capita = [2, 3, 4, 6, 8, 10, 12]

    india_gdp_per_capita = [500, 800, 1200, 2000, 3000, 4000, 5000]
    india_co2_per_capita = [1, 1.5, 2, 3, 4, 5, 6]

    brazil_gdp_per_capita = [3000, 4000, 5000, 6000, 8000, 9000, 10000]
    brazil_co2_per_capita = [2, 2.5, 3, 3.5, 4, 4.5, 5]

    russia_gdp_per_capita = [4000, 3000, 3500, 5000, 6000, 7000, 8000]
    russia_co2_per_capita = [10, 8, 7, 8, 9, 10, 11]

    south_africa_gdp_per_capita = [2500, 3000, 3500, 4000, 4500, 5000, 5500]
    south_africa_co2_per_capita = [3, 3.5, 4, 4.5, 5, 5.5, 6]

    somalia_gdp_per_capita = [200, 250, 300, 400, 500, 600, 700]
    somalia_co2_per_capita = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1]

    vietnam_gdp_per_capita = [300, 500, 800, 1200, 2000, 2500, 3000]
    vietnam_co2_per_capita = [0.8, 1.2, 1.5, 2, 3, 3.5, 4]

    plt.figure(figsize=(14, 12))

    # Plotting GDP per Capita for all countries
    plt.subplot(2, 1, 1)
    plt.plot(years, china_gdp_per_capita, marker='o', linestyle='-', color='red', label='China GDP per Capita')
    plt.plot(years, india_gdp_per_capita, marker='o', linestyle='-', color='green', label='India GDP per Capita')
    plt.plot(years, brazil_gdp_per_capita, marker='o', linestyle='-', color='blue', label='Brazil GDP per Capita')
    plt.plot(years, russia_gdp_per_capita, marker='o', linestyle='-', color='orange', label='Russia GDP per Capita')
    plt.plot(years, south_africa_gdp_per_capita, marker='o', linestyle='-', color='purple', label='South Africa GDP per Capita')
    plt.plot(years, somalia_gdp_per_capita, marker='o', linestyle='-', color='brown', label='Somalia GDP per Capita')
    plt.plot(years, vietnam_gdp_per_capita, marker='o', linestyle='-', color='black', label='Vietnam GDP per Capita')
    plt.title('GDP per Capita: BRICS Countries, Somalia, and Vietnam (1990-2018)')
    plt.ylabel('GDP per Capita (USD)')
    plt.legend()
    plt.grid(True)

    # Plotting CO2 Emissions per Capita for all countries
    plt.subplot(2, 1, 2)
    plt.plot(years, china_co2_per_capita, marker='o', linestyle='--', color='red', label='China CO2 per Capita')
    plt.plot(years, india_co2_per_capita, marker='o', linestyle='--', color='green', label='India CO2 per Capita')
    plt.plot(years, brazil_co2_per_capita, marker='o', linestyle='--', color='blue', label='Brazil CO2 per Capita')
    plt.plot(years, russia_co2_per_capita, marker='o', linestyle='--', color='orange', label='Russia CO2 per Capita')
    plt.plot(years, south_africa_co2_per_capita, marker='o', linestyle='--', color='purple', label='South Africa CO2 per Capita')
    plt.plot(years, somalia_co2_per_capita, marker='o', linestyle='--', color='brown', label='Somalia CO2 per Capita')
    plt.plot(years, vietnam_co2_per_capita, marker='o', linestyle='--', color='black', label='Vietnam CO2 per Capita')
    plt.title('CO2 Emissions per Capita: BRICS Countries, Somalia, and Vietnam (1990-2018)')
    plt.xlabel('Year')
    plt.ylabel('CO2 Emissions per Capita (Metric Tons)')
    plt.legend()
    plt.grid(True)

    plt.tight_layout()
    plt.show()

def esg_fintech_chart():
  
    # Data for the ESG performance and FinTech integration
    # Hypothetical data for illustration purposes
    esg_scores = np.array([45, 50, 60, 65, 70, 75, 80, 85, 90, 95])
    fintech_integration = np.array([30, 40, 55, 60, 70, 72, 75, 78, 82, 85])

    # Plotting the scatter plot
    plt.figure(figsize=(10, 6))
    plt.scatter(esg_scores, fintech_integration, color='blue', marker='o')
    plt.title('Correlation between ESG Scores and FinTech Integration')
    plt.xlabel('ESG Scores')
    plt.ylabel('FinTech Integration Level')
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.show()


def esg_fintech_heatmap():
    # Data for plotting
    variables = ["ESG Score", "Fintech Index", "Board Size", "Board Independence", 
                "Women on Board", "Bank Size", "Leverage", "ROA", "Age"]
    means = [44.51, 42.69, 11.42, 80.21, 26.33, 87539, 0.06, 1.25, 32.86]
    std_devs = [16.02, 44.56, 2.85, 14.55, 12.65, 333566, 0.09, 0.75, 23.93]
    mins = [10.95, 0, 5, 11, 0, 889, 0, -0.84, 0]
    maxs = [92.25, 266, 21, 100, 62.5, 2755813, 1, 9.19, 148]

    # Correlation Matrix
    correlation_data = np.array([[1, 0.558, 0.101, -0.157, 0.635, 0.731, 0.442, -0.066, 0.296],
                                [0.558, 1, 0.115, -0.239, 0.288, 0.573, 0.204, -0.018, 0.229],
                                [0.101, 0.115, 1, 0.013, -0.106, 0.346, -0.083, -0.074, 0.297],
                                [-0.157, -0.239, 0.013, 1, -0.205, -0.273, -0.380, -0.019, -0.081],
                                [0.635, 0.288, -0.106, -0.205, 1, 0.484, 0.499, -0.107, 0.195],
                                [0.731, 0.573, 0.346, -0.273, 0.484, 1, 0.511, -0.162, 0.386],
                                [0.442, 0.204, -0.083, -0.380, 0.499, 0.511, 1, -0.015, 0.249],
                                [-0.066, -0.018, -0.074, -0.019, -0.107, -0.162, -0.015, 1, -0.122],
                                [0.296, 0.229, 0.297, -0.081, 0.195, 0.386, 0.249, -0.122, 1]])

    corr_variables = ["ESG Score", "Fintech Index", "Board Size", "Board Independence", 
                    "Women on Board", "Bank Size", "Leverage", "ROA", "Age"]

    plt.figure(figsize=(10, 8))
    sns.heatmap(correlation_data, annot=True, fmt=".2f", cmap="coolwarm", xticklabels=corr_variables, yticklabels=corr_variables)
    plt.title('Correlation Matrix Heatmap')
    plt.show()


def social_commerce_chart():

    # Creating a colorful line chart to show the growth trends over time
    # Data for the line chart (values in billions for markets, millions for users)
    years = ["2020/2019", "2027"]
    categories_line = ["Global Social Commerce Market", "US Social Commerce Buyers", "Chinese Live-Stream Market", "Buy Now Pay Later Market"]
    values_2020 = [89.4, 80.1, 66, 7.3]
    values_2027 = [604.5, 90.4, 170, 33.6]

    # Create a line chart
    plt.figure(figsize=(10, 6))

    # Plotting lines for each category
    plt.plot(years, [values_2020[0], values_2027[0]], label=categories_line[0], marker='o', linestyle='-', linewidth=2, color='orange')
    plt.plot(years, [values_2020[1], values_2027[1]], label=categories_line[1], marker='o', linestyle='-', linewidth=2, color='green')
    plt.plot(years, [values_2020[2], values_2027[2]], label=categories_line[2], marker='o', linestyle='-', linewidth=2, color='blue')
    plt.plot(years, [values_2020[3], values_2027[3]], label=categories_line[3], marker='o', linestyle='-', linewidth=2, color='purple')

    # Add labels and title
    plt.title("Social Commerce Growth Trends: 2020 vs Projected 2027")
    plt.xlabel("Year")
    plt.ylabel("Amount in Billions (USD) / Millions (People)")
    plt.legend()

    # Display the line chart
    plt.tight_layout()
    plt.show()

def conventional_vs_sri_funds():
    # Reformatting data for side-by-side comparison
    data_comparison_side_by_side = {
        "Metric": ["Carbon Footprint (RCF)", "Carbon Footprint (RCF)", "Carbon Intensity (WACI)", "Carbon Intensity (WACI)"],
        "Fund Type": ["SRI Funds", "Conventional Funds", "SRI Funds", "Conventional Funds"],
        "Value": [346, 408, 475, 479]
    }

    # Create DataFrame
    df_side_by_side = pd.DataFrame(data_comparison_side_by_side)

    # Create a bar chart for side-by-side comparison
    fig, ax = plt.subplots(figsize=(8, 6))

    # Corrected pivot method with keyword arguments
    df_pivot = df_side_by_side.pivot(index="Metric", columns="Fund Type", values="Value")
    
    # Plotting the data
    df_pivot.plot(kind="bar", ax=ax)

    # Adding labels and title
    ax.set_ylabel("Carbon Metrics")
    ax.set_title("Side-by-Side Comparison of Carbon Footprint and Intensity")

    # Display plot
    plt.xticks(rotation=0)
    plt.tight_layout()

    plt.show()

def ck_carbon_productivity():

    # Load the CSV files
    data_2021 = pd.read_csv(os.path.join(data_dir, 'ck-2021.csv'))
    data_2022 = pd.read_csv(os.path.join(data_dir, 'ck-2022.csv'))
    data_2023 = pd.read_csv(os.path.join(data_dir, 'ck-2023.csv'))
    data_2024 = pd.read_csv(os.path.join(data_dir, 'ck-2024.csv'))

    # Add a 'Year' column to each dataframe
    data_2021['Year'] = 2021
    data_2022['Year'] = 2022
    data_2023['Year'] = 2023
    data_2024['Year'] = 2024

    # Concatenate all datasets
    combined_data = pd.concat([data_2021, data_2022, data_2023, data_2024])

    # Ensure numeric columns
    combined_data['Carbon Productivity Score'] = pd.to_numeric(combined_data['Carbon Productivity Score'].str.rstrip('%'), errors='coerce')

    # Group data by year and calculate the mean for Carbon Productivity
    trend_summary = combined_data.groupby('Year')['Carbon Productivity Score'].mean()

    # Plot Carbon Productivity Score
    plt.figure()
    plt.plot(trend_summary.index.astype(int), trend_summary, marker='o', color='green')
    plt.title('Carbon Productivity Score (2021-2024)')
    plt.xlabel('Year')
    plt.ylabel('Carbon Productivity Score (%)')
    plt.grid(True)
    plt.xticks(trend_summary.index.astype(int))  # Set the ticks as integer years
    plt.show()

def ck_energy_productivity():

    # Load the CSV files
    data_2021 = pd.read_csv(os.path.join(data_dir, 'ck-2021.csv'))
    data_2022 = pd.read_csv(os.path.join(data_dir, 'ck-2022.csv'))
    data_2023 = pd.read_csv(os.path.join(data_dir, 'ck-2023.csv'))
    data_2024 = pd.read_csv(os.path.join(data_dir, 'ck-2024.csv'))

    # Add a 'Year' column to each dataframe
    data_2021['Year'] = 2021
    data_2022['Year'] = 2022
    data_2023['Year'] = 2023
    data_2024['Year'] = 2024

    # Concatenate all datasets
    combined_data = pd.concat([data_2021, data_2022, data_2023, data_2024])

    # Ensure numeric columns
    combined_data['Energy Productivity Score'] = pd.to_numeric(combined_data['Energy Productivity Score'].str.rstrip('%'), errors='coerce')

    # Group data by year and calculate the mean for Energy Productivity
    trend_summary = combined_data.groupby('Year')['Energy Productivity Score'].mean()

    # Plot Energy Productivity Score
    plt.figure()
    plt.plot(trend_summary.index.astype(int), trend_summary, marker='o')
    plt.title('Energy Productivity Score (2021-2024)')
    plt.xlabel('Year')
    plt.ylabel('Energy Productivity Score (%)')
    plt.grid(True)
    plt.xticks(trend_summary.index.astype(int))  # Set the ticks as integer years
    plt.show()

def ck_board_diversity():

    data = {
        'Year': [2021, 2021, 2021, 2021, 2021, 2022, 2022, 2022, 2022, 2022, 2023, 2023, 2023, 2023, 2023, 2024, 2024, 2024, 2024, 2024],
        'Company': [
            'Schneider Electric SE', 'Orsted A/S', 'Banco do Brasil SA', 'Neste Oyj', 'Stantec Inc',
            'Vestas Wind Systems A/S', 'Chr Hansen Holding A/S', 'Neste Oyj', 'Orsted A/S', 'Schneider Electric SE',
            'Schneider Electric SE', 'Orsted A/S', 'Banco do Brasil SA', 'Neste Oyj', 'Stantec Inc',
            'Schneider Electric SE', 'Orsted A/S', 'Banco do Brasil SA', 'Neste Oyj', 'Stantec Inc'
        ],
        'Board Diversity Score': [3.0, 3.0, 3.0, 3.0, 3.0, 79.0, 83.0, 3.0, 3.0, 3.0, 85.0, 84.0, 80.0, 3.0, 3.0, 86.0, 85.0, 84.0, 3.0, 3.0],
        'Rank': [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
    }

    # Convert the data into a DataFrame
    top_5_companies = pd.DataFrame(data)

    # Creating the plot
    plt.figure(figsize=(12, 8))
    for i, company in enumerate(top_5_companies['Company'].unique()):
        company_data = top_5_companies[top_5_companies['Company'] == company]
        # Plotting diversity scores
        plt.plot(company_data['Year'], company_data['Board Diversity Score'], marker='o', linestyle='-', label=f"{company} (Diversity)", color=f"C{i}")
        # Plotting rankings
        plt.plot(company_data['Year'], -company_data['Rank'], marker='x', linestyle='--', label=f"{company} (Ranking)", color=f"C{i}")

    # Setting the title and axis labels
    plt.title('Board Diversity and Ranking Trends')
    plt.xlabel('Year')
    plt.ylabel('Board Diversity Score (%) and Ranking (Inverted)')

    # Removing decimals from the axes labels
    plt.gca().yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{int(abs(x))}'))
    plt.gca().xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{int(x)}'))

    # Splitting the legend into two sections: Diversity and Ranking
    handles, labels = plt.gca().get_legend_handles_labels()
    diversity_handles = [h for h, l in zip(handles, labels) if "(Diversity)" in l]
    ranking_handles = [h for h, l in zip(handles, labels) if "(Ranking)" in l]

    # Creating separate legends for diversity and ranking, positioning them to avoid overlap
    first_legend = plt.legend(diversity_handles, [l.replace(" (Diversity)", "") for l in labels if "(Diversity)" in l], title="Diversity", bbox_to_anchor=(1.25, 1), loc='upper left')
    ax = plt.gca().add_artist(first_legend)
    plt.legend(ranking_handles, [l.replace(" (Ranking)", "") for l in labels if "(Ranking)" in l], title="Ranking", bbox_to_anchor=(1.25, 0.6), loc='upper left')

    # Adjusting layout to ensure everything fits
    plt.tight_layout()
    plt.show()

def esg_rating_agencies_chart():

    # Correct percentages for ESG data providers
    providers = [
        "Refinitiv", "Huazheng", "Sustainalytics", "MSCI Stats", 
        "KLD", "Bloomberg", "S&P", "VigeoEiris", "Sino-Securities Index", 
        "SIRIS"
    ]
    percentages = [33.6, 4.0, 4.8, 7.2, 13.6, 12.8, 2.4, 2.4, 4.8, 0.8]

    # Colors to match each provider
    colors = ['brown', 'yellow', 'lightgreen', 'turquoise', 
            'darkorange', 'purple', 'red', 'blue', 'pink', 'grey']

    # Create the pie chart
    plt.figure(figsize=(8, 8))
    plt.pie(percentages, labels=providers, autopct='%1.1f%%', startangle=140, colors=colors)
    plt.title('Distribution of Providers used among the Selected Articles')

    # Display the pie chart
    plt.show()


def climate_finance_gap_sectors():
    # Data in trillions
    sectors = ['Power', 'Buildings', 'Transport', 'Agriculture & Nature-based Solutions', 'Industry']
    needs_2020_2025_trillions = [1.95, 0.66, 0.38, 0.14, 0.4]  # Values converted to trillions
    flows_2020_trillions = [0.75, 0.26, 0.14, 0.05, 0.14]

    fig, ax = plt.subplots(figsize=(12, 6))
    bar_width = 0.35
    index = np.arange(len(sectors))

    # Create bars for needs and flows in trillions
    bars1 = ax.bar(index, needs_2020_2025_trillions, bar_width, label='Annual Financing Needs (2020-2025)')
    bars2 = ax.bar(index + bar_width, flows_2020_trillions, bar_width, label='Annual Flows (2020)')

    # Add labels, title, and legend
    ax.set_xlabel('Sector', fontsize=12)
    ax.set_ylabel('Financing (in $ trillions)', fontsize=12)
    ax.set_title('Climate Finance Gaps by Sector (2020-2025)', fontsize=14)
    ax.set_xticks(index + bar_width / 2)
    ax.set_xticklabels(sectors, rotation=20, ha='right', fontsize=11)
    ax.legend()

    plt.tight_layout()
    plt.show()

def climate_finance_gap_sectors_timeline():
    # Data in trillions
    years = np.array([2020, 2030, 2040, 2050])
    power_needs_trillions = np.array([1.95, 1.8, 1.4, 1.1])  # Converted to trillions
    transport_needs_trillions = np.array([0.38, 0.5, 0.9, 1.2])
    buildings_needs_trillions = np.array([0.66, 0.7, 0.5, 0.3])
    industry_needs_trillions = np.array([0.4, 0.7, 0.9, 1.5])

    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(years, power_needs_trillions, label='Power', marker='o')
    ax.plot(years, transport_needs_trillions, label='Transport', marker='o')
    ax.plot(years, buildings_needs_trillions, label='Buildings', marker='o')
    ax.plot(years, industry_needs_trillions, label='Industry', marker='o')

    # Add labels, title, and legend
    ax.set_xlabel('Year', fontsize=12)
    ax.set_ylabel('Investment Needs (in $ trillions)', fontsize=12)
    ax.set_title('Sectoral Financing Needs Over Time (2020-2050)', fontsize=14)
    ax.legend()

    plt.tight_layout()
    plt.show()

def csrd_timeline():

    # Data for the timeline
    dates = [datetime(2023, 1, 1), datetime(2024, 1, 1), datetime(2025, 1, 1), 
            datetime(2026, 1, 1), datetime(2028, 1, 1)]
    events = ['CSRD entered into force', 'NFRD large companies report', 
            'All large companies report', 'Listed SMEs report', 
            'Large non-EU companies report']

    # Create figure and axis
    fig, ax = plt.subplots(figsize=(10, 6))

    # Plotting the timeline
    ax.plot(dates, [1] * len(dates), "ro-")

    # Formatting the timeline
    for i, (date, event) in enumerate(zip(dates, events)):
        ax.text(date, 1.01, event, rotation=45, ha='right', va='bottom')

    ax.set_ylim(0.9, 1.2)  # Set y-limits for better visualization
    ax.get_yaxis().set_visible(False)  # Hide y-axis
    ax.xaxis.set_major_locator(mdates.YearLocator())  # Set major ticks at year intervals
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y'))  # Format dates as years

    # Title and labels
    ax.set_title('CSRD Timeline')
    plt.grid(False)

    # Show the plot
    plt.show()


def esg_vs_board_diversity():
    # Based on the information provided in the descriptive statistics and key findings, let's create a simplified comparison chart
    # for board diversity (gender and cultural) vs ESG score based on the available descriptive data.

    # Data for board diversity (gender and cultural) and ESG score extracted from Table 2
    data_diversity = {
        "Variable": ["ESG score", "Board gender diversity", "Board cultural diversity"],
        "Mean": [66.758, 23.942, 15.753],
        "Min": [39.650, 0.000, 5.560],
        "Max": [93.460, 58.330, 100.000]
    }

    # Creating a DataFrame
    df_diversity = pd.DataFrame(data_diversity)
    # Scatter Plot showing how board diversity (gender and cultural) affects ESG score
    fig, ax = plt.subplots(figsize=(8, 6))

    # Scatter plot with trend lines for board gender diversity and cultural diversity vs ESG score
    ax.scatter([23.942], [66.758], color='blue', label='Gender Diversity', s=100)
    ax.scatter([15.753], [66.758], color='green', label='Cultural Diversity', s=100)

    # Plotting a trend line for gender diversity and cultural diversity
    ax.plot([0, 60], [39.650, 93.460], color='blue', linestyle='--', label='Gender Diversity Trend')
    ax.plot([0, 100], [39.650, 93.460], color='green', linestyle='--', label='Cultural Diversity Trend')

    ax.set_xlabel('Diversity (%)')
    ax.set_ylabel('ESG Score')
    ax.set_title('Board Diversity vs ESG Score')
    ax.legend()

    plt.tight_layout()
    plt.show()

    # Line Chart with Error Bars showing board diversity compared to ESG score
    fig, ax = plt.subplots(figsize=(8, 6))

    # Line chart with error bars for diversity metrics and ESG score
    ax.errorbar(df_diversity['Variable'], df_diversity['Mean'], 
                yerr=[df_diversity['Mean'] - df_diversity['Min'], df_diversity['Max'] - df_diversity['Mean']], 
                fmt='-o', color='blue', ecolor='red', capsize=5)

    ax.set_ylabel('Values')
    ax.set_title('Diversity and ESG Score')
    plt.tight_layout()
    plt.show()

    # Box Plot to compare the distribution of ESG scores and diversity levels
    fig, ax = plt.subplots(figsize=(8, 6))

    # Box plot for ESG score, gender diversity, and cultural diversity
    ax.boxplot([df_diversity['Mean'], df_diversity['Min'], df_diversity['Max']], labels=['Mean', 'Min', 'Max'])
    ax.set_title('Comparison of ESG and Board Diversity')
    ax.set_ylabel('Values')

    plt.tight_layout()
    plt.show()

def fund_types_chart():
    data = {
        "Fund Type": ["Conventional ETF", "Conventional OEF", "SRI ETF", "SRI OEF"],
        "Mean AUM (Million USD)": [349, 503, 299, 555],
        "St. Dev. AUM (Million USD)": [447, 987, 479, 964],
        "Quartile 1 AUM (Million USD)": [67, 57, 33, 67],
        "Median AUM (Million USD)": [195, 172, 103, 199],
        "Quartile 3 AUM (Million USD)": [432, 495, 283, 590]
    }

    # Create DataFrame
    df = pd.DataFrame(data)

    # Plot the AUM statistics for each fund type
    fig, ax = plt.subplots(figsize=(10, 6))

    # Plotting each quartile and mean as a bar plot
    df.plot(x="Fund Type", y=["Mean AUM (Million USD)", "Quartile 1 AUM (Million USD)", "Median AUM (Million USD)", "Quartile 3 AUM (Million USD)"], kind="bar", ax=ax)

    # Adding labels and title
    ax.set_ylabel("AUM (Million USD)")
    ax.set_title("Assets Under Management (AUM) Statistics for Fund Types in 2019")

    # Display plot
    plt.xticks(rotation=45)
    plt.tight_layout()

    plt.show()

def msci_esg_leaders():
    # Load the files for MSCI ACWI and MSCI ACWI ESG Leaders data
    # Load both files into separate dataframes

    df_esg_new = pd.read_csv(os.path.join(data_dir, 'acwi-esg.csv'), skiprows=5)
    df_acwi_new = pd.read_csv(os.path.join(data_dir, 'acwi.csv'), skiprows=5)

    # Renaming the columns for clarity
    df_esg_new.columns = ['Date', 'ACWI ESG Leaders']
    df_acwi_new.columns = ['Date', 'ACWI']

    # Convert the date columns to datetime format and the index values to numeric
    df_esg_new['Date'] = pd.to_datetime(df_esg_new['Date'], format='%b %d, %Y', errors='coerce')
    df_esg_new['ACWI ESG Leaders'] = pd.to_numeric(df_esg_new['ACWI ESG Leaders'].str.replace(',', ''), errors='coerce')

    df_acwi_new['Date'] = pd.to_datetime(df_acwi_new['Date'], format='%b %d, %Y', errors='coerce')
    df_acwi_new['ACWI'] = pd.to_numeric(df_acwi_new['ACWI'].str.replace(',', ''), errors='coerce')

    # Merge the two dataframes on the date column for comparison
    df_combined_new = pd.merge(df_esg_new, df_acwi_new, on='Date')

    # Drop missing values if any
    df_combined_new.dropna(inplace=True)

    # Calculate cumulative returns
    df_combined_new['ACWI_cumulative_return'] = (df_combined_new['ACWI'] / df_combined_new['ACWI'].iloc[0]) * 100
    df_combined_new['ACWI_ESG_cumulative_return'] = (df_combined_new['ACWI ESG Leaders'] / df_combined_new['ACWI ESG Leaders'].iloc[0]) * 100

    # Plot the cumulative returns for both indices without markers for a clean comparison
    plt.figure(figsize=(10, 6))
    plt.plot(df_combined_new['Date'], df_combined_new['ACWI_cumulative_return'], label='MSCI ACWI Cumulative Return', linewidth=1, color='blue')
    plt.plot(df_combined_new['Date'], df_combined_new['ACWI_ESG_cumulative_return'], label='MSCI ACWI ESG Leaders Cumulative Return', linewidth=1, color='red')
    plt.xlabel('Year')
    plt.ylabel('Cumulative Return (Base 100)')
    plt.title('Cumulative Return for MSCI ACWI vs ESG Leaders')
    plt.legend()
    plt.grid(True)
    plt.show()

def crypto_sustainability():
    # Data
    assets = ['Polygon', 'Cardano', 'Stellar', 'XRP', 'Developed Index', 'Emerging Index', 'Solar', 'Wind', 'POWR', 'GRID+', 'ELEC', 'SNC']
    correlations = [0.05, 0.00, -0.07, -0.09, -0.03, 0.00, 0.00, -0.05, -0.05, 0.06, 0.00, -0.01]

    # Positive, negative, and neutral correlation values for the stacked bar chart
    positive_corr = [c if c > 0 else 0 for c in correlations]
    negative_corr = [c if c < 0 else 0 for c in correlations]
    neutral_corr = [c if c == 0 else 0 for c in correlations]

    # Bubble sizes for the bubble chart
    bubble_sizes = [abs(c) * 1000 for c in correlations]

    # 1. Stacked Bar Chart
    plt.figure(figsize=(10, 6))
    plt.bar(assets, positive_corr, label='Positive', color='green')
    plt.bar(assets, neutral_corr, bottom=positive_corr, label='Neutral', color='gray')
    plt.bar(assets, negative_corr, bottom=[p+n for p, n in zip(positive_corr, neutral_corr)], label='Negative', color='red')
    plt.xticks(rotation=45, ha='right')
    plt.title('Correlation Types for Each Asset')
    plt.ylabel('Correlation')
    plt.legend()
    plt.tight_layout()
    plt.show()

def uk_energy_emissions_trend():
    # Assuming fuel_emissions dataset is already loaded
    # Rename the "Fuel Type" column to "Year" for clarity
    fuel_emissions = pd.read_csv(os.path.join(data_dir, 'uk-energy-type.csv'))
    fuel_emissions.rename(columns={'Fuel Type': 'Year'}, inplace=True)

    # Plot CO₂ Emissions by Fuel Sources (Gas, Oil, Coal, etc.)
    plt.figure(figsize=(10, 6))
    plt.plot(fuel_emissions['Year'], fuel_emissions['Coal'], label='Coal')
    plt.plot(fuel_emissions['Year'], fuel_emissions['Oil'], label='Oil')
    plt.plot(fuel_emissions['Year'], fuel_emissions['Gas'], label='Gas')
    plt.plot(fuel_emissions['Year'], fuel_emissions['Other solid fuels'], label='Other solid fuels')
    plt.title('UK CO₂ Emissions by Fuel Sources (1990-2017)')
    plt.xlabel('Year')
    plt.ylabel('CO₂ Emissions (MtCO2)')
    plt.legend(loc='upper right')
    plt.grid(True)
    plt.show()

def econ_history_chart():
    # Data for the timeline: list of tuples (year, theory)
    timeline_data = [
        (1776, "Classical Economics - Adam Smith"),
        (1817, "Comparative Advantage - David Ricardo"),
        (1867, "Marxism - Karl Marx"),
        (1871, "Marginalism - William Stanley Jevons, Carl Menger"),
        (1890, "Neoclassical Economics - Alfred Marshall"),
        (1936, "Keynesian Economics - John Maynard Keynes"),
        (1950, "Monetarism - Milton Friedman"),
        (1944, "Game Theory - John von Neumann, Oskar Morgenstern"),
        (1979, "Behavioral Economics - Daniel Kahneman, Amos Tversky"),
        (1990, "Ecological Economics - Herman Daly"),
        (2017, "Doughnut Economics - Kate Raworth"),
        (2015, "Regenerative Capitalism - John Fullerton"),
        (2003, "Degrowth - Serge Latouche"),
        (1942, "Creative Destruction - Joseph Schumpeter"),
        (1960, "Coase Theorem - Ronald Coase"),
        (1990, "Governing the Commons - Elinor Ostrom"),
        (1964, "Economics of Human Behavior - Gary Becker"),
        (1958, "The Affluent Society - John Kenneth Galbraith"),
        (1980, "Capability Approach - Amartya Sen"),
        (1944, "Spontaneous Order - Friedrich Hayek"),
        (2013, "Capital in the Twenty-First Century - Thomas Piketty"),
        (1956, "Solow Growth Model - Robert Solow"),
        (1990, "Institutional Economics - Douglass North"),
        (1990, "Endogenous Growth Theory - Paul Romer"),
        (1933, "Imperfect Competition - Joan Robinson")
    ]

    # Separate years and theories for plotting
    years, theories = zip(*timeline_data)

    # Create the timeline chart
    plt.figure(figsize=(6, 12))
    plt.scatter([1] * len(years), years, color='blue', s=100)

    # Add labels for each theory, ensuring no overlap
    for i, theory in enumerate(theories):
        plt.text(1.02, years[i], theory, va='center', fontsize=9)

    # Customize the chart
    plt.xticks([])
    plt.yticks(years)
    plt.title("Timeline of Notable Economic Theories and Authors", pad=20)
    plt.ylabel("Year")
    plt.grid(True, axis='y', linestyle='--', alpha=0.7)

    # Display the chart
    plt.tight_layout()
    plt.show()


def climate_scenarios_chart():
    # Creating the actual data based on the table "Summary of the main results of the different scenarios"
    data_real = {
        'Year': [2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100],
        'Degrowth_CO2': [580, 500, 400, 300, 250, 200, 150, 100, 50],
        'IPCC_CO2': [600, 580, 550, 520, 480, 450, 420, 400, 380],
        'Dec_Extreme_CO2': [577, 540, 500, 460, 420, 380, 340, 300, 260],
        'Degrowth_Temp': [1.5, 1.45, 1.4, 1.35, 1.3, 1.25, 1.2, 1.15, 1.1],
        'IPCC_Temp': [1.5, 1.55, 1.6, 1.65, 1.7, 1.75, 1.8, 1.85, 1.9],
        'Dec_Extreme_Temp': [1.5, 1.48, 1.45, 1.43, 1.4, 1.37, 1.35, 1.32, 1.3]
    }

    # Converting to a DataFrame
    df_real = pd.DataFrame(data_real)

    # Plotting the real CO2 and temperature change pathways
    fig, ax1 = plt.subplots(figsize=(10, 6))

    # Plotting CO2 emissions for each scenario
    ax1.plot(df_real['Year'], df_real['Degrowth_CO2'], label='Degrowth CO2', marker='o')
    ax1.plot(df_real['Year'], df_real['IPCC_CO2'], label='IPCC CO2', marker='o')
    ax1.plot(df_real['Year'], df_real['Dec_Extreme_CO2'], label='Dec-Extreme CO2', marker='o')

    # Labeling the first y-axis
    ax1.set_xlabel('Year')
    ax1.set_ylabel('CO2 Emissions (GtCO2)')
    ax1.grid(True)
    ax1.legend(loc='upper left')

    # Creating a secondary axis for temperature change
    ax2 = ax1.twinx()

    # Plotting temperature change
    ax2.plot(df_real['Year'], df_real['Degrowth_Temp'], label='Degrowth Temp Change', linestyle='--')
    ax2.plot(df_real['Year'], df_real['IPCC_Temp'], label='IPCC Temp Change', linestyle='--')
    ax2.plot(df_real['Year'], df_real['Dec_Extreme_Temp'], label='Dec-Extreme Temp Change', linestyle='--')

    # Adding temperature labels directly on the chart
    for i, txt in enumerate(df_real['Degrowth_Temp']):
        ax2.annotate(f'{txt}°C', (df_real['Year'][i], df_real['Degrowth_Temp'][i]), textcoords="offset points", xytext=(0,10), ha='center')
    for i, txt in enumerate(df_real['IPCC_Temp']):
        ax2.annotate(f'{txt}°C', (df_real['Year'][i], df_real['IPCC_Temp'][i]), textcoords="offset points", xytext=(0,10), ha='center')
    for i, txt in enumerate(df_real['Dec_Extreme_Temp']):
        ax2.annotate(f'{txt}°C', (df_real['Year'][i], df_real['Dec_Extreme_Temp'][i]), textcoords="offset points", xytext=(0,10), ha='center')

    # Labeling the second y-axis
    ax2.set_ylabel('Temperature Change (°C)')
    ax2.legend(loc='upper right')

    # Adding a title
    plt.title('Real CO2 Emissions and Temperature Change Pathways (2020-2100)')

    # Displaying the plot
    plt.show()

def crypto_pricing_theories():
    # Data for trends in research focus over time (2015-2022)
    years_trend = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022]
    pricing_theories = [5, 6, 8, 15, 18, 25, 46, 42]
    forecasting = [2, 3, 6, 10, 15, 21, 35, 30]
    influence_factors = [1, 2, 4, 7, 12, 18, 28, 32]
    other_focus = [3, 4, 5, 6, 9, 10, 14, 16]

    # Labels for the focus areas
    labels = ['Pricing Theories', 'Forecasting', 'Influence Factors', 'Other Focus']

    # Combine the data into an array for the heatmap
    focus_data = np.array([pricing_theories, forecasting, influence_factors, other_focus])

    # Plot the heatmap
    plt.figure(figsize=(10, 6))
    plt.imshow(focus_data, cmap='YlGnBu', aspect='auto', interpolation='nearest')

    # Add colorbar and labels
    plt.colorbar(label='Number of Publications')
    plt.xticks(ticks=np.arange(len(years_trend)), labels=years_trend)
    plt.yticks(ticks=np.arange(len(labels)), labels=labels)
    plt.title('Research Focus Over Time (2015-2022)')
    plt.xlabel('Year')
    plt.ylabel('Research Focus')

    # Show the heatmap
    plt.show()

def companies_triple_perf():
    categories_tsr = [
        "Triple outperformers",
        "Profit and growth outperformers, ESG laggard",
        "ESG and growth outperformers, profit laggard",
        "Profit and ESG outperformers, growth laggard",
        "Profit, growth, and ESG laggard"
    ]
    tsr_values = [7, 5, 3, -1, -5]

    plt.figure(figsize=(10, 6))
    plt.plot(categories_tsr, tsr_values, marker='o', linestyle='-', color='blue', label="Excess TSR (%)")

    plt.title('Excess TSR for Different Performance Categories')
    plt.xlabel('Performance Category')
    plt.ylabel('Excess TSR (%)')
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.show()

def retail_green_vs_nongreen():
    # Data for investment share
    invest_share = [44, 56]  # 44% in green, rest non-green
    labels = ['Green Projects', 'Non-Green Projects']
    colors = ['#66b3ff', '#ff9999']

    # Creating the Donut Chart (Pie Chart with a hole in the middle)
    plt.figure(figsize=(6,6))
    plt.pie(invest_share, labels=labels, autopct='%1.1f%%', colors=colors, startangle=90, wedgeprops={'width': 0.3})
    plt.title('Investment Share in Green vs Non-Green Projects')
    plt.show()

def bitcoin_vs_gold_futures():
    # Load the Bitcoin and Gold data files
    bitcoin_data = pd.read_csv(os.path.join(data_dir, 'bitcoin-spot.csv'))
    gold_data = pd.read_csv(os.path.join(data_dir, 'gold-futures.csv'))

    # Convert 'Date' columns to datetime
    bitcoin_data['Date'] = pd.to_datetime(bitcoin_data['Date'], format='%m/%d/%Y')
    gold_data['Date'] = pd.to_datetime(gold_data['Date'], format='%m/%d/%Y')

    # Sort both datasets by date
    bitcoin_data = bitcoin_data.sort_values(by='Date')
    gold_data = gold_data.sort_values(by='Date')

    # Extract relevant columns for comparison: Date and Price
    bitcoin_prices = bitcoin_data[['Date', 'Price']].copy()
    gold_prices = gold_data[['Date', 'Price']].copy()

    # Convert Price columns to numeric
    bitcoin_prices['Price'] = pd.to_numeric(bitcoin_prices['Price'].str.replace(',', ''))
    gold_prices['Price'] = pd.to_numeric(gold_prices['Price'].str.replace(',', ''))

    # Merge both datasets on Date
    combined_data = pd.merge(bitcoin_prices, gold_prices, on='Date', how='inner', suffixes=('_Bitcoin', '_Gold'))

    # Calculate percentage change from the initial price for both Bitcoin and Gold
    combined_data['Pct_Change_Bitcoin'] = (combined_data['Price_Bitcoin'].pct_change()) * 100
    combined_data['Pct_Change_Gold'] = (combined_data['Price_Gold'].pct_change()) * 100

    # Plot the percentage change
    plt.figure(figsize=(12, 6))
    plt.plot(combined_data['Date'], combined_data['Pct_Change_Bitcoin'], label='Bitcoin % Change', color='blue')
    plt.plot(combined_data['Date'], combined_data['Pct_Change_Gold'], label='Gold % Change', color='gold')
    plt.xlabel('Date')
    plt.ylabel('Percentage Change (%)')
    plt.title('Percentage Change Comparison: Bitcoin vs Gold')
    plt.legend()
    plt.grid(True)
    plt.xticks(rotation=45)
    plt.tight_layout()

    plt.show()

def slavery_laws():
    # Data for the timeline (years of adoption of modern slavery acts or related laws)
    countries = [
        "United Kingdom (Modern Slavery Act)", 
        "France (Duty of Vigilance Law)", 
        "United States (CA Trafficking Victims Act)", 
        "Australia (Modern Slavery Act)", 
        "Canada (ON Human Trafficking Act)", 
        "New Zealand (Modern Slavery Bill)",
        "California (Transparency in Supply Chains Act)", 
        "European Union (Non-Financial Reporting Directive)", 
        "Netherlands (Child Labour Due Diligence Act)", 
        "Germany (Supply Chain Due Diligence Act)", 
        "Norway (Transparency Act)", 
        "Brazil (Dirty List Law)", 
        "Switzerland (Responsible Business Initiative - Rejected)"
    ]
    years = [2015, 2017, 2012, 2018, 2017, 2023, 2010, 2014, 2019, 2021, 2021, 2003, 2020]

    # Adding the related UN SDG 8.7 for reference
    sdg_year = 2015
    sdg_description = "UN SDG 8.7 (Adopted)"

    # Adjust the countries list to include the SDG at the bottom
    countries_with_sdg = countries + [sdg_description]

    # Create the updated timeline plot
    plt.figure(figsize=(10, 8))

    # Plot the countries and years, making the rejected Swiss initiative red
    for i, (year, country) in enumerate(zip(years, countries)):
        color = 'red' if "Rejected" in country else 'blue'
        plt.scatter(year, country, color=color, s=100, zorder=5)
        plt.text(year + 0.4, i, f"{year}", verticalalignment='center', fontsize=10)  # Adjusting label position slightly more

    # Add the UN SDG 8.7 point in blue
    plt.scatter(sdg_year, len(countries), color='blue', s=150, zorder=10, label="UN SDG 8.7")
    plt.text(sdg_year + 0.4, len(countries), f"{sdg_year}", verticalalignment='center', fontsize=10)

    # Add labels and title
    plt.title('Timeline of Global Modern Slavery Laws', fontsize=14)
    plt.xlabel('Year of Adoption', fontsize=12)
    plt.xticks(range(min(years), max(years) + 1, 2))  # Keep only full years on x-axis
    plt.yticks(range(len(countries_with_sdg)), countries_with_sdg)
    plt.grid(True, linestyle='--', alpha=0.6)

    # Show the chart
    plt.tight_layout()
    plt.show()

def slavery_map():
    # Create a figure with a global projection (PlateCarree, which shows the whole world)
    fig = plt.figure(figsize=(12, 6))
    ax = plt.axes(projection=ccrs.PlateCarree())

    # Add basic map features: land, coastlines, and borders
    ax.add_feature(cfeature.LAND)
    ax.add_feature(cfeature.COASTLINE)
    ax.add_feature(cfeature.BORDERS, linestyle=':')

    # Set global extent to show the entire world
    ax.set_global()

    # Data for regions and illegal profits
    data = {
        "Asia and the Pacific": {"coords": [34.0479, 100.6197], "profits": 62.4},
        "Europe and Central Asia": {"coords": [50.1109, 8.6821], "profits": 84.2},
        "Africa": {"coords": [-8.7832, 34.5085], "profits": 19.8},
        "Americas": {"coords": [37.0902, -95.7129], "profits": 52.1},
        "Arab States": {"coords": [23.4241, 53.8478], "profits": 18.0},
    }

    # Add markers and labels for each region
    for region, info in data.items():
        ax.plot(info["coords"][1], info["coords"][0], marker='o', color='red', markersize=info['profits'] / 5, transform=ccrs.PlateCarree())
        plt.text(info["coords"][1] + 7, info["coords"][0] - 2, f"{region}: {info['profits']}B", 
                transform=ccrs.PlateCarree(), fontsize=12, weight='bold', color='black', bbox=dict(facecolor='white', alpha=0.7))

    # Set title
    plt.title("Illegal Profits from Forced Labor by Region", fontsize=15)
    plt.show()

def msci_board_sustainability_experts():
    # Data for Climate Expertise by Type
    expertise_types = ['Executive-Level Experience', 'Designations and Qualifications', 'Professional Network', 
                    'Public-Sector Expert', 'Academic', 'Consultant']
    expertise_percentages = [50, 20, 10, 5, 10, 5]  # Example percentages

    # Data for Number of Climate Experts per Firm
    num_experts = ['No Experts', 'One Expert', 'Two Experts', 'Three or More Experts']
    num_expert_firms = [107, 39, 10, 8]  # Number of firms

    # Data for Regional Distribution
    regions = ['EMEA', 'Americas', 'APAC']
    region_percentages = [48, 36, 20]  # Percentages of firms with at least one climate expert

    # Data for Sector Analysis
    sectors = ['Energy', 'Materials', 'Utilities', 'Industrials', 'Consumer Discretionary', 'Consumer Staples']
    sector_percentages = [44, 35, 30, 25, 22, 20]  # Percentages of firms with at least one climate expert

    # Create Subplots
    fig, axs = plt.subplots(2, 2, figsize=(14, 10))
    fig.suptitle('Climate Expertise on Boards', fontsize=16)

    # Climate Expertise by Type
    sns.barplot(x=expertise_types, y=expertise_percentages, ax=axs[0, 0], palette='viridis')
    axs[0, 0].set_title('Climate Expertise by Type')
    axs[0, 0].set_ylabel('Percentage (%)')
    axs[0, 0].set_xticklabels(expertise_types, rotation=45, ha='right')

    # Number of Climate Experts per Firm
    axs[0, 1].pie(num_expert_firms, labels=num_experts, autopct='%1.1f%%', colors=sns.color_palette('pastel'), startangle=140)
    axs[0, 1].set_title('Number of Climate Experts per Firm')

    # Regional Distribution of Climate Expertise
    sns.barplot(x=regions, y=region_percentages, ax=axs[1, 0], palette='magma')
    axs[1, 0].set_title('Regional Distribution of Climate Expertise')
    axs[1, 0].set_ylabel('Percentage (%)')

    # Sector Analysis of Climate Expertise
    sns.barplot(x=sectors, y=sector_percentages, ax=axs[1, 1], palette='coolwarm')
    axs[1, 1].set_title('Sector Analysis of Climate Expertise')
    axs[1, 1].set_ylabel('Percentage (%)')
    axs[1, 1].set_xticklabels(sectors, rotation=45, ha='right')

    # Adjust layout
    plt.tight_layout(rect=[0, 0, 1, 0.96])

    # Show plot
    plt.show()

def companies_large_emitters_criteria():
    # Corrected data for the chart
    audit_assessment_data = {
        'No, does not meet any criteria': 84,
        'Partial, meets some criteria': 56
    }

    # Convert dictionary to values for plotting
    labels = list(audit_assessment_data.keys())
    sizes = list(audit_assessment_data.values())

    # Define colors
    colors = ['#ff6666', '#ffcc66', '#66b3ff', '#99ff99']

    # Function to display both percentage and actual counts
    def autopct_format(values):
        def my_format(pct):
            total = sum(values)
            val = int(round(pct * total / 100.0))
            return f'{pct:.1f}%\n({val:d})'
        return my_format

    # Create the donut chart
    plt.figure(figsize=(8, 8))
    plt.pie(sizes, labels=labels, autopct=autopct_format(sizes),
            startangle=90, colors=colors, wedgeprops={'linewidth': 3, 'edgecolor': 'white'})

    # Add a center circle to make it a donut
    center_circle = plt.Circle((0, 0), 0.70, fc='white')
    plt.gca().add_artist(center_circle)

    # Set title and layout
    plt.title('Overall Accounting and Audit Assessment')
    plt.tight_layout()

    # Show the chart
    plt.show()

def companies_large_emitters_climate_experts():
    # Data for the donut chart with company numbers and adjusted colors to show gravity of the situation
    labels = ['No climate experts (107 firms)', 'One climate expert (39 firms)', 'Two climate experts (10 firms)', 'Three or more climate experts (8 firms)']
    sizes = [107, 39, 10, 8]
    colors = ['#d73027', '#fc8d59', '#fee08b', '#91cf60']  # Colors reflecting severity: red for lack of experts, green for more

    # Create a donut chart with gravity-emphasized colors
    plt.figure(figsize=(8, 8))
    plt.pie(sizes, labels=labels, autopct='%1.0f%%', startangle=90, colors=colors, wedgeprops={'width': 0.3})

    # Title for the chart
    plt.title('Firms by Number of Climate Experts')

    # Display the chart
    plt.show()

def sustainable_consumption_relationships():
    # Path Coefficients for the relationships
    path_relationships = ['EK -> SC', 'RP -> SC', 'EC -> SC', 'BI -> SC']
    path_coefficients = [0.179, 0.107, 0.113, 0.191]  # Real data from the document

    # R² values for variance explanation
    variance_explained = {
        'Environmental Concern (EC)': 0.322,
        'Behavioral Intention (BI)': 0.234,
        'Sustainable Consumption (SC)': 0.289
    }

    # Importance-Performance data
    importance = [0.179, 0.107, 0.113, 0.191]
    performance = [53.124, 64.018, 57.197, 43.870]
    factors = ['Environmental Knowledge', 'Risk Perception', 'Environmental Concern', 'Behavioral Intention']

    # 1. Bar Chart: Path Coefficients
    plt.figure(figsize=(8, 6))
    plt.barh(path_relationships, path_coefficients, color=['blue', 'green', 'red', 'orange'])
    plt.title('Path Coefficients for Factors Influencing Sustainable Consumption')
    plt.xlabel('Path Coefficient')
    plt.tight_layout()
    plt.show()

    # 2. Flow Chart for Mediation
    fig, ax = plt.subplots(figsize=(10, 6))

    # Draw arrows based on path coefficients
    ax.arrow(0.1, 0.9, 0.3, 0, head_width=0.05, head_length=0.03, fc='blue', ec='blue', lw=path_coefficients[0]*10)
    ax.arrow(0.1, 0.7, 0.3, 0, head_width=0.05, head_length=0.03, fc='green', ec='green', lw=path_coefficients[1]*10)
    ax.arrow(0.1, 0.5, 0.3, 0, head_width=0.05, head_length=0.03, fc='red', ec='red', lw=path_coefficients[2]*10)
    ax.arrow(0.1, 0.3, 0.3, 0, head_width=0.05, head_length=0.03, fc='orange', ec='orange', lw=path_coefficients[3]*10)

    # Labeling
    ax.text(0.05, 0.9, 'Environmental Knowledge (EK)', fontsize=12)
    ax.text(0.05, 0.7, 'Risk Perception (RP)', fontsize=12)
    ax.text(0.05, 0.5, 'Environmental Concern (EC)', fontsize=12)
    ax.text(0.05, 0.3, 'Behavioral Intention (BI)', fontsize=12)

    ax.text(0.5, 0.5, 'Sustainable Consumption Behavior (SC)', fontsize=12, color='black', bbox=dict(facecolor='lightgray', edgecolor='black'))

    plt.axis('off')
    plt.title('Mediation Flow Chart for Sustainable Consumption')
    plt.tight_layout()
    plt.show()

    # 3. Importance-Performance Map
    plt.figure(figsize=(8, 6))
    plt.scatter(importance, performance, s=200, alpha=0.7)
    for i, factor in enumerate(factors):
        plt.text(importance[i], performance[i], factor, fontsize=12)
    plt.title('Importance-Performance Matrix')
    plt.xlabel('Importance (Path Coefficients)')
    plt.ylabel('Performance')
    plt.grid(True)
    plt.tight_layout()
    plt.show()

    # 4. Variance Explained Pie Chart
    plt.figure(figsize=(8, 6))
    plt.pie(variance_explained.values(), labels=variance_explained.keys(), autopct='%1.1f%%', colors=['yellow', 'lightblue', 'lightgreen'])
    plt.title('Variance Explained by Factors')
    plt.tight_layout()
    plt.show()


def air_quality_southasia_vs_taiwan():

    df = pd.read_csv(os.path.join(data_dir, 'aqli_global.csv'))
    countries = ['India', 'Bangladesh', 'Pakistan', 'Taiwan']
    years = list(range(1998, 2023))
    
    plt.figure()
    for country in countries:
        row = df[df['name'] == country]
        if row.empty:
            continue
        pm_values = [row[f'pm{year}'].values[0] for year in years]
        plt.plot(years, pm_values, label=country)

    plt.xlabel('Year')
    plt.ylabel('PM2.5 concentration (µg/m³)')
    plt.title('PM2.5 Trends: ' + ', '.join(countries) + ' (1998–2022)')
    plt.legend()
    plt.tight_layout()
    plt.show()
