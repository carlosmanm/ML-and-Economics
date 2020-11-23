# -------------- Clasificacion y segmentacion mediante conglomerados (clusters) ------------

# El analisis de cluster es clasificado dentro de la estadistica multivariante 
# o en la parte de machine learning como un tipo de modelo de aprendizaje no supervisado. 
# Y tambien esta clasificada como una tecnica de reduccion de datos.
# Esta metodologia sirve para: identificar si existen valores atipicos, clasificar y segmentar
# los datos, insumo para otras metodologia a traves de la reduccion en clusters.

# Se requiere conocimiento sobre: algebra matricial, geometria analitica, estadistica descriptiva.

# Es un conjunto de tecnicas de clasificacion o agrupamiento de fenomenos en grupos lo mas homogeneos 
# posibles, pero entre grupos lo mas distintos posibles.

# Se agrupan casos o variables (objetos) segun necesidad

# Es un metodo de independencia, es decir, ninguna variable es causal de otra por lo que no hay 
# modelizacion previa. 

# Los clusters generalemente no se los conoce con anticipacion. 

# Supuestos de normalidad, homocedasticidad, etc. No son indispensables en esta tecnica endetrimento a otras
# como en regresion multiple

# Variables deben estar en la misma escala, por lo que generalmente deben ser tipificadas.

# Variables pueden ser cuantitativas u ordinales

# Seleccion del metodo de calculo para las distancias depende del fenome en estudio.

# Las estimaciones son sensibles ante outliers y missing data (generalmente no se llega a una solucion)

# ------------- Tipos de clusters -----------------------

# 1. Jerarquico (ramificado) -> Vinculacion, Centroide, Varianzas

# 2. No Jerarquico (Partitativos) -> algoritmo de K-Medias, algoritmo de H-medias

# -------------- No jerarquicos ------------------

# No hay jerarquias entre los grupos
# Se debe especificar el numero de cluster a priori (vulnerabilidad) sin embargo existe libreria que sugiere
# numero optimo de clusters. 
# Usan diversos criterios de optimizacion
# Trabajan con la matriz original y no con proximidades
# Trabaja con algoritmos que mininizan la varianza residual, maximizando la distancia entre
# los clusters (haciendolos lo mas distintos posibles) y minimizando la distancia entre el centroide 
# y la media fijada aleatoriamente. (haciendo los grupos lo mas parecidos posibles)

# Centroide: es el centro de la gravedad de una poblacion en un conjunto de variables vector de las medias 
# de las variables. 
# Media es a univariante como centroide es a multivariante. 

# ---------------- Algoritmo de K-medias -------------------

# Parte de la asignacion de una media aleatoria en los grupos: de forma iterativa mide la varianza residual, segun 
# cada asignacion. Se requiere la minima varianza residual. 

# Se determina una nueva configuracion de grupo con nuevas medias.
# Se vuelve a calcular las distancias y varianza residual

# El criterio de parada consiste en detener el algoritmo cuando:

# La varianza residual sea la minima en cada pertenencia.
# Numero prefijado para la diferencia entre los centroides de 2 pasos consecutivos.
# El numero prefijado de iteraciones generalmente es de 10.

# Ejemplo:

# 1. Se tienen 3 clusters, es decir K = 3

# 2. A cada K se le asigna una media aleatoria como iteracion inicial.

# 3. Se asigna cada caso al centroide más cercano. 

# 4. Se colocan los centroides en el centro del grupo. 

# 5. El proceso de detiene cuando la distancia entre los centroides es maxima. 
# Es decir: (la distancia entre los grupos es maxima)

# La distancia entre los casos y los centroides es minima 
# Es decir: (Los grupos son los mas homogenos posibles)


# --------------- Algoritmos Jerarquicos -----------------------

# El proceso inica aglomerando grupos como individuos, por lo que con esto se construye un 
# cluster inicial.

# El proceso continua uniendo 2 individuos a un nuevo cluster o a otro grupo previo. 
# ¿ Diferencia entre el jerarquico y el no jerarquico?
# En el cluster no jerarquico no se puede unir a otro grupo previo. 

# La finalizacion del proceso indica una aglomeracion total de todos los casos y todos los grupos.

# ¿ Como se asignan los clusters para cada caso?

# ----- Tipos de clusters jerarquicos ---------------


# 1. Vinculacion -> Intragrupos y Intergrupos (considera la distancia media entre todos los pares posibles de casos, por cada cluster)

# 2. Varianzas -> WARD. Combina las uniones entre casa caso y calcula la varianza residual; en la combinacion que menor VR obtenga,
#                       se detiene y forma la mejor pareja. (generalmente se utiliza esta)

# 3. Centroide -> Considera coo distancia a la media de los individuos que componen el cluster ¿Como se llama esto? Media de la estadistica multivariante.

# La diferencia entre jerarquicos y no jerarquicos radica en que usted tiene que decirle al software
# o al algoritmos cuantos clusters va a construir, en detrimento al jerarquico en donde todos los elementos
# son clasificados de manera individual y luego pueden ser agrupados en subclusters.

# Nota:

# Se tienen distintos tipos de distancias: Euclidean (la mas comun), Maximum, Manhattan, Binary, etc. 
# Ejemplo la Maximum, representa la "distancia máxima entre dos componentes de x e y"
# mientras que la euclidean es la "distancia habitual entre los dos vectores".

# Y para distintas distancias hay distintos metodos. Por ejemplo:

# Metodo de Ward.d, Ward.D^2 (más general), Single, Average, etc. 