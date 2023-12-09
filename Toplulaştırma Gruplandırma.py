#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 27 16:26:24 2023

@author: borabakcilar
"""

# Toplulaştırma & Gruplama


# Bazı fonksiyonlar
count()
first()
last()
mean()
median()
min()
max()
std()
var()
sum()


## Toplulaştırma

import seaborn as sns
import pandas as pd 
import numpy as np

df = sns.load_dataset("planets")

df.head()
df.shape

df.count()
df.mean()
df["mass"].mean()

df["mass"].min()

df.describe()
df.describe().T # Describe fonksiyonunun çıktısının transpozesini basar.

#Na varsa betimsel istatistikleri görmek için:
    df.dropna().describe().T

## Gruplama

df = pd.DataFrame({
    "gruplar": ["A", "B", "C", "A", "B", "C"],
    "veri": np.random.randint(1, 100, size=6)
})


df

df.groupby("gruplar") # Tek başına çalışmaz 


df.groupby("gruplar").mean()

df.groupby("gruplar")




df2 = sns.load_dataset("planets")

df2.groupby("method")["orbital_period"].mean()


### Aggregate

df = pd.DataFrame({
    "gruplar": ["A", "B", "C", "A", "B", "C"],
    "veri1": np.random.randint(1, 100, size=6),
    "veri2": np.random.randint(700, 1500, size=6),
}, columns=["gruplar","veri1","veri2"])

df

df.groupby("gruplar").aggregate([min,np.median,max])



""" özellikle gruplandırma yaparken spesifik bir şey arıyorsak aradığımız şeyi 
fonksiyon halinde yazabiliriz bu bizim işimizi kolaylaştırır 
"""
def myfunc(x): 
    return x["veri1"].std() > 20

df.groupby("gruplar").std()


df.groupby("gruplar").filter(myfunc)

### Trasnform 
# lambda "def" işlevini görüyor

df.iloc[:,1:3].transform(lambda x : x-x.mean())


### APPLY

df.apply(np.sum)

df.apply(np.mean)
 


































