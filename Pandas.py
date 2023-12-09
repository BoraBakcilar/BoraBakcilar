

import pandas as pd 

seri = pd.Series([1,2,3,4,5,6,7])

# pandas veri tiplerinde index sayılarıyla oluşturur 

type(seri)

seri.axes
seri.dtype
seri.size
seri.ndim
seri.values


import numpy as np 

seri = pd.Series([120,11,456,321], index= ["log","r^2","t","rog"])

seri.index
seri.keys

list(seri.items())  # sözlük halinde bize sundu


# Eleman sorgulama


"reg" in seri
"log" in seri 

seri["rog"]

seri[["log","rog"]]



seri["log"] = 31 # atama işlemi
seri




