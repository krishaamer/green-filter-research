import warnings
warnings.filterwarnings("ignore")

from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
import geopandas as gpd
import contextily as ctx
from shapely.geometry import Point
from matplotlib.dates import DateFormatter

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
app_installs_csv_path = os.path.join(script_dir, 'app-installs.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
chinese_font = FontProperties(fname=font_path, size=12)

def app_installs():
    # Load your data
    df = pd.read_csv(app_installs_csv_path, skiprows=1)
    df["Date"] = pd.to_datetime(df["Date"])
    df["Installs"] = pd.to_numeric(df["Installs"], errors="coerce")

    # Filter from the first non-zero install
    df = df[df["Installs"] > 0]

    # Group by month, remove May 2025 and later
    df_monthly = df.set_index("Date").resample("M").sum().reset_index()
    df_monthly = df_monthly[df_monthly["Date"] < pd.to_datetime("2025-05-01")]
    df_monthly["Cumulative"] = df_monthly["Installs"].cumsum()

    # Plot
    plt.figure(figsize=(14, 7))
    bars = plt.bar(df_monthly["Date"], df_monthly["Installs"], width=20, label="Monthly Installs")
    plt.plot(df_monthly["Date"], df_monthly["Cumulative"], color='orange', marker='o', linewidth=2, label="Cumulative Installs")

    # Add labels
    for idx, row in df_monthly.iterrows():
        plt.text(row["Date"], row["Installs"] + 2, str(row["Installs"]), ha='center', va='bottom', fontsize=9)
        plt.text(row["Date"], row["Cumulative"] + 5, str(row["Cumulative"]), ha='center', va='bottom', fontsize=9, color='orange')

    # Set clean x-axis
    plt.xlim([df_monthly["Date"].min() - pd.Timedelta(days=15), df_monthly["Date"].max() + pd.Timedelta(days=15)])
    plt.gca().set_xticks(df_monthly["Date"])
    plt.gca().xaxis.set_major_formatter(DateFormatter("%Y-%m"))
    plt.xticks(rotation=45)

    # Labels and legend
    plt.title("Monthly and Cumulative App Installs (Up to April 2025)", fontsize=16)
    plt.xlabel("Month", fontsize=12)
    plt.ylabel("Number of Installs", fontsize=12)
    plt.grid(axis='y', linestyle='--', alpha=0.6)
    plt.legend()
    plt.tight_layout()

    # Show
    plt.show()


def testing_map():
    # Load Taiwan shape
    url = "https://naturalearth.s3.amazonaws.com/10m_cultural/ne_10m_admin_0_countries.zip"
    world = gpd.read_file(url)
    taiwan = world[world.ADMIN == "Taiwan"].to_crs(epsg=3857)

    # University data with updated STUST offset
    universities = [
        ("國立中興大學 (NCHU)", 24.1232, 120.6740, 3000, 3000, 'left'),
        ("國立中正大學 (CCU)", 23.5637, 120.4720, 3000, 3000, 'left'),
        ("國立成功大學 (NCKU)", 22.9966, 120.2199, 4000, -6000, 'left'),
        ("國立臺南藝術大學 (TNUA)", 23.1163, 120.2551, 4000, 0, 'left'),
        ("長榮大學 (CJCU)", 22.8837, 120.2659, 3000, 0, 'left'),
        ("南臺科技大學 (STUST)", 22.9756, 120.2256, 4000, 4000, 'left'),  # aligned with NCKU
        ("國立屏東科技大學 (NPUST)", 22.6437, 120.5965, 3000, 3000, 'left'),
    ]

    # Extract data
    coords = [(lon, lat) for _, lat, lon, _, _, _ in universities]
    labels = [name for name, _, _, _, _, _ in universities]
    offsets = [(dx, dy) for _, _, _, dx, dy, _ in universities]
    haligns = [ha for _, _, _, _, _, ha in universities]

    # Create GeoDataFrame
    points = gpd.GeoDataFrame(geometry=[Point(xy) for xy in coords], crs="EPSG:4326").to_crs(epsg=3857)

    # Plot map
    fig, ax = plt.subplots(figsize=(10, 14))
    taiwan.plot(ax=ax, color='lightgreen', edgecolor='black')
    points.plot(ax=ax, color='red', markersize=80)

    # Add labels
    for pt, label, (dx, dy), ha in zip(points.geometry, labels, offsets, haligns):
        ax.text(pt.x + dx, pt.y + dy, label, fontsize=9, ha=ha, va='bottom', fontproperties=tc_font)

    # Basemap
    ctx.add_basemap(ax, source=ctx.providers.Stamen.TerrainBackground, zoom=8)

    # Title & layout
    ax.set_title("In-Person Testing Locations", fontsize=16, fontproperties=tc_font)
    ax.axis('off')
    plt.show()
