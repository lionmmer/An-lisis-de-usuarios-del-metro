from collections import defaultdict
import heapq
from lineas import  linea_1, linea_2, linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9, linea_A, linea_B, linea_12

lineas = [linea_1, linea_2, linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9, linea_A, linea_B, linea_12]

metro_graph = defaultdict(list)

def add_to_graph(linea, j):
    for i in range(len(linea)-1):
        metro_graph[linea[i]].append((linea[i+1], 1, j))
        metro_graph[linea[i+1]].append((linea[i], 1, j))
for i, linea in enumerate(lineas, 1):
    add_to_graph(linea, i)

# Implementación del algoritmo de Dijkstra 
def dijkstra(metro_graph, start, end):
    queue = [(0, start, [], [])]  # tiempo, nodo, camino, líneas usadas
    seen = set()
    
    while queue:
        time, node, path, lines = heapq.heappop(queue)
        if node not in seen:
            seen.add(node)
            path.append(node)

            if node == end:
                return time, path, lines

            for next_node, next_cost, line in metro_graph[node]:
                if next_node not in seen:
                    new_lines = lines + [line] if not lines or lines[-1] != line else lines
                    heapq.heappush(queue, (time + next_cost, next_node, list(path), new_lines))

    return float("inf"), [], []

