import warnings
warnings.filterwarnings("ignore")

import pandas as pd
import numpy as np
import textwrap
import matplotlib.pyplot as plt
import seaborn as sns
import squarify
from adjustText import adjust_text
from wordcloud import WordCloud
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from matplotlib.font_manager import FontProperties
from data.fields.likert_flat_fields import likert_flat_fields

df = pd.read_csv('data/clean.csv') 
chinese_font = FontProperties(fname='data/fonts/notosans.ttf', size=12)

def show_personas():

    # Prepare the data and perform clustering and PCA
    df_clustered, pca, cluster_centers = prepare_data_for_pca()

    # Retain colors
    unique_clusters = df_clustered['Cluster'].unique()
    palette = sns.color_palette('pastel', n_colors=len(unique_clusters))
    cluster_palette = {cluster: color for cluster, color in zip(unique_clusters, palette)}

    # Cluster names
    cluster_names = {
        0: 'Eco-Friendly',
        1: 'Moderate',
        2: 'Frugal',
    }

    cluster_descriptions = {
        0: 'desc 1',
        1: 'desc 2',
        2: 'desc 3',
    }

    # Show a scatterplot with all clusters included
    plot_scatterplot(df_clustered, pca, cluster_centers, chinese_font, cluster_palette, cluster_names, cluster_descriptions, "Distinct Respondent Profiles Based on K-means Clustering")


def show_single_persona(cluster_id): 

    # Prepare the data and perform clustering and PCA
    df_clustered, pca, cluster_centers = prepare_data_for_pca()

    # Retain colors
    unique_clusters = df_clustered['Cluster'].unique()
    palette = sns.color_palette('pastel', n_colors=len(unique_clusters))
    cluster_palette = {cluster: color for cluster, color in zip(unique_clusters, palette)}

    # Cluster names
    cluster_names = {
        0: 'Eco-Friendly',
        1: 'Moderate',
        2: 'Frugal',
    }

    cluster_descriptions = {
        0: 'desc 1',
        1: 'desc 2',
        2: 'desc 3',
    }

    df_cluster = df_clustered[df_clustered['Cluster'] == cluster_id]
    plot_scatterplot(df_cluster, pca, cluster_centers, chinese_font, cluster_palette, cluster_names, cluster_descriptions, title=f'Clustered Survey Responses')
    plot_loadings_for_cluster(cluster_id, df_cluster, cluster_names, chinese_font)
    pca_biplot(df_cluster, cluster_names, chinese_font)
    new_biplot(df, cluster_id, cluster_names, chinese_font)


def plot_loadings_for_cluster(cluster_id, df_cluster, cluster_names, chinese_font, num_components=2, num_top_features=30):

    # Perform PCA on the cluster data
    pca = PCA(n_components=num_components)
    pca.fit(df_cluster[likert_flat_fields])
    
    # Get the loadings for the first principal component
    loadings = pca.components_[0]
    
    # Sort the loadings and select the most significant ones for plotting
    sorted_idx = np.argsort(np.abs(loadings))[::-1]
    top_features = np.array(likert_flat_fields)[sorted_idx][:num_top_features]
    top_loadings = loadings[sorted_idx][:num_top_features]

    # Plotting the results with the Chinese font
    fig, ax = plt.subplots(figsize=(10, 15))
    ax.barh(top_features, top_loadings, color='skyblue')
    ax.set_xlabel('Loading', fontproperties=chinese_font)
    print(f'<h3 style="text-align: center;">Questions Most Affecting Persona Creation</h3>')
    ax.set_yticklabels(top_features, fontproperties=chinese_font)
    ax.invert_yaxis()  # To display the highest bars at the top

    plt.show()

def plot_loadings(cluster_id, pca, cluster_names, chinese_font):
    # Get the loadings for the first principal component
    loadings = pca.components_[0]
    # Sort the loadings and select the most significant ones for plotting
    sorted_idx = np.argsort(np.abs(loadings))[::-1]
    top_features = np.array(likert_flat_fields)[sorted_idx][:30]
    top_loadings = loadings[sorted_idx][:30]

    # Plotting the results with the Chinese font
    fig, ax = plt.subplots(figsize=(10, 15))  # Increase the height here
    ax.barh(top_features, top_loadings, color='skyblue')
    ax.set_xlabel('Loading', fontproperties=chinese_font)
    print(f'<h2 style="text-align: center;">Feature Weights for Cluster {cluster_id+1}: "{cluster_names[cluster_id]}"</h2>')
    ax.set_yticklabels(top_features, fontproperties=chinese_font)
    ax.invert_yaxis()  # To display the highest bars at the top
    plt.show()


def new_biplot(df, cluster_id, cluster_names, chinese_font, threshold=0.5, zoom_factor=0.1):

    # Perform PCA
    pca = PCA(n_components=2)
    pca.fit(df[likert_flat_fields])
    components = pca.transform(df[likert_flat_fields])
    loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

    # Calculate the range for the components
    x_min, x_max = components[:, 0].min() - zoom_factor, components[:, 0].max() + zoom_factor
    y_min, y_max = components[:, 1].min() - zoom_factor, components[:, 1].max() + zoom_factor

    # Plot
    fig, ax = plt.subplots(figsize=(12, 8))  # Larger figure size
    scatter = ax.scatter(components[:, 0], components[:, 1], alpha=0.6, marker="*", color="blue")

    texts = []
    arrows = []

    for i, loading in enumerate(loadings):
        if np.sqrt(loading[0]**2 + loading[1]**2) > threshold:
            arrows.append(ax.arrow(0, 0, loading[0], loading[1], head_width=0.05, head_length=0.1, fc='r', ec='r'))
            texts.append(ax.text(loading[0]*1.2, loading[1]*1.2, likert_flat_fields[i], color='g', ha='center', va='center',
                                 fontproperties=chinese_font, bbox=dict(facecolor='white', alpha=0.7, edgecolor='none')))

    adjust_text(texts, arrowprops=dict(arrowstyle='<-', color='red'))

    ax.set_title(f'Feature Weights (Readable Version)', fontproperties=chinese_font)
    ax.set_xlabel('Principal Component 1', fontproperties=chinese_font)
    ax.set_ylabel('Principal Component 2', fontproperties=chinese_font)
    ax.grid(True)
    ax.axis('equal')  # Equal scaling for both axes

    # Set the axes limits to zoom in
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_min, y_max)
    plt.show()

def pca_biplot(df, cluster_names, chinese_font):
    # Perform PCA
    pca = PCA(n_components=2)
    pca.fit(df)
    components = pca.transform(df)
    loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

    # Plot
    fig, ax = plt.subplots(figsize=(12, 8))  # You can adjust the figure size as needed
    scatter = ax.scatter(components[:, 0], components[:, 1], alpha=0.6, marker="*", color="blue")
    
    max_length = np.sqrt(np.max(loadings**2, axis=0))
    for i, loading in enumerate(loadings):
        ax.arrow(0, 0, loading[0], loading[1], head_width=0.05, head_length=0.1, fc='r', ec='r')
        # Adjust text placement
        text_x = loading[0] * 1.2
        text_y = loading[1] * 1.2
        # Adjust text position based on the loading's length
        text_x = max(min(text_x, max_length[0]*0.8), -max_length[0]*0.8)
        text_y = max(min(text_y, max_length[1]*0.8), -max_length[1]*0.8)
        ax.text(text_x, text_y, df.columns.values[i], color='g', ha='center', va='center', fontproperties=chinese_font)
    
    ax.set_title('Feature Weights (Survey Questions)', fontproperties=chinese_font)
    ax.set_xlabel('Principal Component 1', fontproperties=chinese_font)
    ax.set_ylabel('Principal Component 2', fontproperties=chinese_font)
    ax.grid(True)
    ax.axis('equal')  # Setting equal axes for better proportionality
    plt.show()

def add_border(input_image, border_color, border_width):
    from PIL import Image, ImageOps
    img = Image.fromarray(input_image)
    img_with_border = ImageOps.expand(img, border=border_width, fill=border_color)
    return np.array(img_with_border)

def plot_wordcloud(pca, cluster_id, cluster_names, chinese_font, num_top_features=30):
    components = pca.components_
    border_color = (0, 0, 0)
    border_width = 2
    
    # Assuming likert_flat_fields is defined elsewhere in your code
    sorted_idx_1 = np.argsort(np.abs(components[0]))[::-1]
    sorted_idx_2 = np.argsort(np.abs(components[1]))[::-1]
    top_features_1 = np.array(likert_flat_fields)[sorted_idx_1][:num_top_features]
    top_features_2 = np.array(likert_flat_fields)[sorted_idx_2][:num_top_features]
    
    loadings1 = {feature: components[0, i] for i, feature in enumerate(likert_flat_fields) if feature in top_features_1}
    loadings2 = {feature: components[1, i] for i, feature in enumerate(likert_flat_fields) if feature in top_features_2}
    
    wordcloud1 = WordCloud(width=800, height=400, background_color='white', colormap='viridis', font_path=chinese_font.get_file()).generate_from_frequencies(loadings1)
    wordcloud2 = WordCloud(width=800, height=400, background_color='white', colormap='plasma', font_path=chinese_font.get_file()).generate_from_frequencies(loadings2)
    
    # Convert word clouds to images and then to arrays for adding borders
    wordcloud1_image = wordcloud1.to_image()
    wordcloud2_image = wordcloud2.to_image()
    wordcloud1_array_with_border = add_border(np.array(wordcloud1_image), border_color, border_width)
    wordcloud2_array_with_border = add_border(np.array(wordcloud2_image), border_color, border_width)
    
    # Display images using matplotlib for compatibility with Quarto
    fig, axs = plt.subplots(1, 2, figsize=(20, 10))
    
    axs[0].imshow(wordcloud1_array_with_border)
    axs[0].axis('off')
    axs[0].set_title(f'Persona "{cluster_names[cluster_id]}" - Word Cloud for Principal Component 1')
    
    axs[1].imshow(wordcloud2_array_with_border)
    axs[1].axis('off')
    axs[1].set_title(f'Persona "{cluster_names[cluster_id]}" - Word Cloud for Principal Component 2')
    
    plt.tight_layout()
    plt.show()


def get_kmeans_table():

    # Select only the relevant columns for clustering
    df_likert_real_data = df[likert_flat_fields]

    # Drop rows with missing values for a more accurate clustering
    df_likert_real_data = df_likert_real_data.dropna()

    # Perform k-means clustering to group students into 3 clusters
    kmeans_real_data = KMeans(n_clusters=3, n_init=10,
                              random_state=42, verbose=False).fit(df_likert_real_data)

    # Add the cluster labels to the DataFrame
    df_likert_real_data['Cluster'] = kmeans_real_data.labels_

    # Calculate the mean score for each question in each cluster
    cluster_means_real_data = df_likert_real_data.groupby(
        'Cluster').mean().reset_index()

    # Display the table
    print("Mean response values for each likert question in each cluster:")
    print(cluster_means_real_data)


def show_clustering_heatmap():
    # Filter the DataFrame to only include the Likert scale fields
    df_likert_data = df[likert_flat_fields]

    # Drop rows with missing values for accurate clustering
    df_likert_data = df_likert_data.dropna()

    # Perform k-means clustering with 3 clusters
    kmeans_likert_data = KMeans(
        n_clusters=3, n_init=10, random_state=42, verbose=False).fit(df_likert_data)

    # Add the cluster labels to the DataFrame
    df_likert_data['Cluster'] = kmeans_likert_data.labels_

    # Create a figure and a set of subplots
    fig, ax = plt.subplots(figsize=(20, 8))

    # Create a heatmap using the created ax (Axes object)
    sns.heatmap(df_likert_data.groupby('Cluster').mean(),
                cmap="coolwarm", annot=True, cbar=True, ax=ax)

    # Set the title and labels using the provided Chinese font properties
    ax.set_title('Heatmap of 3 Clusters Based on Likert Scale Questions',
                 fontproperties=chinese_font)
    ax.set_xlabel('Questions', fontproperties=chinese_font)
    ax.set_ylabel('Cluster ID', fontproperties=chinese_font)

    # Rotate the x-axis labels for better readability
    wrapped_labels = [textwrap.fill(label.get_text(), width=10) for label in ax.get_xticklabels()]
    ax.set_xticklabels(wrapped_labels, rotation=45, fontproperties=chinese_font)

    plt.show()


def prepare_data_for_pca():
    # Prepare the likert data, dropping any rows with missing values
    df_likert_data = df[likert_flat_fields].dropna()

    # Perform k-means clustering
    kmeans = KMeans(n_clusters=3, n_init=10, random_state=42, verbose=False).fit(df_likert_data)
    df_likert_data['Cluster'] = kmeans.labels_

    # Fit PCA on the likert data (excluding the 'Cluster' column)
    pca = PCA(n_components=2)
    pca.fit(df_likert_data.drop('Cluster', axis=1))

    # Transform the data using PCA
    pca_components = pd.DataFrame(pca.transform(df_likert_data.drop('Cluster', axis=1)),
                                  columns=['Component_1', 'Component_2'])
    
    # Reset index to enable proper concatenation
    df_likert_data.reset_index(drop=True, inplace=True)
    pca_components.reset_index(drop=True, inplace=True)

    # Concatenate the PCA components with the original data (which includes the 'Cluster' column)
    df_clustered = pd.concat([pca_components, df_likert_data], axis=1)

    # Calculate the cluster centers in the PCA-transformed space
    cluster_centers = pca.transform(kmeans.cluster_centers_)

    return df_clustered, pca, cluster_centers


def plot_scatterplot(df, pca, cluster_centers, chinese_font, cluster_palette, cluster_names, cluster_descriptions, title):
    # Create a figure and a set of subplots
    fig, ax = plt.subplots(figsize=(10, 10))

    # Calculate cluster counts
    cluster_counts = df['Cluster'].value_counts()

    # Plot the scatterplot
    scatter = sns.scatterplot(
        x='Component_1', y='Component_2', hue='Cluster',
        data=df, palette=cluster_palette, s=100, alpha=0.6, ax=ax, marker="*"
    )

    # Get unique cluster labels sorted by value
    unique_clusters = sorted(df['Cluster'].unique())

    # Check if the scatterplot is individual
    is_individual = len(unique_clusters) == 1

    # Add the cluster centers for all clusters if plotting combined scatterplot
    for label in unique_clusters:
        # Use the label to index cluster_centers directly if it's a dictionary
        center = cluster_centers[label]
        ax.scatter(center[0], center[1], c=cluster_palette[label], s=200,
                   alpha=0.75, marker='o', edgecolors='k')
        # Annotate the number of respondents in the cluster
        ax.text(center[0], center[1], str(cluster_counts[label]), color='black', 
                ha='center', va='center', fontproperties=chinese_font)
        # Write custom descriptive text above each cluster if showing individual scatterplot
        if is_individual and label in cluster_descriptions:
            print(f'<h2 style="text-align: center;">Persona {label+1}: "{cluster_names[label]}"</h2>')
            print(cluster_descriptions[label])
            ax.text(center[0], center[1]+0.1, cluster_names[label], color='black', 
                    ha='center', va='bottom', fontproperties=chinese_font)

    # Set titles and labels
    ax.set_title(title, fontproperties=chinese_font)
    ax.set_xlabel('Principal Component 1', fontproperties=chinese_font)
    ax.set_ylabel('Principal Component 2', fontproperties=chinese_font)

    # Extract handles and labels from the scatterplot
    handles, labels = scatter.get_legend_handles_labels()
    
    # Update labels with custom names and counts
    new_labels = [f'Persona {label+1}: {cluster_names[label]} (n={cluster_counts[label]})' for label in unique_clusters]
    # Update the legend with the new labels
    ax.legend(handles=handles, labels=new_labels, title='Personas', loc='upper right')

    # Use the figure object (fig) to display the plot
    plt.show()


def add_border(img_array, color, width):
    new_shape = (
        img_array.shape[0] + 2 * width,  # new height
        img_array.shape[1] + 2 * width,  # new width
        img_array.shape[2]               # number of color channels
    )
    border_img_array = np.zeros(new_shape, dtype=np.uint8)
    border_img_array[:width, :, :] = color
    border_img_array[-width:, :, :] = color
    border_img_array[:, :width, :] = color
    border_img_array[:, -width:, :] = color
    border_img_array[width:-width, width:-width, :] = img_array
    return border_img_array

def treemap():
    categories = {
        'Ethical Consumption and Labor Concerns': 3.2,
        'Environmental Awareness and Action': 3.8,
        'Economic Views and Sustainability': 2.9,
        'Personal Finance and Investment': 3.5,
        'Technology and AI Engagement': 3.1,
        'Health and Safety Concerns': 4.2,
        'Climate and Pollution Concerns': 4.0
    }
    
    # Create sizes for the rectangles based on the average agreement levels
    sizes = [value for value in categories.values()]
    
    # Create labels for the rectangles with the category name and the size
    labels = [f'{key}\n({value:.2f})' for key, value in categories.items()]
    
    # Choose colors for each category
    colors = [plt.cm.Spectral(i/float(len(labels))) for i in range(len(labels))]

    # Create a figure and a set of subplots
    fig, ax = plt.subplots(figsize=(12, 8))
    
    # Create the treemap on the created axes ax
    squarify.plot(sizes=sizes, label=labels, color=colors, alpha=0.8, text_kwargs={'fontsize':9}, ax=ax)
    
    # Remove the axis for a cleaner look
    ax.axis('off')
    
    # Add a title to the plot
    plt.title('Average Agreement Level by Question Category', fontsize=15)
    plt.show()