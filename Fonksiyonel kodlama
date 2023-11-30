# Pythonda Fonksiyonel Kodlama

#Fonksiyonlar dilinin baş tacıdır 
# Birinci sınıf nesnelerdir 
# Yan etkisiz fonksiyonlardır (stateless, girdi-cikti)
# Yuksek seviye fonksiyonlardır
# Vektörel operasyonlardır


# Yan etkisiz fonksiyonlar (Pure Function)

# Ornek1 : Yan etki

A = 9

def impure_sum(b):
    return(A+b)

impure_sum(5)

def pure_sum(a,b):
    return(a+b)


pure_sum(3, 7)

# Dışarda (globalde  var olan) değişken bizim fonksiyon(def) imizin çıktısını sürekli etkiliyebilir
# Pure bu konuda daha sağlıklı çünkü sadece girdilerimize bağlı olur 

# Örnek2

#FP 

def read(filenames):
    with open(filenames, "r") as f:
        return[line for line in f]
    
def count(lines):
    return(len(lines))

example_line = read("deneme.txt")
lines_count= count(example_line)
lines_count


# Nameless functions

def old_sum(a,b):
    return a+b

old_sum(3, 4)


new_sum = lambda a,b : a+b # R daki pipe functionlar gibi
new_sum(3,2)


sirasiz_list = [("b",3),('a',8),("d",12),("c",1)]
sirasiz_list

sorted(sirasiz_list, key = lambda x : x[1])
































