import os
import random
import json
from datetime import date, datetime, timedelta
from lineas import  linea_1, linea_2,linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9, linea_A, linea_B, linea_12
from djkstra_con_transferencias import dijkstra, metro_graph

todas_las_estaciones = list(set().union(linea_1, linea_2, linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9, linea_A, linea_B, linea_12))


def simulate_commuter_journey(start_time, start_station, end_station):
    #Genera el camino mas corto entre estaciones
    station_count, journey_stations,lines_rider_transfered = dijkstra(metro_graph, start_station, end_station)

    # Elige una duración al azar del viaje por estación
    journey_time_minutes = (station_count - 1) * random.randint(3, 15)

    # Calcula la hora de fin del viaje
    end_time = start_time + timedelta(minutes=journey_time_minutes)


    #Generar aleatoriamente compras, e interactua con app
    interactua_con_app = random.choice(["Si", "No"])
    compras_en_app = random.randint(0, 13)

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


def generate_week_of_entries(start_date, start_station, end_station, start_hour):
    entries = []
    days_generated = 0  # Lleva el registro de los días generados
    while days_generated < 15:  # Generar datos para 15 días
        if start_date.weekday() != 6:  # Saltar domingo
            start_time = datetime(start_date.year, start_date.month, start_date.day, start_hour, random.randint(0, 59))
            entries.append(simulate_commuter_journey(start_time, start_station, end_station))
            days_generated += 1
        start_date += timedelta(days=1)  # Siguiente día
    return entries


num_commuters = 1 
start_date = date(2023, 7, 3)  # Fecha de inicio siempre tiene que ser lunes 
start_station = random.choice(todas_las_estaciones)


#Guarda el ultimo id usado
def save_last_user_id(file_name, last_id):
    with open(file_name, 'w') as file:
        file.write(str(last_id))
#Encuentra el ultimo id guardado
def get_last_user_id(file_name):
    if os.path.exists(file_name):
        with open(file_name, 'r') as file:
            last_id = int(file.read())
    else:
        last_id = 0
    return last_id

# Aqui se guarda memo el ultimo id usado
last_id_file = 'last_user_id.txt'
last_user_id = get_last_user_id(last_id_file)


def generate_users_data(num_users,start_id):
    user_dict = {}

    for user_id in range(start_id + 1, start_id + num_users + 1):
        start_date = date(2023, 7, 3)  # Fecha de inicio siempre tiene que ser lunes
        start_station = random.choice(todas_las_estaciones)

        end_station = random.choice(todas_las_estaciones)
        # Asegurarnos que la estación de inicio y destino no sean la misma
        while end_station == start_station:
            end_station = random.choice(todas_las_estaciones)

        start_hour= random.randint(5, 11)

        user_entries = generate_week_of_entries(start_date, start_station, end_station, start_hour)
        user_dict[user_id] = user_entries 

    return user_dict

num_users = 1 #numero de usuarios a generar  max 100000 

last_user_id = get_last_user_id(last_id_file)


users_data = generate_users_data(num_users, last_user_id)

json_file_name = f'usuarios_metro_data{last_user_id}.json'
# Save users_data to a JSON file
with open(json_file_name, 'w') as json_file:
    json.dump(users_data, json_file, ensure_ascii=False, indent=4)

save_last_user_id(last_id_file, last_user_id + num_users)
print(f"Data saved to {json_file_name}")





#INSTRUCCIONES
#SOLO POR PRIMERA VEZ O SI QUIEREN REINICIAR LA CUENTA DE USUARIOS
# 1- ASEGURARSE QUE  CUANDO LO CORREN POR PRIMERA VEZ last_user_id.txt este en 0
# 2- ASEGURAR QUE users_data.json este vacio (POR SI ACASO)

#############################################################################


