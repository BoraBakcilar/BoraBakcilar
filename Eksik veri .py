#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  3 16:45:50 2023

@author: borabakcilar
"""

import numpy as np 
import pandas as pd 

V1 = np.array([1,2,3,np.NaN,7,1,np.NaN,9,15])
V2 = np.array([7,np.NaN,8,15,12,np.NaN,np.NaN,2,3])
V3 = np.array([np.NaN,12,1,4,5,7,np.NaN,2,31 ])

df = pd.DataFrame({
    "V1": V1,
    "V2": V2,
    "V3": V3})

df

df.isnull().sum() # Her değişkende kaç tane nan var gösteriyor 
df.notnull().sum() # eksik olmayan değer sayılarını veriyor 
df.isnull().sum().sum() # Toplam kaç Null var sorusunu cevapladı 

df[df.isnull().any(axis=1)]

df[df.notnull().all(axis=1)]


# Eksik değerlerin silinmesi 

df.dropna(inplace= True)
# direkt silme işlemi böyle 



# BASİT DEĞER ATAMA 

df = pd.DataFrame({
    "V1": V1,
    "V2": V2,
    "V3": V3})

# Ortalama atama 
df["V1"]=df["V1"].fillna(df["V1"].mean()) # mean yerine 0 veya başka değerler atıyabiliriz 

df["V1"].mean() # ortalama değişmedi 


df = pd.DataFrame({
    "V1": V1,
    "V2": V2,
    "V3": V3})


# Fonksiyonel kodlama ile na doldurma 
df.apply(lambda x : x.fillna(x.mean()), axis = 0) 
# apply sayesinde for döngüsü gibi hızlıca istediğimiz değerleri atamaya yarıyan bir fonksiyon yarattık


!pip install missingno
import missingno as msno

msno.bar(df) ; # sağdaki sayılar verimizin boyutununu veriyor 

msno.matrix(df) ; 


import seaborn as sns 

planets = sns.load_dataset("planets")
df = planets.copy()
df
df.isnull().any()
df.isnull().sum()

msno.matrix(df) ;
msno.heatmap(df) ;

# Silme yöntemleri 
df = pd.DataFrame({
    "V1": V1,
    "V2": V2,
    "V3": V3})

df.dropna(how = "all") # Bütün sütunları NA olan satırı atar 

df.dropna(axis=1) # sütunlara göre Na olmayanı sıralar ancak öyle bir sütun olmadığı için sadece indexler basıldı 

df.dropna(axis=0) # satırlar bazında yapar 


df.dropna(axis = 1,how = "all", inplace = True) 
df

# Değer atama yöntemleri 
df = pd.DataFrame({
    "V1": V1,
    "V2": V2,
    "V3": V3})

# Sayısal değerlere atama yöntemleri 
df["V1"].fillna(df["V1"].mean())
df.apply(lambda x : x.fillna(x.mean()))



# Belirli bir aralıktaki sütunların boş satırlarını doldurmak için 

df.fillna(df.mean()["V1":"V2"], inplace= True)

# 3. yol 
df.where(pd.notna(df),df.mean(),axis="columns")


# Kategorik Değişken Kırılımında Değer Atama (Orta-Üst düzey işlem)

my_data = pd.DataFrame({
    "maas": (1,3,6,np.NaN,7,1,np.NaN,9,15),
    "V2": (7,np.NaN,5,8,12,np.NaN,np.NaN,2,3),
    "V3": (np.NaN,12,5,6,14,7,np.NaN,7,31),
    "departman": ("IT","IT","IK","IK","IK","IK","IK","IT","IT")})

my_data.head()
my_data

df = my_data.copy()

maaş =df.groupby("departman")["maas"].mean() # groupby ile departmanlara göre maaş meani aldık 
maaş
df["maas"].fillna(df.groupby("departman")["maas"].transform("mean"), inplace = True)
df



# 
























