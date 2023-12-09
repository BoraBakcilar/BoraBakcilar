# Map & Filter  & reduce 


liste = [1,2,3,4,5]

for i in liste :
    print(i+10)

liste2 =list(map(lambda x : x + 10, liste)) # en baştaki liste görmek için kullandık

# Bu işlemler vektörel olmakta map fonksiyonu bu sağlar
 

# FİLTER
# Filter bir fonksiyon ve iteratif bir nesne altında çalışır
# başka bir iteratif nesne oluşturur ve aranan değeri o oluşturulan iteratif nesne içinde arar

liste3 = [1,2,3,4,5,6,7,8,9,10]

cift_sayilar = list(filter(lambda x : x % 2 == 0, liste3))

# Değerler ile bir işlem yapmadı sadece aradığımız koşulu bize verdi


# Reduce

from functools import reduce

liste4 = [1,2,3,4]

reduce(lambda a,b: a+b, liste4 )
# Reduce burda otomatik olarak girdiğimiz işlemi yaptı bütün değerleri topladı 1+2+3+4

reduce(lambda a,b : a*b, liste4) # bütün değerleri çarptı 



