import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

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

