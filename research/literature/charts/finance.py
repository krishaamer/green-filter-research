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
