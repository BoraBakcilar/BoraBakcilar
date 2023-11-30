

####################

# GEREKLİ KÜTÜPHANELER
if (!require(shiny)) install.packages("shiny") ; library(shiny)
if (!require(dplyr)) install.packages("dplyr") ; library(dplyr)
if (!require(DT)) install.packages("DT") ; library(DT)
if (!require(tidyr)) install.packages("tidyr") ; library(tidyr)
if (!require(plotly)) install.packages("plotly") ; library(plotly)
if (!require(shinydashboard)) install.packages("shinydashboard") ; library(shinydashboard)


sl <- read.xlsx("~/Desktop/-.xlsx", sheet = 1)
veri <- read.xlsx("~/Desktop/-.xlsx", sheet = 1, startRow = 2)

colnames(veri)[c(13,14,15,18)] <- c("a", "b", "c","d")


veri$? <- gsub(".*?(\\d+).*", "\\1", veri$?)




veri$?<- as.numeric(veri$?)


# Verideki gereksiz dolu olan satırları NA yaptık "-" ve "YOK" ları daha temiz çalışmak için
unique(veri$`T?`)
veri[,"T?"][veri[,"?"] %in% c("-", "YOK")] <- NA
veri[,"?"][veri[,"?"] %in% c("-", "YOK")] <- NA
veri[,"?"][veri[,"?"] %in% c("-", "YOK")] <- NA
veri[,"data$colname"][veri[,"data$colname"] %in% c("-", "YOK")] <- NA
veri[,"data$colname(data$colname)"] <- gsub("[^0-9]", "", veri[,"data$colname"])

# Burda hata olursa veriye dönük yeni işlemler gerekir toplanması ve sanala geçilişinde.
sum(is.na(veri[,"data$colname"]))
veri[,"data$colname"] <- as.numeric(veri[,"data$colname"])
sum(is.na(veri[,"data$colname"]))

data <- as.numeric(data$colname)

# Verinin kirliliğinden dolayı ve diğer doğru yerleri bozmamak adına talep edilen bölge için yeni veri oluşturuyoruz.
# Birleştirme işlemini gerçekleştiriyoruz
veri2 <- data.frame()

# İşlemi gerçekleştiriyoruz
for (i in 1:nrow(veri)) {
  data <- veri[i, "TALEP.EDİLEN.SAYMANLIK.KODU.(Görev.yeri.değişikliği.talebi.var.ise)"]
  
  if (is.na(data)) {
    data <- NA
  } else if (data %in% data$data) {
    birim_adi <- data$data, data$data)]
  } else {
    birim_adi <- "BİLİNMİYOR"
  }
  
  veri2 <- rbind(veri2, data.frame(TALEP = data, BİRİM.ADI = data))
}

# Talepli verileri oluşturduk
talepli_veri <- cbind(veri,veri2)



talepli_veri <- talepli_veri %>%
  rename(data = data)


veri$data[veri$data == "1 AY" | veri$data == "-" ] <- 0
veri$data <- as.numeric(veri$data)
veri$data[veri$data == "YOK" | veri$data =="YOK " | veri$data == "-"  ] <- NA


talepli_veri$data[talepli_veri$data == "1 AY" | talepli_veri$data == "-" ] <- 0
talepli_veri$data <- as.numeric(talepli_veri$data)
talepli_veri$data[talepli_veri$data == "YOK" | talepli_veri$data =="YOK " | talepli_veri$data == "-"  ] <- NA


# APP 

ui <- dashboardPage(
  dashboardHeader(title = "Kişi Sayıları ve İstatistikler"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Kişi Sayıları ve İstatistikler", tabName = "istatistikler", icon = icon("users")),
      menuItem("Tayin Talep Sorgusu", tabName = "data", icon = icon("search")),
      menuItem("data", tabName = "gorevTipleri", icon = icon("search")),
      menuItem("Hizmet Yılı", tabName = "data", icon = icon("search")),
      menuItem("Genel Sorgu", tabName = "genelsorgu", icon = icon("search")),
      menuItem("data", tabName = "data", icon = icon("search")) 
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
        tabName = "data",
        fluidPage(
          selectInput("data", "İl data:", choices = c("Tüm İller", unique(talepli_veri$İL.ADI))),
          selectInput("data", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
          verbatimTextOutput("sayi"),
          DTOutput("datatable_output")
        )
      ),
      tabItem(
        tabName = "gorevTipleri",
        fluidPage(
          selectInput("ilSecimiGorev", "İl Seçiniz:", choices = c("Tüm İller", unique(talepli_veri$İL.ADI))),
          selectInput("gorevTipi", "Görev Tipi Seçiniz:", choices = unique(talepli_veri$TİPİ)),
          selectInput("data", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
          verbatimTextOutput("gorevSayi"),
          DTOutput("gorev_tipleri")
        )
      ),
      tabItem(
        tabName = "hizmetYili",
        fluidPage(
          selectInput("data", "Hizmet Yılı Seçiniz:", choices = unique(talepli_veri$HİZMET.YILI)),
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
          selectInput("data", "Ücretsiz İzin Açıklama Seçiniz:", choices = c("Tüm Açıklamalar", "Var", "Yok"))),
        selectInput("ilSecimiIzin", "İl Seçiniz:", choices = c("Tüm İller", unique(veri$İL.ADI))),
        selectInput("data", "62 Yaş ve Üstü Filtreleme:", choices = c("açık", "kapalı"), selected = "kapalı"),
        DTOutput("data")
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
    if (!is.null(input$data) && input$data != "Tüm Ünvanlar") {
      filtreliVeri <- filtreliVeri %>% filter(data == input$data)
    }
    return(filtreliVeri)
  })
  
  # İldeki toplam çalışan sayısı
  output$ilCalisanSayisi <- renderPrint({
    filtreliData <- secilenİl()
    if (!is.null(input$data) && input$ilSecimi != "Tüm İller") {
      ilCalisanSayisi <- length(filtreliData$data)
      paste("Seçilen İldeki Toplam Çalışan Sayısı:", ilCalisanSayisi)
    } else {
      "Lütfen bir il seçin."
    }
  })
  
  # Kişi sayılarını görüntüleme
  output$kisiSayilari <- renderPrint({
    filtreliData <- secilenVeri()
    paste("Seçilen il ve ünvandaki Kişi Sayısı:", length(filtreliData$data))
  })
  
  # 62 yaşından büyük kişi sayılarını görüntüleme
  output$buyuk62Sayilari <- renderPrint({
    filtreliData <- secilenVeri()
    today <- Sys.Date()
    buyuk62Data <- filtreliData %>%
      mutate(data = as.Date(data, format = "%d.%m.%Y")) %>%
      mutate(Yas = as.numeric(difftime(today, data, units = "days")) / 365.25) %>%
      filter(Yas > 62)
    paste("62 Yaşından Büyük Kişi Sayısı:", nrow(buyuk62Data))
  })
  unique(veri$CİNSİYETİ)
  output$cinsiyetSayilari <- renderPrint({
    filtreliData <- secilenVeri()
    
    kadınSayisi <- sum(filtreliData$data %in% c("Kadın", "KADIN", "BAYAN", "KADIN "))
    erkekSayisi <- sum(filtreliData$data %in% c("ERKEK", "Erkek", "Erkek  ", "YAPTI"))
    
    paste("Seçilen ünvan ve ildeki kadın sayısı:", data,
          "Seçilen ünvan ve ildeki erkek sayısı:", data)
  })
  # Ünvan toplamı
  output$data <- renderPrint({
    filtreliData <- secilenIlUnvan()
    unvanKisiSayisi <- length(filtreliData$data)
    paste("Seçilen ünvandaki toplam kişi sayısı:", unvanKisiSayisi)
  })
  
  
  # Tayin Talep Sorgusu Sayfası
  filtered_data_talep <- reactive({
    if (input$data == "Tüm İller") {
      talepli_veri %>% 
        filter(!is.na(data) & grepl("^\\d+$", TALEP))
    } else {
      talepli_veri %>% 
        filter(!is.na(data) & grepl("^\\d+$", TALEP) & İL.ADI == input$data)
    }
  })
  
  filtered_data_talep_with_age_filter <- reactive({
    if (input$data == "açık") {
      today <- Sys.Date()
      buyuk62Data <- filtered_data_talep() %>%
        mutate(DOĞUM.TARİHİ = as.Date(data, format = "%d.%m.%Y")) %>%
        mutate(Yas = as.numeric(difftime(today, data, units = "days")) / 365.25) %>%
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
      filtreliData <- filtreliData[!is.na(filtreliData$data) & filtreliData$data != "", ]
    } else if (input$izinAciklamaSecimi == "Yok") {
      filtreliData <- filtreliData[is.na(filtreliData$data) | filtreliData$data == "", ]
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

