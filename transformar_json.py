import pandas as pd
import json

#Convierte el JSON en CSV

def json_to_csv(file_path, csv_file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)

    rows_list = []
    for id_usuario, registros in data.items():
        for registro in registros:
            registro['Ruta'] = json.dumps(registro['Ruta'], ensure_ascii=False)
            registro['Lineas que fueron usadas'] = json.dumps(registro['Lineas que fueron usadas'])
            registro['ID_USUARIO'] = id_usuario
            rows_list.append(registro)

    df = pd.DataFrame(rows_list)
    df.to_csv(csv_file_path, index=False, encoding='utf-8-sig')

# Limpia el csv generado para que no tenga dobles comillas

def clean_csv_quotes(original_csv_path, new_csv_path):
    with open(original_csv_path, 'r', encoding='utf-8') as original_file, \
         open(new_csv_path, 'w', encoding='utf-8') as new_file:
        for line in original_file:
            modified_line = line.replace('""', "'")
            new_file.write(modified_line)

# Cambiar rutas a rutas locales
json_file_path = '.../150mil_5am_11am_data.json' # Ruta del JSON a transformar
original_csv_path = '.../usuarios_rango_amplio0.csv' # Nombrar csv con su ruta  
new_csv_path = '.../usuarios_rango_amplio0_limpio.csv'  # Nombrar csv con su ruta para limpieza 


json_to_csv(json_file_path, original_csv_path)
clean_csv_quotes(original_csv_path, new_csv_path)
