import warnings
warnings.filterwarnings("ignore")

import matplotlib.pyplot as plt
import seaborn as sns
import networkx as nx
import pandas as pd
import numpy as np
from matplotlib.font_manager import FontProperties
from data.fields.likert_fields import likert_fields
from data.fields.likert_flat_fields import likert_flat_fields
from data.fields.field_translation_mapping import field_translation_mapping
from data.fields.translation_mapping import translation_mapping

import os
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, 'clean.csv')
font_path = os.path.join(script_dir, 'fonts', 'notosans.ttf')
df = pd.read_csv(csv_path)
chinese_font = FontProperties(fname=font_path, size=12)

def likert_charts():
    # Rename the columns in the DataFrame for visualization
    df_translated = df.rename(columns={
        field: f"{field} ({field_translation_mapping[category][i]})"
        for category, fields in likert_fields.items()
        for i, field in enumerate(fields)
    })

    # Loop through each category in likert_fields to create visualizations
    for category, fields in likert_fields.items():
    
        # Calculate the number of rows needed for this category
        num_fields = len(fields)
        # Equivalent to ceil(num_fields / 2)
        num_rows = -(-num_fields // 2)

        # Create subplots with 2 columns for this category
        fig, axs = plt.subplots(num_rows, 2, figsize=(15, 5 * num_rows))
        axs = axs.flatten()  # Flatten the array of subplots

        # Add padding to fit in the Chinese titles
        plt.subplots_adjust(hspace=0.4)

        # Loop through each field in the category to create individual bar plots
        for i, field in enumerate(fields):
            # Create the bar plot
            sns.countplot(
                x=f"{field} ({field_translation_mapping[category][i]})", data=df_translated, ax=axs[i], palette=sns.color_palette("pastel"), saturation=1)

            # Add title and labels
            title_chinese = field
            title_english = field_translation_mapping[category][i]
            axs[i].set_title(
                f"{title_chinese}\n{title_english}", fontproperties=chinese_font)
            axs[i].set_xlabel('← Disagreement — Neutral — Agreement →')
            axs[i].set_ylabel('Frequency')

        # Remove any unused subplots
        for i in range(num_fields, num_rows * 2):
            fig.delaxes(axs[i])

        # Show the plot
        plt.show()

def likert_single_chart(category_index):
    # --- Prep ---------------------------------------------------------------
    categories = list(likert_fields.keys())
    if category_index < 0 or category_index >= len(categories):
        print("Invalid category index")
        return
    selected_category = categories[category_index]
    
    # Rename the columns in the DataFrame for visualization
    df_translated = df.rename(columns={
        field: f"{field} ({field_translation_mapping[selected_category][i]})"
        for i, field in enumerate(likert_fields[selected_category])
    })

    fields = likert_fields[selected_category]
    num_fields = len(fields)
    num_rows = -(-num_fields // 2)  # Equivalent to ceil(num_fields / 2)

    # Pre-compute response counts (non-NA rows) for every item
    respondent_counts = {
        field: df_translated[f"{field} ({field_translation_mapping[selected_category][i]})"].notna().sum()
        for i, field in enumerate(fields)
    }
    # Overall N for this category (largest n among its items)
    total_n = max(respondent_counts.values())

    # Add padding to fit in the Chinese titles
    fig, axs = plt.subplots(num_rows, 2, figsize=(15, 5 * num_rows))
    axs = axs.flatten()
    plt.subplots_adjust(hspace=0.4)

    # Loop through each field in the category to create individual bar plots
    for i, field in enumerate(fields):
        col_name = f"{field} ({field_translation_mapping[selected_category][i]})"
        sns.countplot(
            x=col_name,
            data=df_translated,
            ax=axs[i],
            palette=sns.color_palette("pastel"),
            saturation=1,
        )

        # Build title with bilingual text + N
        title_ch = field
        title_en = field_translation_mapping[selected_category][i]
        n = respondent_counts[field]
        axs[i].set_title(
            f"{title_ch} (n={n})\n{title_en}",
            fontproperties=chinese_font
        )
        axs[i].set_xlabel("← Disagreement — Neutral — Agreement →")
        axs[i].set_ylabel("Frequency")

    # Remove any unused axes
    for i in range(num_fields, num_rows * 2):
        fig.delaxes(axs[i])

    # Add a figure-level title showing overall respondents
    fig.suptitle(
        f"{selected_category} — total respondents: {total_n}",
        fontsize=16,
        y=1.02,
    )

    plt.show()

def correlation_network():
    
    threshold = 0.4
    filtered_df = df[likert_flat_fields]
    filtered_df = filtered_df.apply(pd.to_numeric, errors='coerce')

    # Now you can calculate the correlation matrix and create the network
    corr_matrix = filtered_df.corr()

    # Create a graph
    graph = nx.Graph()

    # Iterate over the correlation matrix and add edges
    for i in range(len(corr_matrix.columns)):
        for j in range(i):
            if abs(corr_matrix.iloc[i, j]) > threshold:  # only consider strong correlations
                graph.add_edge(corr_matrix.columns[i], corr_matrix.columns[j], weight=corr_matrix.iloc[i, j])

    # Draw the network
    pos = nx.spring_layout(graph, k=0.1, iterations=20)
    edges = graph.edges()
    weights = [graph[u][v]['weight'] for u, v in edges]  # Use the weights for edge width

    plt.figure(figsize=(10, 10))
    nx.draw_networkx_nodes(graph, pos, node_size=500, node_color='lightblue', edgecolors='black')
    nx.draw_networkx_edges(graph, pos, edgelist=edges, width=weights, alpha=0.5, edge_color='gray')

    # Set Chinese font
    for label in graph.nodes():
        x, y = pos[label]
        plt.text(x, y, label, fontsize=9, fontproperties=chinese_font, ha='center', va='center')

    plt.title('Correlation Network', fontproperties=chinese_font)
    plt.axis('off')  # Turn off the axis
    plt.show()

def correlation_chart():

    boolean_fields = [
        '你/妳覺得目前有任何投資嗎？'
    ]

    # Encode boolean fields
    for field in boolean_fields:
        df[field + '_encoded'] = df[field].map({'有': 1, '沒有': 0})

    # Combine all fields for correlation
    all_fields = likert_flat_fields + [f"{field}_encoded" for field in boolean_fields]
    
    # Calculate the correlation matrix
    correlation_data = df[all_fields].corr()
    
    # Define a threshold for strong correlations
    threshold = 0.5
    
    # Find all fields that have at least one strong correlation
    strong_fields = correlation_data.columns[np.abs(correlation_data).max() > threshold]

    # Filter the correlation matrix to only include these fields
    filtered_correlation_data = correlation_data.loc[strong_fields, strong_fields]
    
    # Plot the correlation matrix
    plt.figure(figsize=(10, 8))
    ax = sns.heatmap(filtered_correlation_data, annot=True, fmt=".2f", cmap="coolwarm")
    
    # Set the labels with the Chinese font
    ax.set_xticklabels(ax.get_xticklabels(), fontproperties=chinese_font, rotation=45, ha='right')
    ax.set_yticklabels(ax.get_yticklabels(), fontproperties=chinese_font, rotation=0)
    
    # Set the title with the Chinese font
    plt.title("強相關分析", fontproperties=chinese_font)
    plt.show()