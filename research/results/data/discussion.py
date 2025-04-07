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
app_uninstalls_csv_path = os.path.join(script_dir, 'app-uninstalls.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
chinese_font = FontProperties(fname=font_path, size=12)

def app_installs():
    # Load and clean installs
    df_installs = pd.read_csv(app_installs_csv_path, skiprows=1)
    df_installs["Date"] = pd.to_datetime(df_installs["Date"])
    df_installs["Installs"] = pd.to_numeric(df_installs["Installs"], errors="coerce")
    df_installs = df_installs[df_installs["Installs"] > 0]
    df_installs_monthly = df_installs.set_index("Date").resample("M").sum().reset_index()
    df_installs_monthly = df_installs_monthly[df_installs_monthly["Date"] < pd.to_datetime("2025-05-01")]
    df_installs_monthly["Cumulative Installs"] = df_installs_monthly["Installs"].cumsum()

    # Load and clean uninstalls
    app_uninstalls_csv_path = os.path.join(script_dir, 'app-uninstalls.csv')
    df_uninstalls = pd.read_csv(app_uninstalls_csv_path, skiprows=1)
    df_uninstalls["Date"] = pd.to_datetime(df_uninstalls["Date"])
    df_uninstalls["Uninstalls"] = pd.to_numeric(df_uninstalls["Uninstalls"], errors="coerce")
    df_uninstalls = df_uninstalls[df_uninstalls["Uninstalls"] > 0]
    df_uninstalls_monthly = df_uninstalls.set_index("Date").resample("M").sum().reset_index()
    df_uninstalls_monthly = df_uninstalls_monthly[df_uninstalls_monthly["Date"] < pd.to_datetime("2025-05-01")]
    df_uninstalls_monthly["Cumulative Uninstalls"] = df_uninstalls_monthly["Uninstalls"].cumsum()

    # Merge for combined view
    df_combined = pd.merge(df_installs_monthly, df_uninstalls_monthly, on="Date", how="outer").fillna(0)
    df_combined = df_combined.sort_values("Date")

    # Plot
    plt.figure(figsize=(14, 7))
    plt.bar(df_combined["Date"], df_combined["Installs"], width=20, label="Monthly Installs", color="green", alpha=0.7)
    plt.bar(df_combined["Date"], df_combined["Uninstalls"], width=20, label="Monthly Uninstalls", color="red", alpha=0.5)

    plt.plot(df_combined["Date"], df_combined["Cumulative Installs"], color="green", marker='o', linewidth=2, label="Cumulative Installs")
    plt.plot(df_combined["Date"], df_combined["Cumulative Uninstalls"], color="red", marker='o', linewidth=2, label="Cumulative Uninstalls")

    # Annotate cumulative values clearly
    for idx, row in df_combined.iterrows():
        plt.text(row["Date"], row["Cumulative Installs"] + 6, int(row["Cumulative Installs"]),
                 ha='center', va='bottom', fontsize=9, color='green')
        if row["Cumulative Uninstalls"] > 0:
            plt.text(row["Date"], row["Cumulative Uninstalls"] + 2, int(row["Cumulative Uninstalls"]),
                     ha='center', va='bottom', fontsize=9, color='red')

    # Format axis
    plt.title("Monthly Installs vs Uninstalls (Up to April 2025)", fontsize=16)
    plt.xlabel("Month", fontsize=12)
    plt.ylabel("Count", fontsize=12)
    plt.grid(axis='y', linestyle='--', alpha=0.6)
    plt.gca().set_xticks(df_combined["Date"])
    plt.gca().xaxis.set_major_formatter(DateFormatter("%Y-%m"))
    plt.xticks(rotation=45, ha='right')
    plt.legend()
    plt.tight_layout()
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
