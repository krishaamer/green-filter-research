#| label: setup
#| echo: false
import pandas as pd
import matplotlib.pyplot as plt

# Load your DataFrame
df = pd.read_csv('data/clean.csv')  # Make sure to adjust the path to your dataset

#| label: university_ranking
#| echo: false
def generate_university_ranking_table():
    university_counts = df["你/妳在哪所大學念書？"].value_counts().sort_values(ascending=False).reset_index()
    university_counts.columns = ['University', 'Number of Respondents']
    return university_counts