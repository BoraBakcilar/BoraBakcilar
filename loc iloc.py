#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 26 15:26:13 2023

@author: borabakcilar
"""

# Gözlem ve değişken seçme : loc & iloc

import numpy as np
import pandas as pd 
import random

m = np.random.randint(1,30, size= (10,3))
df = pd.DataFrame(m, columns=["var1","var2","var3"])
df


## Loc: tanımlandığı şekli ile seçim yapmak için kullanılır 

df.loc[0:3]


## iloc: alışık olduğumuz şekilde indekseleme yapar.

df.iloc[0:3,1:2]


# Koşullu eleman işlemleri 

df["var1"][0:4]

# df[0:2]["var1","var2"] Bu tarz bir yazım çalışmaz fancy yapmamız lazım 
df[0:2][["var1","var2"]] # thats all

df[df.var1 >= 22]

df[df.var1 >= 22]["var1"]

df[df.var1 >= 22][["var1","var2"]] # fancy ile 2 ve fazla çekim


df[(df.var1 >15) & (df.var3 <5) ]



































