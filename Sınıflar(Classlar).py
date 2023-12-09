# Nesne yönelimli Programlama

# Sınıflar: benzer özellikler, ortak gayeler taşıyan, içerisinde 
# method ve değişkenler olan yapılardır. 

 class Veribilimci() :
     print("Bu bir sınıftır")



# Sınıf özellikleri (Class atributes)

class Veribilimci():
    bolum = ""
    sql = "Evet"
    deneyim_yili = 0
    bildigi_diller = []
    
Veribilimci.bolum
Veribilimci.sql
Veribilimci.deneyim_yili

# Sınıfların özelliklerini değiştirmek 

Veribilimci.sql = "Hayır" # Sql değişti.

# Sınıf örneklendirmesi (İnstantiation)

ali = Veribilimci()
ali.sql

ali.bildigi_diller.append("python")

veli = Veribilimci()
veli.sql
veli.bildigi_diller #Yukarda yapılan işlem bütün sınıfa geçirdi 
# Velinin python bildiğini söylemedik aşağıda bu sorunu çözüyoruz.

# Örnek özellikleri 

# Bu sorunu çözmek için:
class Veribilimci():
    def __init__ (self):
        self.bildigi_diller = [] 


# Burda yapılan işlem sayesinde classa sahip olan herkesin özellikleri farklı girilebilir kılıncak 
# __init__ ve (self) sayesinde 

ali = Veribilimci()
veli = Veribilimci()
ali.bildigi_diller.append("python")
veli.bildigi_diller
veli.bildigi_diller.append("R")
veli.bildigi_diller
ali.bildigi_diller
# Bu sayede bütün koda eklenmedi ve veri girme işi kolaylaştı 
# Sınıflar için yapılan işlemler bütün sınıfı etkiler bundan dolayı self init kullanmak gerekir


class Veribilimci2() : 
    def __init__(self):
        self.bildigi_diller = []
        self.bolum = ""
        self.deneyim_yili = int()
        
ali2 = Veribilimci2()
ali2.deneyim_yili = 3
ali2.deneyim_yili
ali2.bolum = "Statistic"
ali2.bolum

veli2 = Veribilimci2()
veli2.bolum
veli2.bolum = "CENG"


# Örnek medhodları: Bu bölümde classlar içinde işlem yapma vb gibi işler ile uğraşıcaz.
# Örnekler üstünde çalışan fonksiyonlar yapıcaz

class VeriBilimciler() :
    calısanlar = []
    def __init__(self):
        self.bolum = ""
        self.diller = []
        self.maas = int()
        self.deneyim_yili = int()
    def dil_ekle (self, yeni_dil):
        self.diller.append(yeni_dil)
        
ali = VeriBilimciler()
ali.maas = 5000
ali.diller 
ali.bolum

veli = VeriBilimciler()
veli.diller
veli.maas
veli.bolum

VeriBilimciler.dil_ekle("R") # Direkt classa yapısı bozulmaz olduğundan işlem hata verdi
ali.dil_ekle("R")
ali.diller
# Aslında burda yapılan şey elle = koymak yerine bunu bir fonksiyon olarak yazmak oldu 

veli.dil_ekle("Python")
veli.diller


# Miras Yapıları (inheritance)

class Employees():
     def __int__ (self):
         self.First_name = ""
         self.Last_name = ""
         self.Address  = ""
         
class Data_scientists(Employees):
     def __int__ (self):
        self.Programing_Lan = []
    
class Marketing(Employees):
     def __int__ (self):
        self.StoryTelling = []
        
ali = Data_scientists()
ali.Programing_Lan = "R"        
ali.Programing_Lan
ali.First_name = "ali"
ali.First_name
ali
ali.Last_name = "caka"
ali.Address = "istanbul kadıkoy"
ali.Address

# Dikkatli bakınca Data_scientist ve marketing içine Employees classı eklendi 
# Bu sayede Employees classında dahil olan first name last name vs yi bütün classlara 
# Uygulamak zorunda kalmadık ve kodumuzu aşırı kısaltmış olduk.

Data_scientists.









































