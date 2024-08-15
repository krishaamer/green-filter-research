import warnings
warnings.filterwarnings("ignore")

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
    
    # Corresponding years
    years = ["2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024"]

    # Enrollment rates for males and females
    enrollment_rates_male_18_26 = [63.88, 72.18, 70.20, 68.39, 71.05, 70.59, 63.88, 65.00, 67.00]
    enrollment_rates_female_18_26 = [72.56, 82.11, 80.23, 77.63, 80.48, 79.59, 72.56, 75.00, 78.00]

    # Calculate the average enrollment rates
    enrollment_rates_avg_18_26 = [(male + female) / 2 for male, female in zip(enrollment_rates_male_18_26, enrollment_rates_female_18_26)]

    plt.figure(figsize=(14, 8))

    # Plot for average enrollment rates
    plt.plot(ages, enrollment_rates_avg_18_26, label="Average", marker='o')

    # Adding year annotations
    for i, year in enumerate(years):
        plt.annotate(year, (ages[i], enrollment_rates_avg_18_26[i]), textcoords="offset points", xytext=(0,10), ha='center')

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
    
    # Expenditure per student in NT$
    expenditure_per_student = [
        172406, 179890, 187484, 195380, 204101,
        210178, 216940, 229429, 240568, 246001, 250000  # Assuming a value for 2023-24
    ]
    
    # Number of students at all levels (values in thousands for readability)
    number_of_students = [
        4859558, 4729465, 4616078, 4504363, 4403690,
        4325027, 4260337, 4211731, 4171630, 4103865, 4042175
    ]
    
    fig, ax1 = plt.subplots(figsize=(14, 8))

    color = 'tab:blue'
    ax1.set_xlabel('Year')
    ax1.set_ylabel('Percentage of GDP (%)', color=color)
    ax1.plot(years, gdp_education_percentage, marker='o', linestyle='-', color=color, label='GDP % on Education')
    ax1.tick_params(axis='y', labelcolor=color)
    ax1.legend(loc='upper left')

    ax2 = ax1.twinx()  
    color = 'tab:red'
    ax2.set_ylabel('Expenditure per Student (NT$)', color=color)
    ax2.plot(years, expenditure_per_student, marker='s', linestyle='--', color=color, label='Expenditure per Student')
    ax2.tick_params(axis='y', labelcolor=color)
    ax2.legend(loc='upper right')
    
    ax3 = ax1.twinx()
    color = 'tab:green'
    ax3.spines['right'].set_position(('outward', 60))
    ax3.set_ylabel('Number of Students (in thousands)', color=color)
    ax3.plot(years, [n/1000 for n in number_of_students], marker='^', linestyle='-.', color=color, label='Number of Students')
    ax3.tick_params(axis='y', labelcolor=color)
    ax3.legend(loc='lower right')

    plt.title("Taiwan's Education Expenditure and Student Numbers (2013-2024)")
    plt.xticks(rotation=45)
    ax1.grid(True)

    fig.tight_layout()  
    plt.show()


def higher_education_chart():
    # Years and the corresponding percentage of GDP spent on education
    years = [
        "2013-14", "2014-15", "2015-16", "2016-17", "2017-18", 
        "2018-19", "2019-20", "2020-21", "2021-22", "2022-23", "2023-24"
    ]

    gdp_education_percentage = [5.45, 5.18, 5.02, 4.97, 4.93, 4.94, 4.82, 4.73, 4.59, 4.48, 4.26]
    
    # Verified expenditure per student in Higher Education (NT$)
    expenditure_per_student_higher = [
        182901, 184910, 187271, 190852, 199952,
        205580, 212239, 215060, 218103, 228878, 235000  # Assuming a value for 2023-24
    ]
    
    # Corrected number of students in Higher Education (values in thousands for readability)
    number_of_students_higher = [
        1341307, 1333664, 1324019, 1299594, 1263032,
        1236066, 1207582, 1182226, 1164838, 1119800, 1074832
    ]
    
    # Non-citizen Students in Universities, Colleges, and Junior Colleges (Persons)
    non_citizen_students = [
        79730, 93645, 111340, 116875, 121461,
        129207, 128157, 90895, 94579, 106067, 116630
    ]
    
    fig, ax1 = plt.subplots(figsize=(14, 8))

    color = 'tab:blue'
    ax1.set_xlabel('Year')
    ax1.set_ylabel('Percentage of GDP (%)', color=color)
    ax1.plot(years, gdp_education_percentage, marker='o', linestyle='-', color=color, label='GDP % on Education')
    ax1.tick_params(axis='y', labelcolor=color)
    ax1.legend(loc='upper left')

    ax2 = ax1.twinx()  
    color = 'tab:red'
    ax2.set_ylabel('Expenditure per Student (NT$)', color=color)
    ax2.plot(years, expenditure_per_student_higher, marker='s', linestyle='--', color=color, label='Expenditure per Student')
    ax2.tick_params(axis='y', labelcolor=color)
    ax2.legend(loc='upper right')
    
    ax3 = ax1.twinx()
    color = 'tab:green'
    ax3.spines['right'].set_position(('outward', 60))
    ax3.set_ylabel('Number of Students (in thousands)', color=color)
    ax3.plot(years, [n/1000 for n in number_of_students_higher], marker='^', linestyle='-.', color=color, label='Number of Students')
    ax3.tick_params(axis='y', labelcolor=color)
    ax3.legend(loc='lower right')
    
    ax4 = ax1.twinx()
    color = 'tab:purple'
    ax4.spines['right'].set_position(('outward', 120))
    ax4.set_ylabel('Non-citizen Students (Persons)', color=color)
    ax4.plot(years, non_citizen_students, marker='*', linestyle=':', color=color, label='Non-citizen Students')
    ax4.tick_params(axis='y', labelcolor=color)
    ax4.legend(loc='center right')

    plt.title("Taiwan's Higher Education Expenditure and Student Numbers (2013-2024)")
    plt.xticks(rotation=45)
    ax1.grid(True)

    fig.tight_layout()  
    plt.show()


def compare_taiwan_sweden():

    # Creating a sample dataframe based on the information provided
    data = {
        'Item': [
            'Access to good education (SOCIAL)', 'Wiping out poverty (ECONOMIC)', 'Culture resolving conflicts peacefully (SOCIAL)', 
            'Respecting human rights (SOCIAL)', 'Companies acting responsibly (ECONOMIC)', 'Fair distribution of goods and services (ECONOMIC)', 
            'Preserving variety of living creatures (ENVIRONMENTAL)', 'Reducing water consumption (ENVIRONMENTAL)', 
            'Education on natural disaster protection (ENVIRONMENTAL)', 'Ensuring future quality of life (SOCIAL)', 
            'Reducing poverty (ECONOMIC)', 'Equal conditions for employees (ECONOMIC)', 'Equal opportunities for education and employment (SOCIAL)', 
            'Using natural resources responsibly (ENVIRONMENTAL)', 'Opportunities for sustainable knowledge (SOCIAL)', 
            'Stricter laws for environmental protection (ENVIRONMENTAL)', 'Measures against climate change (ENVIRONMENTAL)', 
            'Company responsibility to reduce packaging (ECONOMIC)', 'Supporting aid organizations (SOCIAL)', 'Helping poor people (ECONOMIC)', 
            'Avoiding products from irresponsible companies (ECONOMIC)', 'Changing lifestyle to reduce waste (ENVIRONMENTAL)', 
            'Recycling as much as possible (ENVIRONMENTAL)', 'Purchasing second-hand goods (ECONOMIC)', 'Respectful online behavior (SOCIAL)', 
            'Separating food waste (ENVIRONMENTAL)', 'Showing respect to all genders (SOCIAL)'
        ],
        'Taiwan_Mean': [
            3.58, 3.42, 3.88, 3.98, 3.90, 3.81, 4.50, 4.05, 4.06, 3.60, 3.75, 3.87, 4.39, 4.22, 4.35, 4.00, 4.36, 4.39, 4.23, 3.74, 3.97, 3.98, 4.09, 2.68, 4.18, 3.51, 4.38
        ],
        'Taiwan_SD': [
            0.997, 1.076, 0.820, 0.880, 0.864, 0.897, 0.629, 0.847, 0.809, 1.040, 0.892, 0.936, 0.715, 1.079, 0.684, 0.919, 0.692, 0.689, 0.766, 0.807, 0.834, 0.834, 0.735, 1.105, 0.750, 1.056, 0.735
        ],
        'Sweden_Mean': [
            4.53, 4.05, 4.37, 4.42, 4.24, 4.06, 4.57, 3.77, 3.67, 4.65, 4.54, 4.27, 4.74, 4.51, 4.64, 4.23, 4.57, 4.44, 2.50, 2.69, 2.97, 3.11, 3.52, 2.30, 3.93, 3.76, 4.73
        ],
        'Sweden_SD': [
            0.777, 1.107, 0.909, 0.883, 0.896, 1.015, 0.790, 1.176, 1.136, 0.727, 0.811, 1.028, 0.666, 0.924, 0.708, 0.950, 0.736, 0.866, 1.570, 1.194, 1.311, 1.307, 1.268, 1.328, 1.336, 1.484, 0.706
        ]
    }

    df = pd.DataFrame(data)

    # Adding a 'Type' column to the DataFrame to categorize items
    df['Type'] = [
        'SOCIAL', 'ECONOMIC', 'SOCIAL', 'SOCIAL', 'ECONOMIC', 'ECONOMIC', 'ENVIRONMENTAL', 'ENVIRONMENTAL', 
        'ENVIRONMENTAL', 'SOCIAL', 'ECONOMIC', 'ECONOMIC', 'SOCIAL', 'ENVIRONMENTAL', 'SOCIAL', 'ENVIRONMENTAL', 
        'ENVIRONMENTAL', 'ECONOMIC', 'SOCIAL', 'ECONOMIC', 'ECONOMIC', 'ENVIRONMENTAL', 'ENVIRONMENTAL', 'ECONOMIC', 
        'SOCIAL', 'ENVIRONMENTAL', 'SOCIAL'
    ]

    # Sorting the DataFrame based on 'Type'
    df_sorted = df.sort_values(by='Type')

    # Defining a function to add section dividers and titles
    def add_section_dividers_with_space(ax, df, type_name, y_start, y_end, space):
        ax.axhline(y=y_start, color='black', linewidth=2)
        ax.text(2.5, (y_start + y_end + space) / 2, type_name, va='center', ha='center', fontweight='bold', fontsize=12, bbox=dict(facecolor='white', edgecolor='black'))
        ax.axhline(y=y_end + space, color='black', linewidth=2)

    # Creating the horizontal line chart
    fig, ax = plt.subplots(figsize=(14, 12))

    # Plotting the lines horizontally with consistent colors and adding sections with space
    current_y = 0
    space = 2
    yticks = []
    yticklabels = []

    for type_name in ['SOCIAL', 'ENVIRONMENTAL', 'ECONOMIC']:
        subset = df_sorted[df_sorted['Type'] == type_name]
        y_start = current_y
        for i, item in subset.iterrows():
            ax.plot([item['Taiwan_Mean'], item['Sweden_Mean']], [current_y, current_y], marker='o', color='grey', alpha=0.5, linewidth=2)
            ax.scatter(item['Taiwan_Mean'], current_y, color='#FF6F61', s=100, edgecolors='black')
            ax.scatter(item['Sweden_Mean'], current_y, color='#6B5B95', s=100, edgecolors='black')
            yticks.append(current_y)
            yticklabels.append(item['Item'].replace(' (SOCIAL)', '').replace(' (ECONOMIC)', '').replace(' (ENVIRONMENTAL)', ''))
            current_y += 1
        y_end = current_y - 1
        add_section_dividers_with_space(ax, df_sorted, type_name, y_start, y_end, space)
        current_y += space

    # Adding labels and title
    ax.set_yticks(yticks)
    ax.set_yticklabels(yticklabels)
    ax.set_ylabel('Sustainability Items', fontweight='bold')
    ax.set_xlabel('Mean Score', fontweight='bold')
    ax.set_title('Horizontal Line Chart of Sustainability Consciousness Items\n(Sections by Type)', fontweight='bold')
    ax.legend(['Taiwan', 'Sweden'], loc='upper right')

    # Display the plot
    plt.tight_layout()
    plt.show()

