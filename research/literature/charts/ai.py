import warnings
warnings.filterwarnings("ignore")
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

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

    # Remove rows where 'Released' is None
    df_filtered = df_corrected.dropna(subset=['Released'])

    # Plotting with the filtered data
    plt.figure(figsize=(14, 10))
    colors = {'Open Source': 'green', 'Proprietary': 'red', 'Unknown': 'gray'}

    # Scatter plot
    for license_type in df_filtered['License'].unique():
        subset = df_filtered[df_filtered['License'] == license_type]
        plt.scatter(subset['Released'], subset['AI Model'], s=100, label=license_type, c=colors[license_type])

    # Annotate each point with the company name
    for i in range(len(df_filtered)):
        plt.annotate(df_filtered['Company'][i], (df_filtered['Released'][i], df_filtered['AI Model'][i]), 
                     textcoords="offset points", xytext=(0,5), ha='center', fontsize=8)

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

def growth_compute_chart():

    # Load the CSV data
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, 'data', 'notable_ai_models.csv')
    df = pd.read_csv(file_path)

    # Convert 'Publication date' to datetime and 'Training compute (FLOP)' to numeric
    df['Publication date'] = pd.to_datetime(df['Publication date'], errors='coerce')
    df['Training compute (FLOP)'] = pd.to_numeric(df['Training compute (FLOP)'], errors='coerce')

    # Drop rows with missing data in these columns
    df_filtered = df.dropna(subset=['Training compute (FLOP)', 'Publication date'])

    # Extract the year from the publication date for the x-axis
    df_filtered['Publication year'] = df_filtered['Publication date'].dt.year

    # Set up the plot
    plt.figure(figsize=(12, 6))

    # Scatter plot for training compute (log scale) vs. publication date
    plt.scatter(df_filtered['Publication year'], df_filtered['Training compute (FLOP)'], color='cyan', alpha=0.7, s=50)

    # Set log scale for y-axis (Training compute FLOP)
    plt.yscale('log')

    # Titles and labels
    plt.title('Notable AI Models: Training Compute vs. Publication Date', fontsize=14)
    plt.xlabel('Publication Date', fontsize=12)
    plt.ylabel('Training compute (FLOP)', fontsize=12)

    # Annotate a few selected notable models
    notable_models_to_annotate = ['AFM-server', 'GPT-4', 'BERT', 'AlphaFold', 'Llama 3.1-405B']
    for _, row in df_filtered[df_filtered['System'].isin(notable_models_to_annotate)].iterrows():
        plt.text(row['Publication year'], row['Training compute (FLOP)'] * 1.1, row['System'], fontsize=8, rotation=45)

    # Add a trend line (logarithmic)
    x = df_filtered['Publication year']
    y = df_filtered['Training compute (FLOP)']
    z = np.polyfit(x, np.log(y), 1)  # Fit a logarithmic trend line
    plt.plot(x, np.exp(z[0]*x + z[1]), linestyle='--', color='gray', label=f'1.4x/year')

    # Highlight the Deep Learning Era (approximately 2012 onwards)
    plt.axvspan(2012, max(df_filtered['Publication year']), color='lightblue', alpha=0.3, label="Deep Learning Era")

    # Adding a legend
    plt.legend(loc='upper left')

    # Display the plot
    plt.tight_layout()
    plt.show()

def models_rag_performance():
    # Data for the long context RAG performance table (values extracted from the table provided by the user)
    context_lengths_table = [2, 4, 8, 16, 32, 64, 96, 125]

    # Performance data for various models
    performance_gpt4o_table = [0.467, 0.671, 0.721, 0.752, 0.759, 0.769, 0.769, 0.767]
    performance_claude3_5_sonnet = [0.506, 0.684, 0.723, 0.718, 0.748, 0.741, 0.732, 0.706]
    performance_claude3_opus = [0.463, 0.652, 0.702, 0.716, 0.725, 0.755, 0.732, 0.741]
    performance_claude3_haiku = [0.466, 0.666, 0.678, 0.705, 0.69, 0.668, 0.663, 0.656]
    performance_gpt4o_mini = [0.424, 0.587, 0.624, 0.649, 0.662, 0.648, 0.646, 0.643]
    performance_gpt4_turbo = [0.465, 0.6, 0.634, 0.641, 0.623, 0.623, 0.562, 0.56]

    # Creating the plot for long context RAG performance across context lengths for different models
    plt.figure(figsize=(10, 6))

    plt.plot(context_lengths_table, performance_gpt4o_table, label="GPT-4o", marker='o')
    plt.plot(context_lengths_table, performance_claude3_5_sonnet, label="Claude-3-5 Sonnet", marker='s')
    plt.plot(context_lengths_table, performance_claude3_opus, label="Claude-3 Opus", marker='^')
    plt.plot(context_lengths_table, performance_claude3_haiku, label="Claude-3 Haiku", marker='d')
    plt.plot(context_lengths_table, performance_gpt4o_mini, label="GPT-4o Mini", marker='x')
    plt.plot(context_lengths_table, performance_gpt4_turbo, label="GPT-4 Turbo", marker='*')

    plt.xlabel('Context Length (k tokens)')
    plt.ylabel('RAG Performance')
    plt.title('Long Context RAG Performance Across Context Lengths for Various Models')
    plt.legend()
    plt.grid(True)

    plt.show()
