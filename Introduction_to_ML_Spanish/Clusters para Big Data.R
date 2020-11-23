# Clusters para Big Data

library(openxlsx)
library(cluster)
library(devtools)
library(factoextra)
library(fpc)
library(NbClust)
library(gridExtra)

# Hay 2 metodos que son utilizados cuando se tiene mucha data, 
# K-medoids
# Clara (clustering large applications)

# K-medoids en diferencia al algoritmo de K-means, se le conoce como
# un algoritmo mejorado, porque no toma de manera aleatoria el centroide, 
# sino que a partir del conjunto de datos, toma un dato del conjunto como
# un medoide (ya no es centroide, sino medoide, los cuales siguen siendo centros.

# El centroide es asignado aleatoriamente en K-means, y el medoide es obtenido 
# a traves del conjunto de los datos.

# El hecho de que utilice un medoide hace más robusto el analisis. Por ese motivo es 
# mejor ante la presencia de valores atipicos. 

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\bancos.xlsx")

nombres <- data$BANCOS

data <- data[,2:5]

row.names(base) <- nombres

base <- as.data.frame(scale(data))

row.names(base) <- nombres

# ---- Numero optimo de clusters ---------------

cluster_optim <- NbClust(base,
                         distance = "euclidean",
                         min.nc = 2,
                         max.nc = 6,
                         method = "ward.D",
                         index = "all")

# ----- clasificando por medoides ------------

# pam : Partitioning Around Medoids

medoide <- pam(base,2)
medoide

# Tambien nos arroja la clasificacion de cada un de las variables en cada clusters
# basicamente son los mismos resultados del k-means.

gm <- fviz_cluster(medoide,
                   data = base)
gm

# Comparando con el centroide

centroide <- kmeans(base, 2)

gc <- fviz_cluster(centroide,
                   data = base)

grupo <- grid.arrange(gm, gc,
                      ncol =2)

# Podemos ver la diferencia de clasificaciones y se puede ver los
# centroides en en un grafico y en el de medoides no, dado que trabaja con el
# conjunto de los datos. 


# Clustering Large Applications (CLARA) para Big Data

# A pesar de que CLARA, al igual que k-medoids, es para bases de datos grandes,
# sin embargo, se dice que es mucho mas optima dado que clara trabaja de forma escalada
# a traves de la toma de un tamaño muestral especifico, es decir, si nosotros le proponemos tomar
# muestras de 100 datos y calcular los medoides de dichas muestras, por ello claro no es mas que 
# meter muestreos dentro de la funcion Partitioning Around Medoids.

modelclara <- clara(base, 
                    sample=5, 
                    k = 2)
modelclara

# Las estimaciones son similares dado que se trata de una base chica, pero las diferencias se tomaran con respecto
# al numero de datos.

gclara <- fviz_cluster(modelclara,
                   data = base)

# ---- Comparacion k means vs k-medoids vs CLARA ----



grupo <- grid.arrange(gc, gm, gclara,
                      ncol =3)

# Vemos como el k-medoids, (ambos trabajan con medoides) clasifican casi
# de la misma manera, que cuando se trabaja con centroides. (k-means)
# Ademas CLARA y k-medoids se parecen más dado el pequeño numero de datos.

# Tambien debemos ser criticos, es decir, verificar que agentes se deben
# clasificar con otros agentes, por ejemplo, en México si K-means clasifica a 
# Banco Azteca con Compartamos, eso estara bien, y a BBVA con CITI, tambien estara
# bien, pero si notamos que otro algoritmos nos arroja algo como: BBVA y BanRegio, 
# la situacion no es tan realista, por ello, no debemos olvidar nuestro lado critico
# y elegir el algoritmo que creamos mejor clasifica tambien segun nuestro criterio. 