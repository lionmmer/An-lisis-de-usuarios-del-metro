#Ejemplo 2. Normal con Labels  

library(shiny)
library(dplyr)
library(stringr)
library(leaflet)



shinyServer(function(input, output) {

 output$output_text <- renderText(paste("Linea", input$x))
 
 # Agregando el dataframe
 output$table <- renderDataTable({ 
     data_metro
     })
 
 
 #Agregando el data table afluencia
 output$data_table <- renderDataTable({
   result <- data_metro %>%
     filter(HoraDeEntrada >= input$hora_entrada_1 & HoraDeEntrada <= input$hora_entrada_2 & Fecha==input$fecha) %>%
     group_by(Estación.de.entrada) %>%
     summarize(Usuarios = n_distinct(NumeroDeUsuario))
   
   result
   },options = list(aLengthMenu = c(5,10,15,20,25),iDisplayLength = 15))
 
 
 
 #Agregando el data table afluencia por estación
 output$data_table_sample <- renderDataTable({
   result <- data_metro_sample %>%
     filter(HoraDeEntrada >= input$hora_entrada_1_t3 & HoraDeEntrada <= input$hora_entrada_2_t3 & Estación.de.entrada==input$estacion_t3) %>%
     group_by(Fecha) %>%
     summarize(Usuarios = n_distinct(NumeroDeUsuario))
   
   result
 },options = list(aLengthMenu = c(5,10,15,20,25),iDisplayLength = 15))
 
 
 
 #Agregando el barplot afluencia por estación
 output$data_tample_sample_barplot <- renderPlot({
   result <- data_metro_sample %>%
     filter(HoraDeEntrada >= input$hora_entrada_1_t4 & HoraDeEntrada <= input$hora_entrada_2_t4 & Estación.de.entrada==input$estacion_t4) %>%
     group_by(Fecha) %>%
     summarize(Usuarios = n_distinct(NumeroDeUsuario))
   
   barplot(result$Usuarios, names.arg = result$Fecha, col = "blue",
           main = "Afluencia por estación", xlab = input$estacion_t4, ylab = "Usuarios")
 })
 
 
 
 #Map Lines
 output$mymap <- renderLeaflet({
   linea_selected <- input$linea_t5
   
   linea_n <- subset(metro_cdmx, LINEA==linea_selected)
   
   map_metro_cdmx <- linea_n %>%
     leaflet() %>%
     addTiles() %>%
     addCircleMarkers(
       weight=5,
       radius=5,
       fillColor="black",
       fillOpacity = 1,
       opacity = 1,
       label = ~NOMBRE,
       color = paleta_single(linea_n$LINEA)
     ) %>%
     addLegend(pal=paleta_single, values = ~ LINEA)
   
   map_metro_cdmx
 })
 
 #Map Full
 output$myfullmap <- renderLeaflet({
   full_map_metro_cdmx
 })
 
 
 #estaciones de mayor afluencia
 output$myMapAfluenciaEstacion <- renderLeaflet({
   estacion_selected <- input$estacion_t6
   
   linea_n <- subset(metro_cdmx, NOMBRE==estacion_selected)
   
   result <- estaciones_entrada_mayor_afluencia_por_hora %>%
     filter(HoraDeEntrada >= input$hora_entrada_1_t6 & 
              HoraDeEntrada <= input$hora_entrada_2_t6) %>%
     group_by(Estación.de.entrada)%>%
     summarize(Conteo = sum(Conteo))
   
   map_metro_cdmx <- metro_cdmx %>%
     leaflet() %>%
     addTiles() %>%
     addCircleMarkers(
       weight=5,
       radius=5,
       fillColor="black",
       fillOpacity = 1,
       opacity = 1,
       #label = ~paste("Conteo:",result$Conteo, "estacion:", toupper(NOMBRE)),
       #color = colorNumeric(palette = paleta_afluencia, domain = result$Conteo)(result$Conteo)
       color = colorRamps::matlab.like2(1000)[cut(result$Conteo, breaks=1000)]
     ) %>%
     addLegend(pal=paleta_single, values = ~ LINEA)
   
   map_metro_cdmx
 })
 
 
 #horarios de mayor afluencia
 
 
 # Cluster rutas general
 output$cluster_rutas <- renderPlot({
   cluster_rutas
 })
 
 
 # Cluster entradas y salidas
 output$cluster_entradas_y_salidas <- renderPlot({
   cluster_entradas_y_salidas
 })
       
})
