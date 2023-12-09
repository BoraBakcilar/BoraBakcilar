#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 11:03:41 2023

@author: borabakcilar
"""

import seaborn as sns 

diamonds = sns.load_dataset("diamonds")

df = diamonds.copy()
df.describe().T
df_numeric = df.select_dtypes(include = ["float64","int64"])
df_ = df_numeric.dropna()
df_


df_table = df["table"]
sns.boxplot(data = df, x = "table");
Q1 = df_table.quantile(0.25)
Q3 = df_table.quantile(0.75)
IQR = Q3-Q1
IQR

# Alt ve üst sınırlar için Qi +- 1.5*IQR yaparız 

alt_sinir = Q1 - 1.5*IQR
üst_sinir = Q3 + 1.5* IQR

df_outlierless = df_table[alt_sinir,üst_sinir]


import pandas as pd 

type(df_table)
df_table = pd.DataFrame(df_table)



# Verilen sınırların dışında olanları almak için ~ "tilda" kullandık 
# bu kod sayesinde outlierlardan kurtulduk. 
# Kodun anlamı: bu sınırlar dışındakini al .any(axis=1) row bazında yap
t_df = df_table[~(((df_table < alt_sinir)| (df_table > üst_sinir))).any(axis=1)]
t_df




### Baskılama yöntemi ile ayıklama 
# aykırı değerler hangi taraftaysa o tarafın eşik değerlerine gönderilir.
# Yani üst sınır tarafındaysa üst sınıra eşitlenir 
# Alt taraftaysa alt sınırına atanır 
df_table[(df_table < alt_sinir)] = alt_sinir


df_table.min()
df_table[(df_table > üst_sinir)] = üst_sinir
df_table.max()


### ÇOK DEĞİŞKENLİ AYKIRI GÖZLEM ANALİZİ
import seaborn as sns 
diomands = sns.load_dataset("diamonds")
df = diomands.copy()

df= df.dropna()
df.head()
df.describe().T

### Not:
    
# Local Outlier Factor  (LOF)
""" Gözlemlerin bulundukları konumda yoğunluk tabanlı skorlıyarak buna göre aykırı değer 
olabilcek değerleri tanımlamamıza yarar.
 Bir noktanın local yoğunluğu komşuları ile karşılaştırılıyor. Eğer bir nokta komşularının 
yoğunlupundan anlamlı şekilde bir fark varsa outlier olarak adlandırılıyor 
yani yoğunluk anlamda yalnız kalan veriler bizim için outlier oluyor"""

######

import numpy as np 
from sklearn.neighbors import LocalOutlierFactor

clf = LocalOutlierFactor(n_neighbors= 20, contamination=0.1) # contamination = yoğunluk 

# Sayısal verilerde yürütülür 
df_numeric = df.select_dtypes(include = ["float64","int64"])

clf.fit_predict(df_numeric)

df_scores = clf.negative_outlier_factor_
df_scores
np.sort(df_scores)[0:20]

esik_deger = np.sort(df_scores)[13] # örneğin bunu aldık gerçekten bu değil 

aykiri_tf = df_scores > esik_deger # aykırı vektörü 

df2 = df[df_scores > esik_deger]
df2

# esik değerler için en başta numericleri alıp onlar üstünden aykırı olanları belirledik yani 
# veri setimiz içinde aykırıları ayıklıyoruz 

df[df_scores < esik_deger]
df[df_scores == esik_deger]

baski_deger = df[df_scores == esik_deger]

aykirilar = df[~aykiri_tf]

res = aykirilar.to_records(index = False).copy()

res[:] = baski_deger.to_records(index = False)

import pandas as pd 
df[~aykiri_tf] = pd.DataFrame(res,index = df[~aykiri_tf].index)

