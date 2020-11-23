# Cluster no jerarquicos

library(openxlsx)
library(cluster)
library(devtools)
library(factoextra)
library(fpc)
library(NbClust)

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\bancos.xlsx")

#  - Normalizar la base 

nombres <- data$BANCOS

data <- data[,2:5]

row.names(base) <- nombres


base <- as.data.frame(scale(data))

row.names(base) <- nombres

cnj <- kmeans(base, 4) # Numero de clusters = K = 4

cnj

# (between_SS / total_SS =  58.6 %) - 58 es el porcentaje de clasificacion. 
# A medida que aumentamos el numero clusters la clasificacion siempre sera mejor. 
# Tambien funje como una clase de bonda de ajuste R^2, aunque se trata de un tradeoff
# donde si quiere un porcentaje de clasificacion, pero de que serviria clasificar 20
# clusters si tenemos 20 variables, no tendria sentido hacerlo. 

# Para obtener las medias de cada uno de los clusters para cada una de las variables.

cnj$centers

# ¿Como se ven los clusters?

fviz_cluster(cnj, data=base)

# Este grafico nos arroja los 4 clusters para 2 dimensiones. 
# En estos clusters se nos muestran los centroides. La suma de las dimensiones
# Nos arroja el grado de clasificacion, es decir, como el Divisive Coefficient
# En este casos seria de 33.2 + 38.7 = 71.9%

# El grafico anterior tambien lo podemos expresar con la paqueteria cluster 


clusplot(base,
         cnj$cluster,
         color = T,
         shade = T,
         label = 2,
         line = 2)
# Este grafico nos arroja que: "Estos 2 componentes explican el 71.0% de de variabilidad de puntos.

# ¿Cuantos clusters son los optimos?

cluster_optim <- NbClust(base,
                         distance = "euclidean",
                         min.nc = 2,
                         max.nc = 6,
                         method = "ward.D",
                         index = "all")

# According to the majority rule, the best number of clusters is  2

# Y esto se puede corroborar con este grafico:

fviz_nbclust(cluster_optim)

# Aunque de acuerdo al grafico y la tabla anterior, el numero optimo de clusters
# serian 2, 3 y 4. Se estila ocupar el principio de parsimonian. 

cnj2 <- kmeans(base, 2)

# Evaluando el clusters

silueta <- silhouette(cnj2$cluster,
                      dist(base, method = "euclidean"))


fviz_silhouette(silueta)

# La funcion silueta nos permite conocer es el promedio en ancho de la 
# clasificacion por cluster. Y nos demuestra que tan bien esta clasificando 
# La barra que cruza el grafico es el promedio. Y se espera que el algoritmo 
# tenga, en primera, valores positivos y en segunda, que sean lo mas altas posibles,
# es decir, cercanas a 1. De tener valores negativos y muy bajos puede que el algoritmo
# no este clasificando de la mejor manera. Para esto se recomienda probar con un numero
# distinto en K, revisar valores atipicos, revisar que las variables sean las "correctas",
# incorporar más variables al analisis cluster. Y por ultimo seria cambiar el enfoque 
# (transformar la base).

