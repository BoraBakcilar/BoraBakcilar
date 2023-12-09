#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 26 13:07:29 2023

@author: borabakcilar
"""

import pandas as pd 

l = [1,2,39,60,72]
l_pd =pd.DataFrame(l,columns= ['degisken'])

import numpy as np 

m = np.arange(1,10).reshape(((3,3)))
m

pd.DataFrame(m, columns= ['my','data','col'])

# df isimlendirme 

df = pd.DataFrame(m, columns= ["var1","var2","var3"])
df
df.columns = ("deg1","deg2","deg3")
df.head()
# data frame özellik sorgulaması
type(df)
df.axes
df.shape
df.ndim
df.values
df.isna()


a = np.array([1,2,3,4,5])
a
# numpy arrayden pd dataframe e geçtik 
pd.DataFrame(a,columns= ["deg1"])


# Pandasta Eleman işlemleri 

s1 = np.random.randint(10,size = 5)  #randint = "random integer"
s2 = np.random.randint(10,size=5)
s3 = np.random.randint(10,size = 5)


sozluk = {"var1": s1,
          "var2": s2,
          "var3": s3}
sozluk
df = pd.DataFrame(sozluk) 
df

# Pandasta index değerlerini değiştirmek
df.index = ["a","b","c","d","e"]
df[0:2] # 1. satırdan 3. satıra kadar deriz 
df["c":"e"] # "c" den "e" satırına kadar ( e dahil ama ?)

### Silme işlemi 

df.drop("b",axis= 0)
df

df.drop("a",axis=0, inplace= True) # inplace = True olunca yapılan işlem direkt df üstüne yapılıyor
df

# inplace = True yazmak yerine direkt df = dersekte olur aga 

### Fancy 
l = ["c","d"]
df.drop(l,axis=0) # l = R daki c(...) gibi işlem gördü değişken atadık diyebiliriz. drop fonksiyonu aynı işlemi gerçekleştirdi



# For döngüsü ile eleman sorgulama 

l = ["var1","var2","var4"]

for i in l:
    print(i in df)


df["var4"] = df["var1"] / df["var3"]
df

# Değişken silmek 
df.drop("var4", axis=1, inplace=True)  #axis = 0 satırlar, axis = 1 sütunlar için 
df

l = ["var1","var2"]
df.drop(l, axis=1)










