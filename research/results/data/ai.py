import warnings
warnings.filterwarnings("ignore")

from kmodes.kmodes import KModes
import pandas as pd
from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from data.fields.prod_feat_flat_fields import prod_feat_flat_fields
from data.fields.feature_translations import feature_translations
from data.fields.likert_flat_fields import likert_flat_fields

df = pd.read_csv('data/clean.csv') 
chinese_font = FontProperties(fname='data/fonts/notosans.ttf', size=12)

def ai_roles():
    # Check if the "其他" column exists and concatenate it with the AI roles column if it does
    if "其他" in df.columns:
        df["你/妳想要AI扮什麼角色？"] = df["你/妳想要AI扮什麼角色？"].str.cat(df["其他"], na_rep='', sep=' ')

    # Summarize the data
    ai_roles_data = df["你/妳想要AI扮什麼角色？"].value_counts().head(20)

    # Plot the data
    plt.figure(figsize=(10, 6))
    ai_roles_data.plot(kind='bar', color='skyblue')
    plt.title('Preferred AI Roles', fontproperties=chinese_font)
    plt.xlabel('Roles', fontproperties=chinese_font)
    plt.ylabel('Number of Responses', fontproperties=chinese_font)
    plt.xticks(rotation=45, ha='right', fontproperties=chinese_font)
    plt.tight_layout()
    plt.show()


def perform_kmodes_clustering():

    n_clusters=3

    # Extract the relevant fields for clustering
    cluster_data = df[prod_feat_flat_fields]

    # Convert boolean features to integer type
    cluster_data_encoded = cluster_data.astype(int)

    # Define the K-modes model
    km = KModes(n_clusters=n_clusters, init='Huang', n_init=5, verbose=1)

    # Fit the cluster model
    clusters = km.fit_predict(cluster_data_encoded)

    # Add the cluster labels to the original dataframe
    df['Cluster'] = clusters

    # Create a dictionary to store dataframes for each cluster
    cluster_dict = {}
    for cluster in df['Cluster'].unique():
        cluster_df = df[df['Cluster'] == cluster]
        cluster_dict[cluster] = cluster_df

    return cluster_dict


def radar_chart():

    clusters = perform_kmodes_clustering()

    df_dict={
        'Conscious (n=340)': clusters[0],
        'Interested (n=215)': clusters[1],
        'Advocate (n=126)': clusters[2]
    }

    feature_translations_dict = dict(zip(prod_feat_flat_fields, feature_translations))
    persona_averages = [df[list(feature_translations_dict.keys())].mean().tolist() for df in df_dict.values()]
      
    # Append the first value at the end of each list for the radar chart
    for averages in persona_averages:
        averages += averages[:1]
    
    # Prepare the English labels for plotting
    english_feature_labels = list(feature_translations)
    english_feature_labels += [english_feature_labels[0]]  # Repeat the first label to close the loop
    
    # Number of variables we're plotting
    num_vars = len(english_feature_labels)
    
    # Split the circle into even parts and save the angles
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]  # Complete the loop
    
    # Set up the font properties for using a custom font
    fig, ax = plt.subplots(figsize=(12, 12), subplot_kw=dict(polar=True))
    fig.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)

    # Draw one axe per variable and add labels
    plt.xticks(angles[:-1], english_feature_labels, color='grey', size=12, fontproperties=chinese_font)
    
    # Draw ylabels
    ax.set_rlabel_position(0)
    plt.yticks([0.2, 0.4, 0.6, 0.8, 1], ["0.2", "0.4", "0.6", "0.8", "1"], color="grey", size=7)
    plt.ylim(0, 1)
    
    # Plot data and fill with color
    for label, data in zip(df_dict.keys(), persona_averages):
        data += data[:1]  # Complete the loop
        ax.plot(angles, data, label=label, linewidth=1, linestyle='solid')
        ax.fill(angles, data, alpha=0.25)
    
    # Add legend
    plt.legend(title='Personas')
    plt.legend(loc='upper right', bbox_to_anchor=(0.1, 0.1))
    
    # Add a title
    plt.title('Product Feature Preferences by Persona', size=20, color='grey', y=1.1, fontproperties=chinese_font)
    
    # Display the radar chart
    plt.show()


def plot_feature_preferences():
    # Given comparative table data
    data = {
        'Feature': [
            "買東西先查看產品的運輸距離（是不是當地食品)\nCheck Product Transportation Distance (Whether it is Local Food)",
            "買東西先查看公司生產過程 多環保\nCheck Company's Eco-Friendly Production Process",
            "買東西先查看公司工人的員工 福利多好\nCheck Company Worker Welfare",
            "投資前查看AI摘要的消費者對公司環保的評論\nReview Consumer Eco Comments on Companies before Investing",
            "用社交網絡認識其他環保的同學\nMeet Eco-Friendly Peers on Social Networks",
            "買東西先了解哪些產品污染最嚴重，以便避免它們\nUnderstand Which Products are Most Polluting to Avoid Them",
            "每個月查看我自己的環保分數報告（了解我用錢的方式多環保\nMonthly Review of My Eco Score Report (Understanding How My Spending is Eco-Friendly)",
            "買東西先尋找有機產品 Search for\nOrganic Products Before Purchasing",
            "跟我的AI幫手討論環保問題\nDiscuss Environmental Issues with My AI Assistant",
            "投資前查看公司的環保認證和生態評分\nCheck Company's Environmental Certifications and Eco-Scores Before Investing",
            "如何讓我支持的公司更環保\nHow to Make the Companies I Support More Eco-Friendly",
            "買東西先了解我吃的動物性食品動物的生活環境\nUnderstand the Living Conditions of Animals for the Animal Products I Consume",
            "老實說我對任何環保資訊都沒有太多興趣\nHonestly, I'm Not Very Interested in Any Eco Information",
            "投資前比較公司的環保表現\nCompare Companies' Environmental Performance Before Investing"
        ],
        'Conscious (n=340)': [0.367, 0.415, 0.191, 0.176, 0.079, 1.000, 0.197, 0.265, 0.144, 0.241, 0.144, 0.332, 0.044, 0.188],
        'Interested (n=215)': [0.260, 0.163, 0.153, 0.191, 0.107, 0.000, 0.135, 0.219, 0.172, 0.186, 0.093, 0.214, 0.233, 0.130],
        'Advocate (n=126)': [0.825, 0.881, 0.460, 0.746, 0.230, 0.881, 0.667, 0.690, 0.421, 0.865, 0.468, 0.778, 0.143, 0.738]
}
    # Create a DataFrame
    df = pd.DataFrame(data)

    # Set the 'Feature' column as the index
    df.set_index('Feature', inplace=True)

    # Plot
    fig, ax = plt.subplots(figsize=(14, 8))
    df.plot(kind='bar', width=0.8, ax=ax)

    # Set titles and labels using the Chinese font where necessary
    plt.title('Comparison of Product Feature Preferences by Persona', fontproperties=chinese_font)
    plt.ylabel('Average Score', fontproperties=chinese_font)
    plt.xlabel('Feature', fontproperties=chinese_font)
    plt.xticks(rotation=45, ha='right', fontproperties=chinese_font)

    # Set the x-tick labels to use the Chinese font
    ax.set_xticklabels(df.index, fontproperties=chinese_font, rotation=45, ha='right')

    plt.legend(title='Personas')

    # Ensure layout is tight so everything fits
    plt.tight_layout()
    plt.show()

def likert_cluster_and_visualize():
    # Clean the DataFrame column names
    df.columns = [col.strip() for col in df.columns]

    # Also clean the likert_flat_fields if necessary
    lff = [field.strip() for field in likert_flat_fields]

    # Prepare the likert data, dropping any rows with missing values
    df_likert_data = df[lff].dropna()

    # Perform k-means clustering
    kmeans = KMeans(n_clusters=3, n_init=10, random_state=42).fit(df_likert_data)
    df_likert_data['Cluster'] = kmeans.labels_

    # Concatenate the cluster labels with the original data
    df_clustered = pd.concat([df, df_likert_data['Cluster']], axis=1)

    # Aggregate the product preference data for each cluster
    cluster_preferences = []
    for i in range(3):
        cluster_data = df_clustered[df_clustered['Cluster'] == i]
        cluster_preferences.append(cluster_data[prod_feat_flat_fields].mean())

    # Radar Chart Plotting
    df_dict = {
        'Eco-Friendly': cluster_preferences[0],
        'Moderate': cluster_preferences[1],
        'Frugal': cluster_preferences[2]
    }

    persona_averages = [df_dict[key].tolist() for key in df_dict]

    # Append the first value at the end of each list for the radar chart
    for averages in persona_averages:
        averages += averages[:1]
    
    # Prepare the English labels for plotting
    english_feature_labels = list(feature_translations)
    english_feature_labels += [english_feature_labels[0]]  # Repeat the first label to close the loop
    
    # Number of variables we're plotting
    num_vars = len(english_feature_labels)
    
    # Split the circle into even parts and save the angles
    angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
    angles += angles[:1]  # Complete the loop
    
    # Set up the font properties for using a custom font
    fig, ax = plt.subplots(figsize=(12, 12), subplot_kw=dict(polar=True))
    fig.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)

    # Draw one axe per variable and add labels
    plt.xticks(angles[:-1], english_feature_labels, color='grey', size=12, fontproperties=chinese_font)
    
    # Draw ylabels
    ax.set_rlabel_position(0)
    plt.yticks([0.2, 0.4, 0.6, 0.8, 1], ["0.2", "0.4", "0.6", "0.8", "1"], color="grey", size=7)
    plt.ylim(0, 1)
    
    # Plot data and fill with color
    for label, data in zip(df_dict.keys(), persona_averages):
        data += data[:1]  # Complete the loop
        ax.plot(angles, data, label=label, linewidth=1, linestyle='solid')
        ax.fill(angles, data, alpha=0.25)
    
    # Add legend
    plt.legend(title='Personas')
    plt.legend(loc='upper right', bbox_to_anchor=(0.1, 0.1))
    
    # Add a title
    plt.title('Product Feature Preferences by Persona', size=20, color='grey', y=1.1, fontproperties=chinese_font)
    
    # Display the radar chart
    plt.show()