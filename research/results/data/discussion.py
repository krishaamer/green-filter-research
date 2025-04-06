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

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
df = pd.read_csv(csv_path)
chinese_font = FontProperties(fname=font_path, size=12)

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