#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 23:38:45 2023

@author: borabakcilar
"""

###                                         EDA                                             ###
import numpy as np 
import seaborn as sns 
import pandas as pd

df = sns.load_dataset("planets")
df = pd.DataFrame(df)

#Hangi sütunlarda na var 
df.isnull().any()


# Hangi değişkende kaç tane olduğunu görmek istediğimizde 

df.isnull().sum()  #isna() de aynı anlama gelmekte 
df.fillna(0,inplace = True)

# Veri setini tekrardan güncellemek gerekebilir sonraki işlemler için 

df.method.value_counts() # bütün farklılıkları sayısı ile verir 
df.method.value_counts().count() # farklı kaçtane var 

df.method.value_counts().plot.barh();

### Dağılım grafikleri 
# --- Boş işler anlattı --- 


###
### ordinal tanımlama
###

from pandas.api.types import CategoricalDtype
import matplotlib as mth

diamonds = sns.load_dataset("diamonds")
df = diamonds.copy()

df.info
df.describe().T
df.cut.head(1)

df.cut.value_counts()

df.cut = df.cut.astype(CategoricalDtype(ordered=True))
df.cut
# Yanlış kategorize ettiği için biz el ile kategorik değişkenleri giricez 

cut_kategori = ['Fair',"Good","Very Good","Premium","Ideal"]

df.cut = df.cut.astype(CategoricalDtype(cut_kategori,ordered=True))
df.cut.head(1)
df.cut.value_counts()
# Thats all :)



###
### Bar plot (Severiz :)
###

df["cut"].value_counts().plot.barh();

sns.barplot(x = df.cut, y = df.cut.index, data = df )



###
### Çaprazlamalar 
###


diamonds = sns.load_dataset("diamonds")
df = diamonds.copy()
cut_kategori = ['Fair',"Good","Very Good","Premium","Ideal"]
df.cut = df.cut.astype(CategoricalDtype(cut_kategori,ordered=True))
df.cut.head(1)
df.cut.value_counts()


sns.distplot(df.price, kde = False,bins=100) # bins komutu kaç kutu olcağını söyler 

sns.kdeplot(df.price, shade = True);



(sns.FacetGrid(df,hue="cut",height=5,xlim=(0,10000))).map(sns.kdeplot,"price",shade = True);


# hue argümanı neye göre boyutlandırcağını verir 
sns.catplot(x = "cut",y="price",hue="color",data = df) ;
sns.catplot(x = "cut",y="price",hue="color",kind="point",data = df) ; #kind argümanı grafiği etkiliyor



###
### Box plot 
###

tips = sns.load_dataset("tips")
df = tips.copy()
df

df.describe().T
df["sex"].value_counts()
df["smoker"].value_counts()
df["day"].value_counts()
df["time"].value_counts()


sns.boxplot(x = df["total_bill"]);
sns.boxenplot(x = df["total_bill"], orient="v"); # orient = "v" dikey basması gerekirdi ama yapmıyor?

# boxenplot daha kademeli bir görselleştirme yapıyor 


# box plotta çaprazlama 

sns.boxplot(x = "day",y="total_bill",data=df);

sns.boxplot(x = "time",y="total_bill",data=df);

sns.boxplot(x= "day",y="total_bill",hue="sex",data=df); # sex kategorisinde günlük ödenen hesaplar bunu 
# hue sayesinde yapıoz hue sayesinde kategori sayımızı arttırabiliyoruz 

sns.catplot(x = "total_bill",kind="violin",data = df) ;
sns.catplot(x = "total_bill",y="day",hue="sex",kind="violin",data = df) ;


# y 2. argüman hue 3. argüman için kullanılıyor




###
### Korelasyon grafiği 
###

sns.scatterplot(x = "total_bill",y="tip",data = df);

sns.scatterplot(x = "total_bill",y="tip",hue = "sex",data = df);
# hue argümanının kategorik olması scatterplotta daha iyi olur 


sns.scatterplot(x = "total_bill",y="tip",hue = "day",style = "time",data = df);
# Daha fazla faktörle gözlemleme imkanı veriyor :)


sns.scatterplot(x = "total_bill",y="tip",hue = "day",style = "time",size = "smoker",data = df);
# size argümanı ile baloncuk grafiğine benzer işler yaptık burda size ile boyutlarına göre yorumlıyabiliyoruz 
# size sayesinde başka bir değişken daha ekliyebildik bu kelimede olabilir, sayıda farkmaz (sayı kullancaksak aralık kullanmak daha iyi olur)
# titanic veri setinde yaptığımız gibi 0-18, 18-90 yaş aralığı gibi argümanlarla yapabiliriz.



###
### Doğrusal ilişkinin gösterilmesi (SLR ve MLR :)
###

import seaborn as sns 
import matplotlib.pyplot as plt

# lmplot lineer model grafiği 

sns.lmplot(x = "total_bill",y= "tip", data = df) ;

sns.lmplot(x = "total_bill",y= "tip",hue ="smoker", data = df) ;

#time değişkenine göre 2 corelasyon grafiği çıkarttık
sns.lmplot(x = "total_bill",y= "tip",hue ="smoker",col="sex", data = df) ;
sns.lmplot(x = "total_bill",y= "tip",hue ="smoker",col="size", data = df) ;
sns.lmplot(x = "total_bill",y= "tip",hue ="smoker",col="time", data = df) ;
# col argümanı veriyinin değişkenlerini aynı matris gibi seçilen değişkenin içindeki verileri 
# farklı sütunlardaymış gibi değerlendirip görselleştirme işlemini yapıyor

sns.lmplot(x = "total_bill",y= "tip",hue ="smoker",col="time",row="sex" ,data = df) ;
# row ise satırlar şeklinde ifade ediyor 


###
### Scatter Plot Matrisi 
###

iris = sns.load_dataset("iris")
df = iris.copy()
df.head()
df.dtypes
df.shape
df.describe().T

# korelasyon matrixinin görselleştirilmiş hali :) (467)
sns.pairplot(df) ; 

# hue gene hayat kurtarıyor :)
sns.pairplot(df,hue = "species") ;

# işaretleri değiştirmek için markers ın içeriğindeki harfler bilinmeli ama bunlar yeterli şimdilik 
sns.pairplot(df,hue = "species", markers = ["o","s","p"]) ;

# yeni kind = "reg" regresyon modeli 
sns.pairplot(df, kind="reg") ;
# kind hepsine uygulanır !!!





###
### Isı Haritası
###

flight = sns.load_dataset("flights")
df = flight.copy()

# En başta pivot table haline getirmek gerekiyor
df = df.pivot("month","year","passengers")
sns.heatmap(df);

# Hücrelerdeki sayılar annot = true ve fmt = "d" argümanları sayesinde
sns.heatmap(df, annot=True,fmt="d");

#Hücreler daha iyi okunabilsin diye aralıklarını artırma işlemi linewidths
sns.heatmap(df, annot=True,fmt="d", linewidths= .1);



### Çizgi grafiği
### 
### daha çok makinelerin ürettiği verilerde zor olan veri setlerinde kullanılan bir grafik yöntemi
### mekanik veri setlerinde kullanımı daha doğru olur 

frm = sns.load_dataset("fmri")
df = frm.copy()
df.groupby("timepoint")["signal"].count()  #çıktıya göre her timepointte eşit sinyal algılanmış 

df.groupby("signal").count()
df.groupby("timepoint")["signal"].describe()


sns.lineplot(x = "timepoint", y = "signal",data = df);
# açık mavi noktalar güven aralığı 


sns.lineplot(x = "timepoint", y = "signal",hue = "event",style = "event",
             markers = True ,dashes = False,data = df);

### Basit zaman serisi 
###
###
!pip install pandas_datareader # bir kütüphaneyi indirmek için böyle yapıoz 
import pandas_datareader as pr 
!pip install yfinance
import yfinance as yf

# Define the stock symbol and date range
stock_symbol = "AAPL"
start_date = "2016-01-01"
end_date = "2019-08-11"

# Fetch historical stock data
df = yf.download(stock_symbol, start=start_date, end=end_date)

# Print the first few rows of the DataFrame
print(df.head())
df.shape

kapanis = df.Close
kapanis

kapanis.plot() ; 

# Burda indexler tarih olduğu için sorun yok ancak eğer sorunlu olsaydı bu durum şöyle düzenlerdik:
    kapanis.index = pd.DatetimeIndex(kapanis.index)
kapanis.head()





