import warnings
warnings.filterwarnings("ignore")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')

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


def genz_enrollment_chart():
    data_years_2013_2023 = {
        'Year': ['2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023'],
        'Enrolled (%)': [63.54, 64.55, 64.35, 64.66, 66.57, 65.99, 63.07, 66.18, 68.62, 77.53, 82.14],
        'Not Enrolled (%)': [100-63.54, 100-64.55, 100-64.35, 100-64.66, 100-66.57, 100-65.99, 100-63.07, 100-66.18, 100-68.62, 100-77.53, 100-82.14]
    }

    df_years_2013_2023 = pd.DataFrame(data_years_2013_2023)

    # Creating a stacked bar chart for 2013-2023
    plt.figure(figsize=(12, 6))
    plt.bar(df_years_2013_2023['Year'], df_years_2013_2023['Enrolled (%)'], label='Enrolled', color='#66b3ff')
    plt.bar(df_years_2013_2023['Year'], df_years_2013_2023['Not Enrolled (%)'], bottom=df_years_2013_2023['Enrolled (%)'], label='Not Enrolled', color='#ffcc99')

    # Adding titles and labels
    plt.title('Enrollment Trends for Ages 18-26 in Taiwan (2013-2023)')
    plt.xlabel('Year')
    plt.ylabel('Percentage (%)')
    plt.xticks(df_years_2013_2023['Year'])
    plt.legend()

    # Displaying the stacked bar chart
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
    ax.set_title('Sustainability Consciousness: College Students in Taiwan and Sweden', fontweight='bold')
    ax.legend(['Taiwan', 'Sweden'], loc='upper right')

    # Display the plot
    plt.tight_layout()
    plt.show()


def taiwanese_company_ranking_chart():
    data = {
        '2021': [20, None, None],
        '2022': [44, None, None],
        '2023': [None, 9, 51],
        '2024': [None, 4, 21]
    }

    # Create a DataFrame for the data
    companies = ['TSMC', 'THSR', 'Giant']
    combined_rankings = pd.DataFrame(data, index=companies)

    # Convert column names (years) to integers
    combined_rankings.columns = combined_rankings.columns.astype(int)

    # Convert years to numeric for plotting
    years_as_numeric = combined_rankings.columns.astype(int)

    # Plot the data with different colors
    plt.figure(figsize=(10, 6))
    colors = ['blue', 'green', 'red']

    for i, company in enumerate(combined_rankings.index):
        plt.plot(years_as_numeric, combined_rankings.loc[company], marker='o', label=company, linewidth=2, color=colors[i])
        
        # Plot the ranking on each point for the line
        for year in years_as_numeric:
            rank = combined_rankings.loc[company, year]
            if not pd.isna(rank):
                plt.text(year, rank, f'{int(rank)}', fontsize=9, ha='center', va='bottom')
        
        # Adding the company label next to the last valid data point
        valid_rankings = combined_rankings.loc[company].dropna()
        if len(valid_rankings) > 0:
            last_year = valid_rankings.index[-1]
            last_value = valid_rankings.iloc[-1]
            plt.text(last_year + 0.1, last_value, company, fontsize=10, va='center', ha='left')  # Offset label slightly to the right

    # Invert the y-axis to show rank 1 at the top
    plt.gca().invert_yaxis()
    plt.xticks(years_as_numeric, years_as_numeric.astype(int))  # Format year labels as integers
    plt.ylim(100, 1)
    plt.title('Sustainability Ranking Trends (2021 to 2024) for Taiwanese Companies')
    plt.xlabel('Year')
    plt.ylabel('Rank (1-100)')
    plt.legend().set_visible(False)  # Hide the legend as we are adding labels directly
    plt.show()


def green_millenials():
    # Data from the findings section that can be charted
    data = {
        'Psychographic Factor': ['Selfless Altruism', 'Frugality', 'Future Orientation', 'Risk Aversion'],
        'Influence on Green Behavior': [-0.08, 0.34, 0.18, -0.07],
        'Significance': [False, True, True, False]
    }

    df = pd.DataFrame(data)

    # Plotting the data
    plt.figure(figsize=(10, 6))
    bars = plt.bar(df['Psychographic Factor'], df['Influence on Green Behavior'], color=['red' if not sig else 'green' for sig in df['Significance']])
    plt.axhline(0, color='black', linewidth=0.5)
    plt.title('Influence of Psychographic Factors on Green Behavior in Millennials')
    plt.xlabel('Psychographic Factor')
    plt.ylabel('Influence on Green Behavior (Coefficient)')
    plt.ylim(-0.2, 0.4)

    # Adding the significance markers
    for bar, sig in zip(bars, df['Significance']):
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2, height - 0.05 if height < 0 else height + 0.05, 
                'Significant' if sig else 'Not Sig.', 
                ha='center', color='black')

    # Display the plot
    plt.tight_layout()
    plt.show()

def mean_global_attitudes():
    # Updated data for 2010 and 2020 with change values
    data_correct_comparison_2010_2020 = {
        'Country': ['Switzerland', 'France', 'Germany', 'Norway', 'Great Britain', 'Sweden', 'Finland', 'Japan', 'Iceland', 'Australia', 'Denmark', 
                    'Austria', 'Slovenia', 'New Zealand', 'United States', 'Taiwan', 'South Korea', 'Spain', 'Russia', 'Slovakia'],
        'Environmental Concern 2010': [60.2, 50.8, 51.9, 52.1, 46.6, 54.1, 54.8, 53.9, 50.8, 50.1, 55.3, 50.8, 50.0, 51.7, 50.3, 52.6, 53.9, 50.4, 41.4, 45.5],
        'Environmental Concern 2020': [61.8, 58.6, 58.2, 58.0, 57.6, 57.3, 57.2, 57.1, 56.8, 56.6, 55.9, 55.9, 55.1, 54.9, 54.2, 54.1, 52.5, 51.3, 40.7, 40.4],
        'Change': [1.6, 7.8, 6.3, 5.9, 11.0, 3.2, 2.4, 3.2, 6.0, 6.5, 0.6, 5.1, 5.1, 3.2, 3.9, 1.5, -1.4, 0.9, -0.7, -5.1]
    }

    # Creating a DataFrame
    df_correct_comparison_2010_2020 = pd.DataFrame(data_correct_comparison_2010_2020)

    # Splitting the data into increased and decreased concern
    df_increased_correct = df_correct_comparison_2010_2020[df_correct_comparison_2010_2020['Change'] > 0]
    df_decreased_correct = df_correct_comparison_2010_2020[df_correct_comparison_2010_2020['Change'] < 0]

    # Sorting the decreased concern countries properly by Environmental Concern 2020
    df_decreased_correct = df_decreased_correct.sort_values(by='Environmental Concern 2020', ascending=True)

    # Plotting the two side-by-side charts
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 8), sharey=True)

    bar_width = 0.35

    # Plot for countries with increased environmental concern, sorted by 2020 values
    index_increased_correct = range(len(df_increased_correct['Country']))
    ax1.bar(index_increased_correct, df_increased_correct['Environmental Concern 2010'], bar_width, label='2010', color='lightblue')
    ax1.bar([i + bar_width for i in index_increased_correct], df_increased_correct['Environmental Concern 2020'], bar_width, label='2020', color='lightgreen')
    ax1.set_title('Countries with Increased Environmental Concern (2010 vs 2020)')
    ax1.set_xlabel('Country')
    ax1.set_ylabel('Environmental Concern Index')
    ax1.set_xticks([i + bar_width / 2 for i in index_increased_correct])
    ax1.set_xticklabels(df_increased_correct['Country'], rotation=90)

    # Plot for countries with decreased environmental concern, properly sorted by 2020 values
    index_decreased_correct = range(len(df_decreased_correct['Country']))
    ax2.bar(index_decreased_correct, df_decreased_correct['Environmental Concern 2010'], bar_width, label='2010', color='lightblue')
    ax2.bar([i + bar_width for i in index_decreased_correct], df_decreased_correct['Environmental Concern 2020'], bar_width, label='2020', color='salmon')
    ax2.set_title('Countries with Decreased Environmental Concern (2010 vs 2020)')
    ax2.set_xlabel('Country')
    ax2.set_ylabel('Environmental Concern Index')
    ax2.set_xticks([i + bar_width / 2 for i in index_decreased_correct])
    ax2.set_xticklabels(df_decreased_correct['Country'], rotation=90)

    # Display the legend
    fig.legend(['2010', '2020'], loc='upper center', ncol=2)

    plt.tight_layout()
    plt.show()

def postmaterialist_chart():
    # Full dataset for Postmaterialist Index from the document
    countries_full_corrected = [
        "Sweden", "Germany", "Bahrain", "Chile", "Uruguay", "Pakistan", "Netherlands", "Slovenia",
        "Colombia", "Mexico", "Philippines", "Spain", "Hong Kong", "Poland", "New Zealand", "India",
        "Japan", "Singapore", "Zimbabwe", "South Africa", "Lebanon", "Brazil", "Ecuador", "Estonia",
        "Turkey", "Argentina", "South Korea", "Algeria", "Peru", "Romania", "Thailand", 
        "Nigeria", "Australia", "USA", "Malaysia", "Azerbaijan", "Belgium", "Ukraine", "Trinidad",
        "Palestine", "Liberia", "Cyprus", "Rwanda", "Ghana", "Taiwan", "Kyrgyzstan", "Iran", "Russia",
        "Uzbekistan", "Morocco", "Kazakhstan", "Georgia", "China", "Jordan", "Armenia", "Yemen", 
        "Egypt", "Tunisia"
    ]

    postmaterialist_scores_full = [
        2.81, 2.74, 2.69, 2.53, 2.45, 2.35, 2.33, 2.32, 2.29, 2.27, 2.24, 2.21, 2.21, 2.21, 2.18, 2.16,
        2.13, 2.11, 2.11, 2.09, 2.08, 2.08, 2.07, 2.07, 2.06, 2.05, 2.00, 1.99, 1.98, 1.97, 1.97, 1.96, 
        1.95, 1.94, 1.90, 1.78, 1.77, 1.74, 1.74, 1.72, 1.72, 1.70, 1.69, 1.67, 1.64, 1.63, 1.63, 1.58,
        1.58, 1.50, 1.49, 1.44, 1.38, 1.27, 1.19, 1.15, 1.11, 0.94
    ]

    # Create a bar chart with a highlighted circle around Taiwan's score
    plt.figure(figsize=(12, 8))
    bars = plt.bar(countries_full_corrected, postmaterialist_scores_full, color='lightblue')

    # Highlight Taiwan
    taiwan_index = countries_full_corrected.index("Taiwan")
    bars[taiwan_index].set_color('red')

    # Draw a circle around Taiwan
    plt.gca().add_patch(plt.Circle((taiwan_index, postmaterialist_scores_full[taiwan_index]), 0.5, color='red', fill=False, lw=2))

    # Add labels and title
    plt.xticks(rotation=90, fontsize=8)
    plt.ylabel('Postmaterialist Index')
    plt.title('Postmaterialist Index Comparison for 59 Countries (Taiwan Highlighted)')
    plt.tight_layout()
    plt.show()

def world_values_chart():
    # Load the dataset
    data = pd.read_csv(os.path.join(data_dir, 'world-values.csv'), delimiter=';')

    # Define the generational groups
    gen_z_data = data[(data['Q261'] >= 1997) & (data['Q261'] <= 2012)]
    millennials_data = data[(data['Q261'] >= 1981) & (data['Q261'] <= 1996)]
    gen_x_data = data[(data['Q261'] >= 1965) & (data['Q261'] <= 1980)]
    boomers_data = data[(data['Q261'] >= 1946) & (data['Q261'] <= 1964)]
    silent_data = data[data['Q261'] < 1946]

    # Extract importance data (Q1 to Q6)
    importance_dict = {
        'Generation Z (1997-2012)': gen_z_data[['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6']].apply(pd.Series.value_counts),
        'Millennials (1981-1996)': millennials_data[['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6']].apply(pd.Series.value_counts),
        'Generation X (1965-1980)': gen_x_data[['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6']].apply(pd.Series.value_counts),
        'Baby Boomers (1946-1964)': boomers_data[['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6']].apply(pd.Series.value_counts),
        'Silent Generation (<1946)': silent_data[['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6']].apply(pd.Series.value_counts)
    }

    # Calculate percentages for each importance level (1 to 4) by dividing the count by the total number of respondents in each generation
    stacked_data_percentage = {level: [] for level in ['Very Important', 'Quite Important', 'Not Very Important', 'Not At All Important']}
    gen_totals = {gen: importance_dict[gen].sum().sum() for gen in importance_dict}

    for gen in importance_dict:
        gen_data = importance_dict[gen]
        total_respondents = gen_totals[gen]
        for level in [1, 2, 3, 4]:
            if level in gen_data.index:
                percentage = gen_data.loc[level].sum() / total_respondents * 100
            else:
                percentage = 0
            stacked_data_percentage[['Very Important', 'Quite Important', 'Not Very Important', 'Not At All Important'][level-1]].append(percentage)

    # Create a DataFrame to summarize the stacked percentages
    summary_data = pd.DataFrame(stacked_data_percentage, index=importance_dict.keys())

    # Plotting the stacked bar chart
    fig, ax = plt.subplots(figsize=(12, 6))  # Reduced the height to 6 for better management

    # Plotting the stacked bar chart with percentage values
    bottom_values = np.zeros(len(importance_dict))
    for level in ['Very Important', 'Quite Important', 'Not Very Important', 'Not At All Important']:
        ax.bar(importance_dict.keys(), summary_data[level], bottom=bottom_values, label=level)
        bottom_values += summary_data[level]

    # Setting labels and formatting
    ax.set_title('Importance of Various Aspects of Life by Generation (Percentage)', fontsize=14)
    ax.set_xlabel('Generations', fontsize=12)
    ax.set_ylabel('Percentage of Respondents', fontsize=12)

    # Ensure aspect labels are visible
    ax.tick_params(axis='x', rotation=45)

    # Adding legend
    ax.legend(title='Importance Level', bbox_to_anchor=(1.05, 1), loc='upper left')

    plt.tight_layout()
    plt.show()

def college_chatbot():
    # Data for radar chart: comparing males, females, and field of study on key metrics
    categories = ['ChatGPT Usage', 'Positive Attitude', 'Concern About Impact', 'Cheating Perception']
    num_vars = len(categories)

    # Data for Males, Females, Field Tech, and Field Humanities
    values_males = [16.2, 55.9, -5.6, -6.1]
    values_females = [-16.2, 31.4, 5.6, 6.1]
    values_field_tech = [3, 55.9, 47.7, 24.3]
    values_field_humanities = [1, 31.4, 54.2, 61.9]

    # Adding the first value to close the radar chart loop
    values_males += values_males[:1]
    values_females += values_females[:1]
    values_field_tech += values_field_tech[:1]
    values_field_humanities += values_field_humanities[:1]

    # Radar chart angles
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]

    # Plot Radar Chart
    fig, ax = plt.subplots(figsize=(6, 6), subplot_kw=dict(polar=True))

    # Fill and plot data for each group
    ax.fill(angles, values_males, color='blue', alpha=0.25, label='Males')
    ax.fill(angles, values_females, color='red', alpha=0.25, label='Females')
    ax.fill(angles, values_field_tech, color='green', alpha=0.25, label='Field Tech')
    ax.fill(angles, values_field_humanities, color='orange', alpha=0.25, label='Field Humanities')

    # Set chart labels and title
    ax.set_yticklabels([])
    ax.set_xticks(angles[:-1])
    ax.set_xticklabels(categories)
    ax.set_title('Radar Chart: Comparison of Chatbot Usage, Attitudes, and Field of Study')

    # Add legend
    ax.legend(loc='upper right', bbox_to_anchor=(1.1, 1.1))

    # Show radar chart
    plt.show()
