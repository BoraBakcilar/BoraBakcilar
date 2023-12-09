#Fonksiyon okur yazarlığı 

# =============================================================================
# bir fonksiyon tanımlamak için "def" kullanılır 
# =============================================================================

def kare_al(x) :
    print(x**2)
   
    
kare_al(5)

#Bilgi notu ile çıktı almak 

def kare_al2(x):
    print( "girilen sayımız:" ,x, "\n"
        "girilen sayının karesi:", x**2)
    
kare_al2(4)    


# İki argümanlı fonksiyon 

def carpma(x,y) :
    a = (x**2) * y**(-3/5)
    return a  # Return kullanırken () içinde almaya gerek yok ama alınabilirde 
    
    
carpma(5, 3)

#Argümanların sırası bilinmesede o argümanı atıyarak fonksiyon içinde işlem yapılabilir 
carpma(y = 5, x = 3) # x ve y nin yeri kasıtlı değişti 


# =============================================================================
# Local ve Global değişkenler 
# Local değişkenler : fonksiyon(def) içindeki değişkenlerdir ve fonksiyon dışına etki etmezler 
# Global değişkenler: bizim enviromentimizde bulunan atanmışlardır ve bunlarda fonksiyon(def) içine 
# etki etmezler 
# 
# =============================================================================




# Local etki alanından Global etki alanını değiştirmek

x = []

def eleman_ekleme(y) :
    x.append(y)
    return("eklenen ifade", y,"\n",
           "yeni liste :", x)

eleman_ekleme("ali")

x

#True False sorguları 

hudut = " edirne"
hudut == "kars"

sayı = 100000
sayı == 12345 # Çift eşittir(==) sorgu oluşturur

#İf

sinir = 5000
gelir = 40000

if gelir < sinir :
    print("Gelir sınırdan küçük")
    gelir = gelir*2


    
# Else


if gelir < sinir :
    gelir = gelir*2
else : 
    gelir = gelir / 2  


# Elif 2 den fazla durumlar için

gelir1 = 5000
gelir2 = 6000
gelir3 = 3500
sınır = 5000

if gelir1 > sinir : 
    print("tebrikler başardınız")
elif gelir1 < sinir : 
    print("ceza aldınız")
else :
    print("takibe devam") 


# Mini uygulama

sınır = (10**4)*5
magza_adi = input("mağza adını giriniz:")
gelir = int( input("Geliri giriniz:"))

if gelir > sınır :
    print("Promosyon kazandın ",magza_adi,"hadi iyisin")
elif gelir < sınır : 
    print("UYARI!")
else:
    print("takibe devamke")
    


# For loop :)

ogrenciler = ["ali","veli","ayse","beren"]

for i in ogrenciler:
     print(i)
     
print(ogrenciler[0:4])

# For döngüsü örnek 
maaslar = [1000,2000,3000,4000,5000]

for i in range(len(maaslar)): 
    if 4000 > maaslar[i]:
        maaslar[i] += 1500
    elif maaslar[i] > 4000:
        maaslar[i] += 750
    print(maaslar[i])
        
# daha basiti 
maaslar = [1000,2000,3000,4000,5000]

for i in maaslar: 
    if 4000 > i:
        i += 1500
    elif i > 4000:
        i += 750
    print(i)

# R gibi değil burda i in veri dediğimizde direkt i o elemanı temsil ediyor 
# bundan dolayı R da veri[i] derken burda i dememiz yetiyor 



































