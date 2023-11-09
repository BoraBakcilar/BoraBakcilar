

####################

# GEREKLİ KÜTÜPHANELER
if (!require(shiny)) install.packages("shiny") ; library(shiny)
if (!require(dplyr)) install.packages("dplyr") ; library(dplyr)
if (!require(DT)) install.packages("DT") ; library(DT)
if (!require(tidyr)) install.packages("tidyr") ; library(tidyr)
if (!require(plotly)) install.packages("plotly") ; library(plotly)
if (!require(shinydashboard)) install.packages("shinydashboard") ; library(shinydashboard)


saymanlık_listesi <- read.xlsx("~/Desktop/saymalık_listesi.xlsx", sheet = 1)
veri <- read.xlsx("~/Desktop/hmbdat.xlsx", sheet = 1, startRow = 2)

colnames(veri)[c(13,14,15,18)] <- c("Üst.Birim.Kodu.Kadro", "İl.Adı.Kadro", "Saymanlık.Kodu.Birim.Adı.Kadro","Unvan.Kodu.Ve.Adı.Kadro")


veri$SAYMANLIK.KODU <- gsub(".*?(\\d+).*", "\\1", veri$UNVAN.KODU.VE.ADI)




veri$SAYMANLIK.KODU<- as.numeric(veri$SAYMANLIK.KODU)


# Verideki gereksiz dolu olan satırları NA yaptık "-" ve "YOK" ları daha temiz çalışmak için
unique(veri$`TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)`)
veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"][veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"] %in% c("-", "YOK")] <- NA
veri[,"AYLIKSIZ.İZİN.AÇIKLAMA"][veri[,"AYLIKSIZ.İZİN.AÇIKLAMA"] %in% c("-", "YOK")] <- NA
veri[,"AYLIKSIZ.İZİN.BAŞLANGIÇ.TARİHİ"][veri[,"AYLIKSIZ.İZİN.BAŞLANGIÇ.TARİHİ"] %in% c("-", "YOK")] <- NA
veri[,"AYLIKSIZ.İZİN.BİTİŞ.TARİHİ"][veri[,"AYLIKSIZ.İZİN.BİTİŞ.TARİHİ"] %in% c("-", "YOK")] <- NA
veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"] <- gsub("[^0-9]", "", veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"])

# Burda hata olursa veriye dönük yeni işlemler gerekir toplanması ve sanala geçilişinde.
sum(is.na(veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"]))
veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"] <- as.numeric(veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"])
sum(is.na(veri[,"TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"]))

saymanlık_listesi$SAYMANLIK.KODU <- as.numeric(saymanlık_listesi$SAYMANLIK.KODU)

# Verinin kirliliğinden dolayı ve diğer doğru yerleri bozmamak adına talep edilen bölge için yeni veri oluşturuyoruz.
# Birleştirme işlemini gerçekleştiriyoruz
veri2 <- data.frame()

# İşlemi gerçekleştiriyoruz
for (i in 1:nrow(veri)) {
  talep_saymanlik <- veri[i, "TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"]
  
  if (is.na(talep_saymanlik)) {
    birim_adi <- NA
  } else if (talep_saymanlik %in% saymanlık_listesi$SAYMANLIK.KODU) {
    birim_adi <- saymanlık_listesi$BİRİM.ADI[match(talep_saymanlik, saymanlık_listesi$SAYMANLIK.KODU)]
  } else {
    birim_adi <- "BİLİNMİYOR"
  }
  
  veri2 <- rbind(veri2, data.frame(TALEP = talep_saymanlik, BİRİM.ADI = birim_adi))
}

# Talepli verileri oluşturduk
talepli_veri <- cbind(veri,veri2)



talepli_veri <- talepli_veri %>%
  rename(Talep.Edilen.Birim.Adı = BİRİM.ADI)


veri$HİZMET.YILI[veri$HİZMET.YILI == "1 AY" | veri$HİZMET.YILI == "-" ] <- 0
veri$HİZMET.YILI <- as.numeric(veri$HİZMET.YILI)
veri$AYLIKSIZ.İZİN.AÇIKLAMA[veri$AYLIKSIZ.İZİN.AÇIKLAMA == "YOK" | veri$AYLIKSIZ.İZİN.AÇIKLAMA =="YOK " | veri$AYLIKSIZ.İZİN.AÇIKLAMA == "-"  ] <- NA


talepli_veri$HİZMET.YILI[talepli_veri$HİZMET.YILI == "1 AY" | talepli_veri$HİZMET.YILI == "-" ] <- 0
talepli_veri$HİZMET.YILI <- as.numeric(talepli_veri$HİZMET.YILI)
talepli_veri$AYLIKSIZ.İZİN.AÇIKLAMA[talepli_veri$AYLIKSIZ.İZİN.AÇIKLAMA == "YOK" | talepli_veri$AYLIKSIZ.İZİN.AÇIKLAMA =="YOK " | talepli_veri$AYLIKSIZ.İZİN.AÇIKLAMA == "-"  ] <- NA


# APP 

ui <- dashboardPage(
  dashboardHeader(title = "Kişi Sayıları ve İstatistikler"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Kişi Sayıları ve İstatistikler", tabName = "istatistikler", icon = icon("users")),
      menuItem("Tayin Talep Sorgusu", tabName = "talepListesi", icon = icon("search")),
      menuItem("Görev Tipleri", tabName = "gorevTipleri", icon = icon("search")),
      menuItem("Hizmet Yılı", tabName = "hizmetYili", icon = icon("search")),
      menuItem("Genel Sorgu", tabName = "genelsorgu", icon = icon("search")),
      menuItem("Ücretsiz İzin Sorgusu", tabName = "ucretsizIzinSorgusu", icon = icon("search")) 
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "istatistikler",
        fluidRow(
          column(width = 4,
                 selectInput("ilSecimi", "İl Seçiniz:", choices = c("Tüm İller", unique(veri$İL.ADI)))),
          column(width = 4,
                 selectInput("unvanSecimi", "Ünvan Seçiniz:", choices = c("Tüm Ünvanlar", unique(veri$UNVAN.KODU.VE.ADI)))),
          column(width = 6,
                 selectInput("yasFiltreSecimi", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı")),
        ),
        fluidRow(
          column(width = 12,
                 DTOutput("kisiSayilariTable")
          )
        ),
        fluidRow(
          column(width = 6,
                 uiOutput("ilCalisanSayisi")
          ),
          column(width = 6,
                 uiOutput("kisiSayilari")
          )
        ),
        fluidRow(
          column(width = 6,
                 uiOutput("unvanKisiSayisi")
          ),
          column(width = 6,
                 uiOutput("cinsiyetSayilari")
          )
        ),
        fluidRow(
          column(width = 6,
                 uiOutput("buyuk62Sayilari")
          )
        ),
        fluidRow(
          column(width = 12,
                 textOutput("toplamSatirSayisi")
          )
        )
      ),
      tabItem(
        tabName = "talepListesi",
        fluidPage(
          selectInput("ilSecimiTalep", "İl Seçiniz:", choices = c("Tüm İller", unique(talepli_veri$İL.ADI))),
          selectInput("yasFiltreSecimiTalep", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
          verbatimTextOutput("sayi"),
          DTOutput("datatable_output")
        )
      ),
      tabItem(
        tabName = "gorevTipleri",
        fluidPage(
          selectInput("ilSecimiGorev", "İl Seçiniz:", choices = c("Tüm İller", unique(talepli_veri$İL.ADI))),
          selectInput("gorevTipi", "Görev Tipi Seçiniz:", choices = unique(talepli_veri$TİPİ)),
          selectInput("yasFiltreSecimiGorev", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
          verbatimTextOutput("gorevSayi"),
          DTOutput("gorev_tipleri")
        )
      ),
      tabItem(
        tabName = "hizmetYili",
        fluidPage(
          selectInput("hizmetYiliSecimi", "Hizmet Yılı Seçiniz:", choices = unique(talepli_veri$HİZMET.YILI)),
          selectInput("ilSecimiHizmet", "İl Seçiniz:", choices = c("Tüm İller", unique(talepli_veri$İL.ADI))),
          selectInput("unvanSecimiHizmet", "Ünvan Seçiniz:", choices = c("Tüm Ünvanlar", unique(talepli_veri$UNVAN.KODU.VE.ADI))),
          selectInput("yasFiltreSecimiHizmet", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
          actionButton("esitYukariButon", "Seçilen Hizmet Yılına Eşit ve Daha Yukarılarını Göster"),
          DTOutput("hizmetYiliTable"),
          column(width = 12,
                 textOutput("filtrelenenKisiSayisi"))
        )
      ),
      tabItem(
        tabName = "genelsorgu",
        fluidPage(
          fluidRow(
            lapply(1:5, function(i) {
              column(
                width = 2,
                selectInput(
                  paste0("sutunSecimi_", i),
                  paste("Sütun ", i, " Seçiniz:"),
                  choices = c("Seçimsiz", colnames(veri)),
                  selected = "Seçimsiz"
                )
              )
            })
          ),
          fluidRow(
            column(width = 12, uiOutput("uniqueFilters"))
          ),
          fluidRow(
            column(width = 12, DTOutput("filteredTable")),
            column(width = 12, verbatimTextOutput("rowCount"))
          )
        )
      ),
      tabItem(
        tabName = "ucretsizIzinSorgusu",
        fluidPage(
          selectInput("izinAciklamaSecimi", "Ücretsiz İzin Açıklama Seçiniz:", choices = c("Tüm Açıklamalar", "Var", "Yok"))),
        selectInput("ilSecimiIzin", "İl Seçiniz:", choices = c("Tüm İller", unique(veri$İL.ADI))),
        selectInput("yasFiltreSecimiIzin", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
        DTOutput("ucretsizIzinTable")
      )
    )
  )
)




# SERVER

server <- function(input, output, session) {
  
  #Genel gözlem 
  selected_columns <- reactiveValues()
  
  observe({
    for (i in 1:5) {
      selected_column <- input[[paste0("sutunSecimi_", i)]]
      if (selected_column != "" && !(selected_column %in% names(selected_columns))) {
        if (selected_column == "Seçimsiz") {
          selected_columns[[selected_column]] <- NULL
        } else {
          selected_columns[[selected_column]] <- unique(veri[!is.na(veri[, selected_column]), selected_column])
        }
      }
    }
  })
  
  
  output$uniqueFilters <- renderUI({
    uniqueFilters <- lapply(1:5, function(i) {
      selected_column <- input[[paste0("sutunSecimi_", i)]]
      if (selected_column != "Seçimsiz" && !is.null(selected_columns[[selected_column]])) {
        unique_choices <- c("Tüm Değerler", selected_columns[[selected_column]])
        selectInput(
          paste0("uniqueDegerler_", i),
          paste("Sütun ", i, " İçin Unique Değer Seçiniz:"),
          choices = unique_choices
        )
      }
    })
    do.call(fluidRow, uniqueFilters)
  })
  
  output$filteredTable <- renderDT({
    filtered_data <- veri
    for (i in 1:5) {
      selected_column <- input[[paste0("sutunSecimi_", i)]]
      if (selected_column != "Seçimsiz" && !is.null(selected_columns[[selected_column]])) {
        unique_value <- input[[paste0("uniqueDegerler_", i)]]
        if (unique_value != "Tüm Değerler") {
          filtered_data <- filtered_data[!is.na(filtered_data[, selected_column]) & filtered_data[, selected_column] == unique_value, ]
        }
      }
    }
    
    output$rowCount <- renderText({
      paste("Toplam Satır Sayısı: ", nrow(filtered_data))
    })
    datatable(filtered_data,options = list(pageLength = 1000,
                                           scrollX = TRUE,
                                           scrollY = "400px",
                                           dom = 'tip',
                                           searching = TRUE,
                                           columnDefs = list(list(width = '80px', targets = "_all"))))
  })
  
  # Seçilen il ve ünvana göre filtreleme işlemleri
  secilenIlUnvan <- reactive({
    filtreliVeri <- veri
    if (!is.null(input$ilSecimi) && input$ilSecimi != "Tüm İller") {
      filtreliVeri <- filtreliVeri %>% filter(İL.ADI == input$ilSecimi)
    }
    if (!is.null(input$unvanSecimi) && input$unvanSecimi != "Tüm Ünvanlar") {
      filtreliVeri <- filtreliVeri %>% filter(UNVAN.KODU.VE.ADI == input$unvanSecimi)
    }
    return(filtreliVeri)
  })
  
  secilenİl <- reactive({
    filtreliVeri <- veri
    if (!is.null(input$ilSecimi) && input$ilSecimi != "Tüm İller") {
      filtreliVeri <- filtreliVeri %>% filter(İL.ADI == input$ilSecimi)
    }
    return(filtreliVeri)
  })
  
  secilenVeri <- reactive({
    filtreliVeri <- veri
    if (!is.null(input$ilSecimi) && input$ilSecimi != "Tüm İller") {
      filtreliVeri <- filtreliVeri %>% filter(İL.ADI == input$ilSecimi)
    }
    if (!is.null(input$unvanSecimi) && input$unvanSecimi != "Tüm Ünvanlar") {
      filtreliVeri <- filtreliVeri %>% filter(UNVAN.KODU.VE.ADI == input$unvanSecimi)
    }
    return(filtreliVeri)
  })
  
  # İldeki toplam çalışan sayısı
  output$ilCalisanSayisi <- renderPrint({
    filtreliData <- secilenİl()
    if (!is.null(input$ilSecimi) && input$ilSecimi != "Tüm İller") {
      ilCalisanSayisi <- length(filtreliData$UNVAN.KODU.VE.ADI)
      paste("Seçilen İldeki Toplam Çalışan Sayısı:", ilCalisanSayisi)
    } else {
      "Lütfen bir il seçin."
    }
  })
  
  # Kişi sayılarını görüntüleme
  output$kisiSayilari <- renderPrint({
    filtreliData <- secilenVeri()
    paste("Seçilen il ve ünvandaki Kişi Sayısı:", length(filtreliData$UNVAN.KODU.VE.ADI))
  })
  
  # 62 yaşından büyük kişi sayılarını görüntüleme
  output$buyuk62Sayilari <- renderPrint({
    filtreliData <- secilenVeri()
    today <- Sys.Date()
    buyuk62Data <- filtreliData %>%
      mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
      mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
      filter(Yas > 62)
    paste("62 Yaşından Büyük Kişi Sayısı:", nrow(buyuk62Data))
  })
  unique(veri$CİNSİYETİ)
  output$cinsiyetSayilari <- renderPrint({
    filtreliData <- secilenVeri()
    
    kadınSayisi <- sum(filtreliData$CİNSİYETİ %in% c("Kadın", "KADIN", "BAYAN", "KADIN "))
    erkekSayisi <- sum(filtreliData$CİNSİYETİ %in% c("ERKEK", "Erkek", "Erkek  ", "YAPTI"))
    
    paste("Seçilen ünvan ve ildeki kadın sayısı:", kadınSayisi,
          "Seçilen ünvan ve ildeki erkek sayısı:", erkekSayisi)
  })
  # Ünvan toplamı
  output$unvanKisiSayisi <- renderPrint({
    filtreliData <- secilenIlUnvan()
    unvanKisiSayisi <- length(filtreliData$UNVAN.KODU.VE.ADI)
    paste("Seçilen ünvandaki toplam kişi sayısı:", unvanKisiSayisi)
  })
  
  
  # Tayin Talep Sorgusu Sayfası
  filtered_data_talep <- reactive({
    if (input$ilSecimiTalep == "Tüm İller") {
      talepli_veri %>% 
        filter(!is.na(TALEP) & grepl("^\\d+$", TALEP))
    } else {
      talepli_veri %>% 
        filter(!is.na(TALEP) & grepl("^\\d+$", TALEP) & İL.ADI == input$ilSecimiTalep)
    }
  })
  
  filtered_data_talep_with_age_filter <- reactive({
    if (input$yasFiltreSecimiTalep == "açık") {
      today <- Sys.Date()
      buyuk62Data <- filtered_data_talep() %>%
        mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
        filter(Yas >= 62)
      return(buyuk62Data)
    } else {
      return(filtered_data_talep())
    }
  })
  
  output$datatable_output <- renderDT({
    datatable(filtered_data_talep_with_age_filter(), options = list(pageLength = 1000,
                                                                    scrollX = TRUE,
                                                                    scrollY = "400px",
                                                                    dom = 'tip',
                                                                    searching = TRUE,
                                                                    columnDefs = list(list(width = '80px', targets = "_all"))))
  })
  
  
  # Görev Tipleri Sayfası
  filtered_data_gorev <- reactive({
    if (!is.null(input$ilSecimiGorev) && !is.null(input$gorevTipi)) {
      filtered_data <- talepli_veri
      
      if (input$ilSecimiGorev != "Tüm İller") {
        filtered_data <- filtered_data %>%
          filter(İL.ADI == input$ilSecimiGorev)
      }
      
      if (input$gorevTipi != "Tüm Görev Tipleri") {
        filtered_data <- filtered_data %>%
          filter(TİPİ == input$gorevTipi)
      }
      
      return(filtered_data)
    }
  })
  
  filtered_data_gorev_with_age_filter <- reactive({
    if (input$yasFiltreSecimiGorev == "açık") {
      today <- Sys.Date()
      buyuk62Data <- filtered_data_gorev() %>%
        mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
        filter(Yas > 62)
      return(buyuk62Data)
    } else {
      return(filtered_data_gorev())
    }
  })
  
  output$gorev_tipleri <- renderDT({
    datatable(filtered_data_gorev_with_age_filter(), options = list(pageLength = 1000,
                                                                    scrollX = TRUE,
                                                                    scrollY = "400px",
                                                                    dom = 'tip',
                                                                    searching = TRUE,
                                                                    columnDefs = list(list(width = '80px', targets = "_all"))))
  })
  
  
  # Hizmet Yılı Sayfası
  hizmet_yili_filtered_data <- eventReactive(input$esitYukariButon, {
    filtered_data_hizmet <- talepli_veri
    if (!is.null(input$hizmetYiliSecimi) && !is.na(input$hizmetYiliSecimi)) {
      filtered_data_hizmet <- filtered_data_hizmet %>%
        filter(HİZMET.YILI >= as.numeric(input$hizmetYiliSecimi))
    }
    if (input$ilSecimiHizmet != "Tüm İller") {
      filtered_data_hizmet <- filtered_data_hizmet %>%
        filter(İL.ADI == input$ilSecimiHizmet)
    }
    if (input$unvanSecimiHizmet != "Tüm Ünvanlar") {
      filtered_data_hizmet <- filtered_data_hizmet %>%
        filter(UNVAN.KODU.VE.ADI == input$unvanSecimiHizmet)
    }
    return(filtered_data_hizmet)
  })
  
  hizmet_yili_filtered_data_with_age_filter <- reactive({
    if (input$yasFiltreSecimiHizmet == "açık") {
      today <- Sys.Date()
      buyuk62Data <- hizmet_yili_filtered_data() %>%
        mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
        filter(Yas > 62)
      return(buyuk62Data)
    } else {
      return(hizmet_yili_filtered_data())
    }
  })
  
  output$hizmetYiliTable <- renderDT({
    datatable(hizmet_yili_filtered_data_with_age_filter(), options = list(pageLength = 1000,
                                                                          scrollX = TRUE,
                                                                          scrollY = "400px",
                                                                          dom = 'tip',
                                                                          searching = TRUE,
                                                                          columnDefs = list(list(width = '80px', targets = "_all"))))
  })
  
  
  # Kişi sayıları ve istatistikler sayfasında bana datatable oluştur
  output$kisiSayilariTable <- renderDT({
    filtreliData <- secilenVeri()
    
    if (input$yasFiltreSecimi == "açık") {
      today <- Sys.Date()
      buyuk62Data <- filtreliData %>%
        mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
        filter(Yas >= 62)
      
      datatable(buyuk62Data, options = list(pageLength = 1000,
                                            scrollX = TRUE,
                                            scrollY = "400px",
                                            dom = 'tip',
                                            searching = TRUE,
                                            columnDefs = list(list(width = '80px', targets = "_all"))))
    } else {
      datatable(filtreliData, options = list(pageLength = 1000,
                                             scrollX = TRUE,
                                             scrollY = "400px",
                                             dom = 'tip',
                                             searching = TRUE,
                                             columnDefs = list(list(width = '80px', targets = "_all"))))
    }
  })
  
  # Ücretsiz İzin Sorgusu Sayfası
  output$ucretsizIzinTable <- renderDT({
    filtreliData <- veri
    
    if (input$izinAciklamaSecimi == "Var") {
      filtreliData <- filtreliData[!is.na(filtreliData$AYLIKSIZ.İZİN.AÇIKLAMA) & filtreliData$AYLIKSIZ.İZİN.AÇIKLAMA != "", ]
    } else if (input$izinAciklamaSecimi == "Yok") {
      filtreliData <- filtreliData[is.na(filtreliData$AYLIKSIZ.İZİN.AÇIKLAMA) | filtreliData$AYLIKSIZ.İZİN.AÇIKLAMA == "", ]
    }
    
    if (input$ilSecimiIzin != "Tüm İller") {
      filtreliData <- filtreliData %>% filter(İL.ADI == input$ilSecimiIzin)
    }
    
    if (input$yasFiltreSecimiIzin == "açık") {
      today <- Sys.Date()
      buyuk62Data <- filtreliData %>%
        mutate(DOĞUM.TARİHİ = as.Date(DOĞUM.TARİHİ, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, DOĞUM.TARİHİ, units = "days")) / 365.25) %>%
        filter(Yas > 62)
      datatable(buyuk62Data, options = list(pageLength = 1000,
                                            scrollX = TRUE,
                                            scrollY = "400px",
                                            dom = 'tip',
                                            searching = TRUE,
                                            columnDefs = list(list(width = '80px', targets = "_all"))))
    } else {
      datatable(filtreliData, options = list(pageLength = 1000,
                                             scrollX = TRUE,
                                             scrollY = "400px",
                                             dom = 'tip',
                                             searching = TRUE,
                                             columnDefs = list(list(width = '80px', targets = "_all"))))
    }
  })
  
}



shinyApp(ui, server)

