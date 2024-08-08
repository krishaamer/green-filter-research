import pandas as pd
import matplotlib.pyplot as plt

def company_rank_chart():

    # Data for the chart
    data_sustainability = {
        "Rank": [24, 63, 68, 80, 91, 92, 108, 200, 300, 301, 344, 356, 395, 409, 416, 421, 497],
        "Company": ["Delta Electronics", "Taishin Holdings", "Fubon Financial", "Chunghwa Telecom", 
                    "Yuanta Financial Holdings", "Cathay Financial Holdings", "Taiwan Mobile", "First Financial Holding", 
                    "Far EasTone", "SinoPac Holdings", "Wistron", "Acer", "Nanya Technology", "InnoLux", 
                    "Wiwynn", "Taiwan Cement", "Advantech"],
        "Score": [77.18, 73.50, 73.01, 71.69, 70.94, 70.79, 69.72, 64.17, 60.04, 60.04, 58.44, 58.02, 
                56.35, 55.82, 55.67, 55.49, 53.14]
    }

    df_sustainability = pd.DataFrame(data_sustainability)

    # Plotting
    plt.figure(figsize=(14, 10))
    bubble_sizes = df_sustainability['Score'] * 10  # Scale bubble sizes
    plt.scatter(df_sustainability['Score'], df_sustainability['Rank'], s=bubble_sizes, alpha=0.6, color='skyblue', edgecolors="w", linewidth=2)
    plt.gca().invert_yaxis()  # Highest rank on top
    plt.xlabel('Score')
    plt.ylabel('Rank')
    plt.title('World’s Most Sustainable Companies Of 2024: Taiwanese Companies')

    # Adding annotations with manual adjustments
    for i in range(len(df_sustainability)):
        plt.text(df_sustainability['Score'][i], df_sustainability['Rank'][i] + 10, df_sustainability['Company'][i], fontsize=9, ha='right')

    plt.grid(True)
    plt.show()
