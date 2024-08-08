import matplotlib.pyplot as plt
import numpy as np
import matplotlib.font_manager as fm
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
            "Revolut Launches stocks, ETFs, bonds and crypto investing"
        ]
    }

    # Creating a new DataFrame
    df_new_events = pd.DataFrame(new_events)

    # Convert dates to datetime format for plotting
    df_new_events['Date'] = pd.to_datetime(df_new_events['Date'])

    # Plotting with the new events
    plt.figure(figsize=(18, 8))
    plt.plot(df_new_events['Date'], [1] * len(df_new_events), 'ro')  # Plot points
    plt.yticks([])  # Remove y-axis ticks
    plt.gca().get_yaxis().set_visible(False)  # Hide y-axis

    # Adding relevant dates manually for clearer spacing
    relevant_dates = pd.to_datetime(["2010-01-01", "2014-01-01", "2020-12-01", "2021-01-01", "2023-01-01", "2023-11-01", "2024-01-01"])
    relevant_labels = ["2010", "2014", "Dec 2020", "Jan 2021", "Jan 2023", "Nov 2023", "Jan 2024"]

    # Setting x-axis with specific relevant years and improving text size
    plt.xticks(relevant_dates, relevant_labels, rotation=45, ha='right', fontsize=12)

    # Adding annotations with better spacing and multiple lines
    for i, (date, event) in enumerate(zip(df_new_events['Date'], df_new_events['Event'])):
        plt.annotate('\n'.join(event.split(' ')), (date, 1), textcoords="offset points", xytext=(0,20), ha='center', rotation=45, fontsize=12)

    plt.title('Timeline of Events', fontsize=14)
    plt.grid(axis='x', linestyle='--')
    plt.tight_layout()
    plt.show()

