import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('data/clean.csv') 

def university_ranking_table():
    # Count the number of respondents for each university and sort them
    university_counts = df["你/妳在哪所大學念書？"].value_counts(
    ).sort_values(ascending=False).reset_index()
    university_counts.columns = ['University', 'Number of Respondents']
    return university_counts

def student_counts():
    # Counting the number of undergraduate and graduate students in the field "你/妳的學習階段："
    student_counts = df['你/妳的學習階段：'].value_counts()

    # Converting the Series to a DataFrame for better table formatting
    student_counts_df = student_counts.reset_index()
    student_counts_df.columns = ['Study Level', 'Number of Students']
    return student_counts_df


def mbti_ranking():
    # Count the occurrences of each MBTI type and sort them
    mbti_counts = df["你/妳的MBTI？（選填）"].value_counts(
    ).sort_values(ascending=False).reset_index()
    mbti_counts.columns = ['MBTI Type', 'Number of Students']
    return mbti_counts


def field_of_study_ranking():
    # Count the occurrences of each field of study and sort them
    field_of_study_counts = df["你/妳的學習科系："].value_counts(
    ).sort_values(ascending=False).reset_index()
    field_of_study_counts.columns = ['Field of Study', 'Number of Students']
    return field_of_study_counts


def student_age_ranking():
    # Count the occurrences of each age and sort them
    age_counts = df["你/妳幾歲？"].value_counts(
    ).sort_values(ascending=False).reset_index()
    age_counts.columns = ['Age', 'Number of Students']
    return age_counts