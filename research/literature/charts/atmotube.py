import pandas as pd
import matplotlib.pyplot as plt

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
