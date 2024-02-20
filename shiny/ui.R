#Ejemplo 2. Normal con Labels

library(class)
library(dplyr)
library(stringr)
library(shiny)
library(shinydashboard)

source("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/metro_estaciones.R")


shinyUI(
    fluidPage(
        headerPanel("Afluencia del Metro de CDMX con app"),
        #sidebarPanel(
        #    p("Filtros"), 
        #    selectInput("linea", "Seleccione una línea",
        #                choices = unique(metro_cdmx$LINEA)),
        #    selectInput("hora_entrada_1", "Seleccione una hora entre:",
        #                choices = sort(unique(data_metro$HoraDeEntrada))),
        #    selectInput("hora_entrada_2", "y entre:",
        #                choices = sort(unique(data_metro$HoraDeEntrada))),
        #    selectInput("fecha", "Seleccione una fecha",
        #                choices = sort(unique(data_metro$Fecha))),
        #    selectInput("estacion", "Seleccione una estación",
        #                choices = sort(unique(data_metro$Estación.de.entrada)))
        #),
        mainPanel(
            
          
    #Agregando pestaÃ±as
    tabsetPanel(
        tabPanel("Datos", dataTableOutput("table")),
        
        tabPanel("Afluencia", 
                 sidebarLayout(
                   sidebarPanel(
                     p("Filtros"), 
                     selectInput("hora_entrada_1", "Seleccione una hora entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("hora_entrada_2", "y entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("fecha", "Seleccione una fecha",
                                 choices = sort(unique(data_metro$Fecha)))
                   ),
                   mainPanel(
                     dataTableOutput("data_table")
                   )
                 )
        ),
        
        tabPanel("Afluencia Por Estación (sample)", 
                 sidebarLayout(
                   sidebarPanel(
                     p("Filtros"), 
                     selectInput("hora_entrada_1_t3", "Seleccione una hora entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("hora_entrada_2_t3", "y entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("estacion_t3", "Seleccione una estación",
                                 choices = sort(unique(data_metro$Estación.de.entrada)))
                   ),
                   mainPanel(
                     dataTableOutput("data_table_sample")
                   )
                 )
        ),
        
        tabPanel("Gráfica (sample)", 
                 sidebarLayout(
                   sidebarPanel(
                     p("Filtros"), 
                     selectInput("hora_entrada_1_t4", "Seleccione una hora entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("hora_entrada_2_t4", "y entre:",
                                 choices = sort(unique(data_metro$HoraDeEntrada))),
                     selectInput("estacion_t4", "Seleccione una estación",
                                 choices = sort(unique(data_metro$Estación.de.entrada)))
                   ),
                   mainPanel(
                     plotOutput("data_tample_sample_barplot")
                   )
                 )
        ),
        
        tabPanel("Mapa de Lineas", 
                 sidebarLayout(
                   sidebarPanel(
                     p("Filtros"), 
                     selectInput("linea_t5", "Seleccione una línea",
                                 choices = unique(metro_cdmx$LINEA))
                   ),
                   mainPanel(
                     leafletOutput("mymap")
                   )
                 )
        ),
        
        tabPanel("Mapa completo", leafletOutput("myfullmap")),
        
        tabPanel("Afluencia por estación", 
                 sidebarLayout(
                   sidebarPanel(
                     p("Filtros"), 
                     selectInput("hora_entrada_1_t6", "Seleccione una hora entre:",
                                 choices = sort(unique(estaciones_entrada_mayor_afluencia_por_hora$HoraDeEntrada))),
                     selectInput("hora_entrada_2_t6", "y entre",
                                 choices = sort(unique(estaciones_entrada_mayor_afluencia_por_hora$HoraDeEntrada)))
                   ),
                   mainPanel(
                     leafletOutput("myMapAfluenciaEstacion")
                   )
                 )
        ),
        
        tabPanel("Cluster Rutas", 
                   mainPanel(
                     plotlyOutput("cluster_rutas")
                 )
        ),
        
        tabPanel("Cluster Entradas y Salidas", 
                   mainPanel(
                     plotOutput("cluster_entradas_y_salidas")
                 )
        ),
    )
)
)

)

