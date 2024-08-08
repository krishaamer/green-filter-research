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
        # Adjust text position based on the rank to minimize overlap
        y_offset = 10 if i % 2 == 0 else -10  # Alternate offset for better spacing
        plt.text(df_sustainability['Score'][i], df_sustainability['Rank'][i] + y_offset, df_sustainability['Company'][i], fontsize=9, ha='right')

    plt.grid(True)
    plt.show()

def genz_students_chart():

    # Age groups
    ages = list(range(18, 27))

    # Enrollment rates for males and females
    enrollment_rates_male_18_26 = [63.88, 72.18, 70.20, 68.39, 71.05, 70.59, 63.88, 65.00, 67.00]
    enrollment_rates_female_18_26 = [72.56, 82.11, 80.23, 77.63, 80.48, 79.59, 72.56, 75.00, 78.00]

    plt.figure(figsize=(14, 8))

    # Plot for males
    plt.plot(ages, enrollment_rates_male_18_26, label="Males", marker='o')

    # Plot for females
    plt.plot(ages, enrollment_rates_female_18_26, label="Females", marker='o')

    # Adding titles and labels
    plt.title("Net Enrollment Rate of Tertiary Education (Ages 18 to 26)")
    plt.xlabel("Age")
    plt.ylabel("Enrollment Rate (%)")
    plt.legend()
    plt.grid(True)

    # Show plot
    plt.show()


def college_decline_chart():

    # Years and the corresponding percentage of GDP spent on education
    years = [
        "2013-14", "2014-15", "2015-16", "2016-17", "2017-18", 
        "2018-19", "2019-20", "2020-21", "2021-22", "2022-23", "2023-24"
    ]

    gdp_education_percentage = [5.45, 5.18, 5.02, 4.97, 4.93, 4.94, 4.82, 4.73, 4.59, 4.48, 4.26]

    plt.figure(figsize=(14, 8))

    # Plotting the percentage of GDP spent on education
    plt.plot(years, gdp_education_percentage, marker='o', linestyle='-', color='b')

    # Adding titles and labels
    plt.title("Percentage of Taiwan's GDP Spent on Education (2013-2024)")
    plt.xlabel("Year")
    plt.ylabel("Percentage of GDP (%)")
    plt.xticks(rotation=45)
    plt.grid(True)

    # Show plot
    plt.show()
