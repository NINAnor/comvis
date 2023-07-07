#!/usr/bin/env python3 

import glob
import pandas as pd
import numpy as np

def open_file(filepath):
    df = pd.read_csv(filepath)
    gt = df["choice"].str.split(" ", n = 1, expand = True)
    df["gt"] = gt[0]
    return df

def compute_scores_so(df):
    tp = (df["gt"] == "[SO-TP]").astype(int).sum()
    tn = (df["gt"] == "[SO-TN]").astype(int).sum()
    fp = (df["gt"] == "[SO-FP]").astype(int).sum()
    fn = (df["gt"] == "[SO-FN]").astype(int).sum()

    precision = tp / (tp + fp)
    recall = tp / (tp + fn)
    accurracy = (tp + tn) / (tp + tn + fp + fn)
    F1score = (2 * precision * recall) / (precision + recall)

    return precision, recall, accurracy, F1score

def compute_score_mo(df):

    tp = (df["gt"] == "[MO-TP]").astype(int).sum() # all objects detected
    fp = (df["gt"] == "[MO-FP]").astype(int).sum() # detected > objects
    fn = (df["gt"] == "[MO-FN]").astype(int).sum() # detected < objects

    precision = tp / (tp + fp)
    recall = tp / (tp + fn)
    F1score = (2 * precision * recall) / (precision + recall)

    return precision, recall, F1score

if __name__ == "__main__":

    result_folder = "/home/benjamin.cretois/Code/ComVis/Stage2/md_results"
    result_files = glob.glob(result_folder + "/*.csv")
    df_result = pd.DataFrame()

    for file in result_files:
        df = open_file(file)
        precision, recall, accurracy, F1score = compute_scores_so(df)
        precision_mo, recall_mo, F1score_mo = compute_score_mo(df)

        df_result = pd.concat([df_result, 
                               pd.DataFrame({"Case": file.split("/")[-1], 
                                             "precision_so": precision, 
                                             "recall_so": recall, 
                                             "accurracy_so": accurracy, 
                                             "F1score_so": F1score,
                                             "precision_mo": precision_mo, # Precision < 0.5 means more pictures with detected
                                             "recall_mo": recall_mo, # Recall < 0.5 means more detected < objects than detected = objects
                                             "F1score_mo": F1score_mo}, index=[0])])
        
    print(df_result)
    df_result.to_csv("md_scores.csv")
