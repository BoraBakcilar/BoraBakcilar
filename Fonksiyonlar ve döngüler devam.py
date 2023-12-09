def kare_al(x):
    x = x**2 
    print(x)
    
kare_al(50)

maaslar = [1000,2000,3000,4000,5000]

for i in maaslar:
    if i <= 4000:
        i += (i *20 / 100) 
    elif i > 4000:
        i += (i*25/100)
    print("yeni maas",i)
    
def zam(x): 
    if x <= 4000:
        print((x*15/100)+x)
    elif x > 4000 :
       print((x*30/100)+x)
       
   
for i in maaslar : 
    zam(i)
    

#Break ve continue

maaslar = [8000,2000,6000,4000,5000,9000,1000,7500,3200,3000,2100]
maaslar.sort()
maaslar

# 3000 değerine geldiğinde durdu
for i in maaslar: 
    if i == 3000 :
        print("break")
        break
    print(i)
    


# verimizde 2000 var ancak continue dediğimizde o değeri atladı     
for i in maaslar: 
    if i == 2000:
        continue
    print(i)
    

# While : bu şart sağlandığı olduğu sürece  

sayi = 1
while sayi < 10 : 
    sayi += 1
    print(sayi)