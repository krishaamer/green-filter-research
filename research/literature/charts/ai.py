import pandas as pd
import matplotlib.pyplot as plt

def models_chart():

    data_corrected = {
        "AI Model": ["GPT-1", "GTP-2", "Turing-NLG", "GPT-3", "GPT-3.5", "GPT-4", "AlexaTM", "NeMo", "PaLM", "LaMDA", 
                    "GLaM", "BLOOM", "Falcon", "Tongyi", "Vicuna", "Wu Dao 3", "LLAMA 2", "PaLM-2", "Claude 3", 
                    "Mistral Large", "Gemini 1.5", "LLAMA 3", "GPT-5"],
        "Released": [2018, 2019, 2020, 2020, 2022, 2023, 2022, 2022, 2022, 2022, 2022, 2022, 2023, 2023, 2023, 2023, 
                    2023, 2023, 2024, 2024, 2024, 2024, None],
        "Company": ["OpenAI", "OpenAI", "Microsoft", "OpenAI", "OpenAI", "OpenAI", "Amazon", "NVIDIA", "Google", "Google", 
                    "Google", "Hugging Face", "Technology Innovation Institute", "Alibaba", "Sapling", "BAAI", "META", 
                    "Google", "Anthropic", "Mistral", "Google", "META", "OpenAI"],
        "License": ["Open Source", "Open Source", "Proprietary", "Open Source", "Proprietary", "Proprietary", "Proprietary", 
                    "Open Source", "Proprietary", "Proprietary", "Proprietary", "Open Source", "Open Source", "Proprietary", 
                    "Open Source", "Open Source", "Open Source", "Proprietary", "Proprietary", "Proprietary", "Proprietary", 
                    "Open Source", "Unknown"]
    }

    df_corrected = pd.DataFrame(data_corrected)

    # Plotting with the corrected data
    plt.figure(figsize=(14, 10))
    colors = {'Open Source': 'green', 'Proprietary': 'red', 'Unknown': 'gray'}

    # Scatter plot
    for license_type in df_corrected['License'].unique():
        subset = df_corrected[df_corrected['License'] == license_type]
        plt.scatter(subset['Released'], subset['AI Model'], s=100, label=license_type, c=colors[license_type])

    # Annotate each point with the company name
    for i in range(len(df_corrected)):
        plt.annotate(df_corrected['Company'][i], (df_corrected['Released'][i], df_corrected['AI Model'][i]), textcoords="offset points", xytext=(0,5), ha='center', fontsize=8)

    plt.xlabel('Year Released')
    plt.ylabel('AI Model')
    plt.title('AI Model Releases and Their Licenses (2018-2024)')
    plt.legend(title='License')
    plt.grid(True)
    plt.xticks(rotation=45)
    plt.show()

def scifi_chart():

    # Data for the new chart
    data_media = {
        "Movie / Series / Game / Book": [
            "2001: A Space Odyssey", "Her", "Alien", "Terminator", "Summer Wars", 
            "Marvel Cinematic Universe", "Knight Rider", "Knight Rider", "Star Trek", 
            "Star Trek", "Ex Machina", "Ex Machina", "Tron", "Neuromancer", 
            "The Caves of Steel / Naked Sun", "The Robots of Dawn", "Portal"
        ],
        "Character": [
            "HAL 9000", "Samantha", "MU/TH/UR 6000 (Mother)", "Skynet", "Love Machine", 
            "Jarvis, Friday", "KITT", "CARR", "Data", "Lore", "Kyoko", "Ava", "Tron", 
            "Wintermute", "R. Daneel Olivaw", "R. Giskard Reventlov", "GLaDOS"
        ],
        "Positive": [
            "", "X", "X", "", "", "X", "X", "", "X", "", "", "", "", "", "", "", ""
        ],
        "Ambivalent": [
            "", "", "", "", "", "", "", "", "", "", "X", "X", "X", "X", "X", "X", ""
        ],
        "Negative": [
            "X", "", "", "X", "X", "", "", "X", "", "X", "", "", "", "", "", "", "X"
        ]
    }

    df_media = pd.DataFrame(data_media)

    # Function to get color based on sentiment
    def get_color(row):
        if row['Positive'] == 'X':
            return 'green'
        elif row['Ambivalent'] == 'X':
            return 'yellow'
        elif row['Negative'] == 'X':
            return 'red'
        else:
            return 'gray'

    df_media['Color'] = df_media.apply(get_color, axis=1)

    # Plotting
    plt.figure(figsize=(14, 10))

    # Scatter plot
    for color in df_media['Color'].unique():
        subset = df_media[df_media['Color'] == color]
        plt.scatter(subset['Character'], subset['Movie / Series / Game / Book'], s=100, label=color, c=color)

    # Annotate each point with the character name
    for i in range(len(df_media)):
        plt.annotate(df_media['Character'][i], (df_media['Character'][i], df_media['Movie / Series / Game / Book'][i]), 
                    textcoords="offset points", xytext=(0,5), ha='center', fontsize=8)

    plt.xlabel('Character')
    plt.ylabel('Movie / Series / Game / Book')
    plt.title('AIs in Different Forms of Media')
    plt.legend(handles=[
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='green', markersize=10, label='Positive'),
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='yellow', markersize=10, label='Ambivalent'),
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='red', markersize=10, label='Negative')
    ], title='Sentiment')
    plt.grid(True)
    plt.xticks(rotation=45)
    plt.show()


def scifi_dates_chart():

    # Updated data with single representative release years
    data_media_updated = {
        "Movie / Series / Game / Book": [
            "2001: A Space Odyssey", "Her", "Alien", "Terminator", "Summer Wars", 
            "Marvel Cinematic Universe", "Knight Rider", "Knight Rider", "Star Trek", 
            "Star Trek", "Ex Machina", "Ex Machina", "Tron", "Neuromancer", 
            "The Caves of Steel", "The Robots of Dawn", "Portal"
        ],
        "Character": [
            "HAL 9000", "Samantha", "MU/TH/UR 6000 (Mother)", "Skynet", "Love Machine", 
            "Jarvis, Friday", "KITT", "CARR", "Data", "Lore", "Kyoko", "Ava", "Tron", 
            "Wintermute", "R. Daneel Olivaw", "R. Giskard Reventlov", "GLaDOS"
        ],
        "Release Date": [
            1968, 2013, 1979, 1984, 2009, 
            2008, 1982, 1982, 1966, 
            1987, 2015, 2015, 1982, 1984, 
            1954, 1983, 2007
        ],
        "Positive": [
            "", "X", "X", "", "", "X", "X", "", "X", "", "", "", "", "", "", "", ""
        ],
        "Ambivalent": [
            "", "", "", "", "", "", "", "", "", "", "X", "X", "X", "X", "X", "X", ""
        ],
        "Negative": [
            "X", "", "", "X", "X", "", "", "X", "", "X", "", "", "", "", "", "", "X"
        ]
    }

    df_media_updated = pd.DataFrame(data_media_updated)

    # Function to get color based on sentiment
    def get_color(row):
        if row['Positive'] == 'X':
            return 'green'
        elif row['Ambivalent'] == 'X':
            return 'yellow'
        elif row['Negative'] == 'X':
            return 'red'
        else:
            return 'gray'

    df_media_updated['Color'] = df_media_updated.apply(get_color, axis=1)

    # Plotting
    plt.figure(figsize=(14, 10))

    # Scatter plot
    for color in df_media_updated['Color'].unique():
        subset = df_media_updated[df_media_updated['Color'] == color]
        plt.scatter(subset['Release Date'], subset['Character'], s=100, label=color, c=color)

    # Annotate each point with the character name
    for i in range(len(df_media_updated)):
        plt.annotate(df_media_updated['Character'][i], (df_media_updated['Release Date'][i], df_media_updated['Character'][i]), 
                    textcoords="offset points", xytext=(0,5), ha='center', fontsize=8)

    plt.xlabel('Release Date')
    plt.ylabel('Character')
    plt.title('AIs in Different Forms of Media with Release Dates')
    plt.legend(handles=[
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='green', markersize=10, label='Positive'),
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='yellow', markersize=10, label='Ambivalent'),
        plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='red', markersize=10, label='Negative')
    ], title='Sentiment')
    plt.grid(True)
    plt.xticks(rotation=45)
    plt.show()
