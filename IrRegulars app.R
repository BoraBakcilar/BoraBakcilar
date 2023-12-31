# Stat292 
#2022-2023 spring semester
#Final Project
#IrRegulars

# Arzu Satır, Bora Bakçılar, Mısra Sargın, Kerem Kayval


# Libraries
if (!require(ggplot2)) install.packages("ggplot2") ; library(ggplot2)
if (!require(plotly)) install.packages("plotly") ; library(plotly)
if (!require(dplyr)) install.packages("dplyr") ; library(dplyr)
if (!require(reshape2)) install.packages("reshape2") ; library(reshape2)
if (!require(shinythemes)) install.packages("shinythemes") ; library(shinythemes)
if (!require(DT)) install.packages("DT") ; library(DT)
if (!require(googlesheets4)) install.packages("googlesheets4") ; library(googlesheets4)
if (!require(tidyr)) install.packages("tidyr") ; library(tidyr)

# Data importing
gs4_auth()
sheet <- gs4_get("https://docs.google.com/spreadsheets/d/1VNyuLitTz0t6R8riTxx26je3F9LXrhrM36ZzrIdtyH8/edit?usp=sharing")
data <- sheet %>% range_read()
sheet2 <- gs4_get("https://docs.google.com/spreadsheets/d/1xGY_QIzABJFgBGiP11MOd4uM0zQ5nfL7I0GTUgyEtKU/edit?usp=sharing")
data2 <- sheet2 %>% range_read()


# Dealing with some problems
data$Value <- as.numeric(data$Value)
data$Minimum_wage <- as.numeric(data$Minimum_wage)
data$Agriculture_Land <- as.numeric(data$Agriculture_Land)
data$Tempature_Mean <- as.numeric(data$Tempature_Mean)
data$Population_Million <- as.numeric(data$Population_Million)
data$Tempature_Change_C <- as.numeric(data$Tempature_Change_C)
data$Rural_Population <- as.numeric(data$Rural_Population)
data$Urban_Population <- as.numeric(data$Urban_Population)
data$Month <- factor(data$Month, levels = c("Ocak", "Şubat", "Mart", "Nisan",
                                            "Mayıs", "Haziran", "Temmuz", "Ağustos",
                                            "Eylül", "Ekim", "Kasım", "Aralık"))
data2$Value <- as.numeric(data2$Value)
data2$Year <- as.factor(data2$Year)
data2$Value[data2$Value >1100] <- NA

variables <- c("Year","Month","Value","Minimum_wage", "Agriculture_Land", "Tempature_Mean", 
               "Population_Million", "Tempature_Change_C", "Rural_Population", 
               "Urban_Population")

# Multiple Linear Regression 
mlr_regression <- function(data, x1, x2) {
  mlr_data <- data[, c(x1, x2, "Value")]
  model <- lm(Value ~ ., data = mlr_data)
  coefficients <- coef(model)
  summary <- summary(model)
  scatterplot <- ggplot(mlr_data, aes_string(x = x1, y = "Value")) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    labs(title = "Linear Regression", x = x1, y = "Value")
  
  list(
    Coefficients = coefficients,
    Summary = summary,
    Scatterplot = scatterplot
  )
}


# World Map Data
world_map_data <- data2 %>%
  filter(!is.na(Country)) %>%
  select(Country, Year, Value) %>%
  pivot_wider(names_from = Year, values_from = Value)

# Define UI
ui <- navbarPage(
  theme = shinytheme("yeti"),
  
  title = "Türkiye Food Data Analysis",
  #Introduction
  tabPanel(
    "Introduction",
    sidebarLayout(
      sidebarPanel(),
      mainPanel(
        # Introduction Text
        tags$div(
          class = "intro-text",
          HTML("<h3> Turkey Food Data Analysis </h3>
               <p> Welcome to Turkey’s Food Prices App! This app was developed by Bora Bakçılar, Arzu Satır, Mısra Sargın, and Kerem Kayval. 
                  As the iRRegulars group, we intended to see which variables are affecting the end price of food in Turkey. </p>
               <p>We gathered our data from various organizations such as FAO (Food and Agriculture Organization of the United Nations) and the General Directorate of Meteorology of Turkey. </p>
               <p>We were aware that there are obvious relationships between our variables, when food prices increase also the minimum wage increases in time, but we tried to find other relationships so that we added data from different sources.  </p>
               <p>In this app, users can observe the relations between variables such as agricultural land, rural or urban population, Turkey’s population, minimum wage, temperature change or mean temperature between the years 2009 and 2018. 
                  Users have the option to view data in a basic data table, scatter plot, box plot, or as a bar graph! Simple linear regression and multiple linear regression models are also available. </p>
               <p>We hope that this app will provide insights to everyone who uses it! It was our first try, and as a group we did our best!  </p>
               <p> Arzu Satır 2302461 </p>
               <p> Bora Bakçılar 2290534 </p>
               <p> Mısra Sargın 2290914 </p>
               <p> Kerem Kayval 2337616 </p>
              ")
        ),
        
        # References
        tags$div(
          class = "data-source",
          HTML("<h4>References:</h4>
               <p> Food and Agriculture Organization of the United Nations. (n.d.-b). <em> Consumer Price Indices.</em> FAOSTAT. 
               <a href='https://www.fao.org/faostat/en/#data/CP'>https://www.fao.org/faostat/en/#data/CP</a></p>
               
               <p> Food and Agriculture Organisation ıf the United Nations. (n.d.-a). <em> Land Use. </em> FAOSTAT. 
               <a href='https://www.fao.org/faostat/en/#data/RL'>https://www.fao.org/faostat/en/#data/RL</a></p>
               
               <p> Food and Agriculture Organization of the United Nations. (n.d.-c). <em> Temperature Change on Land.</em> FAOSTAT.
               <a href='https://www.fao.org/faostat/en/#data/ET'>https://www.fao.org/faostat/en/#data/ET</a></p>
               
               <p>Food and Agriculture Organization of the United Nations. (n.d.-b). <em> Annual Population. </em> FAOSTAT. 
               <a href='https://www.fao.org/faostat/en/#data/OA'>https://www.fao.org/faostat/en/#data/OA</a></p>
               
               <p> OCAL, Av. Arb. S. (2023, January 10). <em> Yillara Gore Net ve Brut Asgari Ucret Tablosu. </em> OCAL Hukuk Burosu.
               <a href='https://www.ocalhukuk.com/yillara-gore-net-ve-brut-asgari-ucret-tablosu/'>https://www.ocalhukuk.com/yillara-gore-net-ve-brut-asgari-ucret-tablosu/</a></p>
               
               <p>T.R. Ministry of Environment, Urban Planning and Climate Change General Directorate of Meteorology. (n.d.). <em> Monthly Temperature Analysis. </em> General Directorate of Meteorology.
               <a href='https://www.mgm.gov.tr/veridegerlendirme/sicaklik-analizi.aspx'>https://www.mgm.gov.tr/veridegerlendirme/sicaklik-analizi.aspx</a></p>")
        )
      )
    )
  ),
  
  # Data
  tabPanel(
    "Basic Data Table",
    sidebarLayout(
      sidebarPanel(
        selectInput("datatable_col1", "Column 1", selected = "Year", choices = variables),
        selectInput("datatable_col2", "Column 2", selected = "Value", choices = variables),
      ),
      mainPanel(
        dataTableOutput("datatable_output")
      )
    )
  ),
  
  #Scatter Plot
  tabPanel(
    "Scatter Plot",
    sidebarLayout(
      sidebarPanel(
        selectInput("scatterplot_col1", "X - Axis", selected = "Year", choices = variables ),
        selectInput("scatterplot_col2", "Y - Axis", selected = "Value", choices = variables),
      ),
      mainPanel(
        plotlyOutput("scatterplot_output")
      )
    )
  ),
  
  #Box Plot
  tabPanel(
    "Box Plot",
    sidebarLayout(
      sidebarPanel(
        selectInput("selectgraph_x", "X-Axis", selected = "Year", choices = c("Month","Year","Tempature_Mean","Tempature_Change_C","Value") ),
        selectInput("selectgraph_y", "Y-Axis", selected = "Value", choices = c("Tempature_Mean","Tempature_Change_C","Value")),
      ),
      mainPanel(
        plotlyOutput("selectgraph_output")
      )
    )
  ),
  
  
  
  # Bar Graph
  tabPanel(
    "Bar Graph",
    sidebarLayout(
      sidebarPanel(
        selectInput("bargraph_x", "X-Axis", selected = "Yearly", choices = c("Yearly", "Monthly")),
        selectInput("bargraph_y", "Y-Axis", selected = "Value", choices = names(data)[sapply(data, is.numeric)])
      ),
      mainPanel(
        plotOutput("bargraph_output")
      )
    )
  ),
  
  
  # Simple Linear Model
  tabPanel(
    "Simple Linear Model",
    sidebarLayout(
      sidebarPanel(
        selectInput("relationship_x", "X-Axis", selected = "Year", choices = variables ),
        selectInput("relationship_y", "Y-Axis", selected = "Value", choices = variables ),
      ),
      mainPanel(
        plotOutput("relationship_output")
      )
    )
  ),
  
  
  #  Multiple Linear Regression
  tabPanel(
    "Multiple Linear Regression (Y = Value)",
    sidebarLayout(
      sidebarPanel(
        selectInput("mlr_x1", "X Variable 1", choices = c("Minimum_wage", "Agriculture_Land", "Tempature_Mean", "Population_Million", "Tempature_Change_C", "Rural_Population", "Urban_Population")),
        selectInput("mlr_x2", "X Variable 2", choices = c("Minimum_wage", "Agriculture_Land", "Tempature_Mean", "Population_Million", "Tempature_Change_C", "Rural_Population", "Urban_Population")),
        actionButton("mlr_run", "Run Regression")
      ),
      mainPanel(
        verbatimTextOutput("mlr_output"),
        plotOutput("mlr_plot")
      )
    )
  ),
  

  # World Map Data
  tabPanel(
    "World Map Data",
    mainPanel(
      selectInput(
        inputId = "year_selection",
        label = "Select Year",
        choices = levels(data2$Year)
      ),
      plotlyOutput("worldmap_output")
    )
  )
)



# Define server
server <- function(input, output, session) {

  # Data
  output$datatable_output <- renderDataTable({
    datatable(data[, c(input$datatable_col1, input$datatable_col2)], options = list(pageLength = 120))
  })
  
  # Scatter Plot
  output$scatterplot_output <- renderPlotly({
    p <- ggplot(data, aes_string(x = input$scatterplot_col1, y = input$scatterplot_col2)) +
      geom_point() +
      labs(title = "Scatter Plot", x = input$scatterplot_col1, y = input$scatterplot_col2)
    
    ggplotly(p)
  })
  
  #  Box plot
  output$selectgraph_output <- renderPlotly({
    p <- ggplot(data, aes_string(x = input$selectgraph_x, y = input$selectgraph_y)) +
      geom_boxplot() +
      labs(title = "Box Plot" , x = input$selectgraph_x, y = input$selectgraph_y)
    
    ggplotly(p, tooltip = c("x", "y"))
  })
  
  
  # Bar Graph
  output$bargraph_output <- renderPlot({
    if (input$bargraph_x == "Monthly") {
      data_summary <- data %>%
        group_by(Month) %>%
        summarise(across(where(is.numeric), mean))
      
      p <- ggplot(data_summary, aes_string(x = "Month", y = input$bargraph_y)) +
        geom_bar(stat = "identity") +
        labs(title = "Bar Graph", x = "Month", y = paste("Average", input$bargraph_y))
    } else {
      data_summary <- data %>%
        group_by(Year) %>%
        summarise(across(where(is.numeric), mean))
      
      p <- ggplot(data_summary, aes_string(x = "Year", y = input$bargraph_y)) +
        geom_bar(stat = "identity") +
        labs(title = "Bar Graph", x = "Year", y = paste("Average", input$bargraph_y))
    }
    
    p
  })
  
  # Simple Linear Model
  output$relationship_output <- renderPlot({
    ggplot(data, aes_string(x = input$relationship_x, y = input$relationship_y)) +
      geom_smooth(method = "lm") +
      labs(title = "Simple Linear Model", x = input$relationship_x, y = input$relationship_y)
  })
  
  # Multiple Linear Regression
  output$mlr_output <- renderPrint({
    req(input$mlr_run)
    x1 <- input$mlr_x1
    x2 <- input$mlr_x2
    result <- mlr_regression(data, x1, x2)
    result$Coefficients
  })
  
  output$mlr_plot <- renderPlot({
    req(input$mlr_run)
    x1 <- input$mlr_x1
    x2 <- input$mlr_x2
    result <- mlr_regression(data, x1, x2)
    result$Scatterplot
  })
  
  
  # World Map Data
  output$worldmap_output <- renderPlotly({
    selected_year <- input$year_selection
    
    fig <- plot_ly(world_map_data, type = "choropleth", locations = ~Country, locationmode = "country names",
                   z = ~get(selected_year), colorscale = "Viridis",
                   text = ~paste("Country: ", Country, "<br>Year: ", selected_year, "<br>Value: ", get(selected_year))) %>%
      colorbar(title = "Consumer Price") %>% 
      layout(title = "World Map Data", geo = list(scope = "world"))
    
    fig
  })
}


# Run the app
shinyApp(ui = ui, server = server)
