#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 27 15:27:03 2023

@author: borabakcilar
"""

# Birleştirme (join)


import numpy as np 
import pandas as pd 

m = np.random.randint(1,30, size = (10,3))

df1 = pd.DataFrame(m, columns= ["var1","var2","var3"])


df2 = df1 + 99

pd.concat([df1,df2]) # indexleri kendileri ile aynısını yapmış 0-9, 0-9 

?pd.concat

pd.concat([df1,df2], ignore_index= True) # False olursa index problemi devam ediyor

df.columns

df1.columns = ["var1","var2","deg1"]

pd.concat([df1,df2]) # var3 ile deg1 artık aynı sütun ismine sahip değil ondan dolayı NA değerlerimiz oluştu
                     # Bunun önünde geçmek için concat içine join komutu lazım
                     
pd.concat([df1,df2], join='inner')
# Artık kesişim elemanlarına göre birleştirme gerçekleştirdik farklı sütunları birleştirmek ZIRVA

pd.concat([df1,df2] , join = [df2.columns],ignore_index= True) # Sürümden çalışmadı?

 


# İleri Birleştirme 

df1 = pd.DataFrame({
    "köleler" : ["Bora","Berkay","Aylin","Arzu","Tunca"],
    "Departman": ["Aşçı","Kurpiyer","Öğretmen","Yazman","Kurpiyer"]})
df1

df2 = pd.DataFrame({
    "köleler" :["Bora","Berkay","Aylin","Arzu","Tunca"],
    "Başlangıç": [2012,1000,300,2000,1]})

df2

pd.merge(df1,df2) # kesişenlere göre birlşetirme yapar ancak özellikle bi sütuna göre birleştime istiyorsak

df3 = pd.merge(df1,df2, on = 'köleler')

df4 = pd.DataFrame({
    "Departman": ["Aşçı","Kurpiyer","Öğretmen","Yazman"],
    "mudur" : ["Barış","Burçak","Zeynep","Vilda"]
    })
df4

pd.merge(df3, df4, on = "Departman")




data_a = {
    'feature1': [1, 2, 3],
    'feature2': [4, 5, 6],
    'feature3': [7, 8, 9]
}

data_b = {
    'feature2': [10, 11, 12],
    'feature3': [13, 14, 15],
    'feature4': [16, 17, 18]
}

A = pd.DataFrame(data_a)
B = pd.DataFrame(data_b)

# B matrisindeki sütunları A matrisine ekleyin (eğer isimler eşleşiyorsa)
for column in B.columns:
    if column not in A.columns:
        A[column] = B[column]

# Sonuçları göster
print("A Matrisi:")
print(A)

print("\nB Matrisi:")
print(B)



