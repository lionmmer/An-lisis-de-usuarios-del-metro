
pacman::p_load(dplyr, leaflet, sf, foreign, tidyverse, rjson)
library(httr)
library(jsonlite)
library(tidyverse)
library(rjson)
library(colorRamps)
library(plotly)

path_lines <- "C:\\Users\\juan9\\OneDrive\\Escritorio\\BEDU\\Modulo 5\\Proyecto\\stcmetro_shp\\STC_Metro_lineas_utm14n.dbf"

# useful csv
data <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/usuarios_rango_amplio_correcto.csv")
data_metro <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/Luis felipe/data.csv",header = TRUE) 
estaciones_mayor_afluencia <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/estaciones_entrada_mayor_afluencia_por_hora.csv")
data_cluster <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/cluster_ruta_general.csv")
cluster_labels <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/kmeans_labels.csv")
data_entradas_salidas <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/features_reducidos_entrada_salida.csv")
cluster_entradas_salidas <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/csv/cluster_entrada_salida.csv")

# useful sharp files
metro_cdmx <- st_read("C:\\Users\\juan9\\OneDrive\\Escritorio\\BEDU\\Modulo 5\\Proyecto\\stcmetro_shp\\STC_Metro_estaciones_utm14n.shp")

st_geometry_type(metro_cdmx)
st_crs(metro_cdmx)

paleta <- colorFactor(palette = c("pink","blue","seagreen","cyan","yellow","red","orange","green","brown","purple","lightgreen","gold"), 
                      unique(metro_cdmx$LINEA))

paleta_single <- colorFactor(palette = c("pink","blue","seagreen","cyan","yellow","red","orange","green","brown","purple","lightgreen","gold"), 
                        unique(metro_cdmx$LINEA))

linea_1 <- subset(metro_cdmx, LINEA=="04")

full_map_metro_cdmx <- metro_cdmx %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    weight=5,
    radius=5,
    fillColor="black",
    fillOpacity = 1,
    opacity = 1,
    label = ~NOMBRE,
    color = paleta_single(metro_cdmx$LINEA)
             ) %>%
  addLegend(pal=paleta_single, values = ~ LINEA)

full_map_metro_cdmx    

data_metro_sample <- read.csv("C:/Users/juan9/OneDrive/Escritorio/BEDU/Modulo 5/Proyecto/Luis felipe/data_sample.csv",header = TRUE) 

## ---------------------------------------------------------------------------------------------
## Data del metro

#data_metro$HoraDeEntrada <- as.POSIXct(data_metro$HoraDeEntrada, format = "%H:%M:%S")

result <- data_metro %>%
  filter(HoraDeEntrada >= "08:08:00" & HoraDeEntrada <= "08:08:00" & Fecha=="03/07/2023") %>%
  group_by(Estación.de.entrada) %>%
  summarize(Usuarios = n_distinct(NumeroDeUsuario))

result <- data_metro_sample %>%
  filter(Estación.de.entrada=="BALBUENA") %>%
  group_by(Fecha) %>%
  summarize(Usuarios = n_distinct(NumeroDeUsuario))

hist(result$Usuarios, col = "blue", border = "black", main = "Histograma", xlab = "Valores", ylab = "Frecuencia")

barplot(result$Usuarios, names.arg = result$Fecha, col = "blue",
        main = "Gráfico de Barras", xlab = "Categorías", ylab = "Valores")

#primer_elemento <- sapply(data_metro$Lineas.que.fueron.usadas, function(lista) lista[[1]])
#print(primer_elemento)

#barplot(result$Usuarios, names.arg = result$Estación.de.entrada, col="blue")


#data_metro$HoraDeEntrada <- as.POSIXct(data_metro$HoraDeEntrada, format="%d/%m/%Y %H:%M:%S")
# estaciones_usadas <- read_csv("\\\\wsl.localhost\\Ubuntu-20.04\\home\\jhonnyfasio\\BEDU\\cluster_agrupamiento\\rutas_usadas.csv")

#for (i in seq_len(nrow(estaciones_usadas))){
#  estaciones_usadas$Ruta[[i]] <- tolower(estaciones_usadas$Ruta[[i]])
#}

# ------------------------------------------------------------------------------
# Mayor afluencia por estación y horario
afluencia_por_hora_estacion <- data %>%
  group_by(HoraDeEntrada, Estación.de.entrada) %>%
  tally()

# Renombrar la columna resultante de 'n' a 'Conteo'
afluencia_df <- afluencia_por_hora_estacion %>%
  rename(Conteo = n)

# Ordenar el dataframe
afluencia_df <- afluencia_df %>%
  arrange(HoraDeEntrada, desc(Conteo))

# Seleccionar las 10 estaciones con mayor afluencia por hora
estaciones_entrada_mayor_afluencia_por_hora <- afluencia_df %>%
  group_by(HoraDeEntrada) %>%
  top_n(10, wt = Conteo)

print(estaciones_entrada_mayor_afluencia_por_hora)

paleta_afluencia <- colorRampPalette(c("blue","green","orange","red"))(1000)

#result <- estaciones_entrada_mayor_afluencia_por_hora %>%
#  filter(HoraDeEntrada >= "05:00:00" & HoraDeEntrada <= "12:00:00") %>%
#  group_by(Estación.de.entrada)%>%
#  summarize(Conteo = sum(Conteo))

# -------------------------------------------------------------------------------
# Cluster_map_rutas
cluster_rutas <- plot_ly(
    data_cluster, 
    x =  data_cluster[, 2], 
    y = data_cluster[, 3], 
    color = factor(cluster_labels$Cluster),
    type="scatter",
    mode="markers"
    ) %>% 
  layout(
    title = "Visualización de Clusters por Ruta de Usuario",
    xaxis = list(title="Componente Principal 1"),
    yaxis = list(title="Componente Principal 2"),
    showlegend= TRUE
  )

#cluster_map_entradas_salidas
cluster_entradas_y_salidas <- ggplot(
  data_entradas_salidas, 
  aes(x =  data_entradas_salidas[, 2], 
      y = data_entradas_salidas[, 3], 
      color = factor(cluster_entradas_salidas$X0))) +
  geom_point() +
  labs(title = "Visualización de Clusters de estacions de entrada y salida",
       x = "Componente Principal 1",
       y = "Componente Principal 2",
       color = "Cluster") +
  theme_minimal()
