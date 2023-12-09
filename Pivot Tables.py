#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 21:30:25 2023

@author: borabakcilar
"""
import pandas as pd 
import seaborn as sns
titanic =  sns.load_dataset('titanic')
titanic.head()


titanic.groupby("sex")["survived"].mean()

titanic.groupby(["sex","class"])[["survived"]].aggregate("mean").unstack()

titanic.pivot_table("survived",index = "sex",columns = "class")
titanic.pivot_table("survived",index = ["sex","deck"],columns = "class")  # gereksiz

age = pd.cut(titanic["age"],[0,18,90])  # Kategorikal ayrıştırma !!!
age

titanic.pivot_table("survived", ["sex",age], "class" )
























