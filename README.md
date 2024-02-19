# An-lisis-de-usuarios-del-metro
Proyecto: Análisis de ususarios del metro. Prototype Day Equipo 8
Descripción
Crear un modelo de negocios basado en el análisis del comportamiento de usuarios de la red del metro de la CDMX.

Datos
Descripción de la fuente de los datos, incluyendo:

Origen de los datos.
Características principales (por ejemplo, número de usuarios, variables disponibles).
Cualquier limpieza o preprocesamiento aplicado.
Herramientas y Tecnologías Utilizadas
Listado de las herramientas y tecnologías utilizadas en el análisis, como Python, Jupyter Notebook, librerías específicas (pandas, matplotlib, seaborn, etc.).

Cómo Utilizar este Repositorio
Instrucciones sobre cómo ejecutar el análisis, incluyendo:

Instalación de dependencias.
Ejecución del notebook.
Cualquier configuración necesaria.
Resultados Principales
Resumen de los hallazgos más importantes del análisis, que pueden incluir:

Patrones o tendencias identificadas.
Respuestas a las preguntas de investigación.
Visualizaciones clave.
Contribuciones
Información sobre cómo contribuir al proyecto, si es aplicable.

## Generador de JSON simulado para el proyecto


El script `simulador_con_transferencia.py` funciona en conjunto con `dijkstra_con_transferencias.py`. Usamos el algoritmo de Dijkstra, que es un algoritmo que encuentra el camino más corto entre dos nodos o vectores, manteniendo el registro del recorrido. Esto nos permitió dar seguimiento a todas las estaciones del recorrido de cada usuario. Genera un JSON de 150,000 usuarios del metro con sus rutas hacia el trabajo por dos semanas laborables. La información que contiene el JSON tiene la siguiente estructura:

return {
        "HoraDeEntrada": start_time.strftime("%H:%M:%S"),
        "HoraDeSalida": end_time.strftime("%H:%M:%S"),
        "Fecha": start_time.strftime("%d/%m/%Y"),
        "InteractuaConApp": interactua_con_app,
        "ComprasEnApp": compras_en_app,
        "Ruta": journey_stations,
        "Estación de entrada": start_station,
        "Estación de salida": end_station,
        "Lineas que fueron usadas": lines_rider_transfered,
    }
