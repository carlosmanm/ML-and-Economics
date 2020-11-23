# ---------- Caso practico Cluster Jerarquico --------------


library(openxlsx)
library(cluster)
library(devtools)
library(factoextra)
library(fpc)

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\bancos.xlsx")

#  - Normalizar la base 

nombres <- data$BANCOS

data <- data[,2:5]

base <- as.data.frame(scale(data))

# Con la funcion Scale ya todo se mantiene en una sola escala, es decir, 
# la base ya esta tificiada.

row.names(base) <- nombres

# -- Metodo para separacion. 

?dist

# Se tienen distintos tipos de distancias: Euclidean, Maximum, Manhattan, Binary, etc. 
# Ejemplo la Maximum, representa la "distancia máxima entre dos componentes de x e y"
# mientras que la euclidean es la "distancia habitual entre los dos vectores".

# Y para distintas distancias hay distintos metodos. Por ejemplo:

# Metodo de Ward.d, Ward.D^2 (más general), Single, Average, etc. 

?hclust

cluster <- hclust(dist(base, method = "euclidean"), 
                  method ="ward.D")

# Dendograma de clasificacion

cluster2 <- hclust(dist(base, method = "euclidean"), 
                   method ="average")

# Los dendogramas nos entregran los grupos y los subgrupos. 

par(mfrow=c(1,2))

plot(cluster,
     hang = -0.01,
     cex = 0.8)

plot(cluster2,
     hang = -0.01,
     cex = 0.8)

# A distintos metodos, distintas clasificaciones, aunque, aquellos valores que sean
# realmente significativos, se mantendran. 


# --- A que distancia se encuentran los elementos entre si?

distancia <- dist(base, method = "euclidean")

par(mfrow=c(1,1))

plot(distancia)

distancia

# Por ejemplo, la distancia entre PRODUBANCO y GUAYAQUIL es de 1.7625968
# mientras que es PICHINCA y PACIFICO es de 2.6042280. (distancias a partir
# de la matriz escalada. Mientras mas cercano a 0 los valores estan mas cerca)


# ¿ A que grupos pertenecen los elementos?

cluster$merge

# Los que nos indica esto, es que se sugieren 20 clusters, donde, en el cluster
# 1 estara el agente 3 y el agente 13, es decir, BP PICHINCHA y BP PROCREDIT, 
# tal y como el dendograma nos indica. Me demuestra como estan siendo conformados
# los clusters o ramificaciones. Pero necesitamos de manera mas sintetizada la agrupacion

# Realizando cortes 

cutree(cluster, k = 4)
# Le digo que me haga 4 divisiones, estos R calcula apartir del dendograma, segun el numero 
# que hayamos proporcionado.

# La lectura es sencilla, hay 4 clusters y cutree nos arroja en que cluster se encuentra
# cada agente. 

plot(cluster, hang = -0.01, cex = 0.8)
rect.hclust(cluster, k=4,
            border = "red")

# Entonces K = 4: me interesa saber como generar esos grupos

grupos <- as.data.frame(cutree(cluster, k =4 ))

# Ejemplo si quiere construir un indicador para bancos, segun ciertas variables y criterios
# que pueden clasificar por ejemplo, entre bancos chicos y bancos grandes (nuevas variables)

ncluster <- diana(base, metric = "euclidean")

# diana: DIvisive ANAlysis Clustering

par(mfrow=c(1,2))
plot(ncluster)

# Lo que nos muestra esto es el cluster jerarquico con una matriz euclidiana (la que propusimos)
# y otro grafico que muestra la division segun barplot.
# Lo que nos interesa saber es de divisive coefficient: el cual esta entre 0 y 1, (una clase de R^2) el
# cual deseamos que sea el más alto posible. (El consenso es que el valor sea mayor que 0.60).
# Este nos indica que tan bien clasificado entra nuestro modelo. 
# Aunque hay que tomar en cuenta que sigue siendo una funcion lineal creciente, asi que hay que ser precavidos.

cluster1 <- hcut(base, k=4,
                 stand = T,
                 hc_metric = "euclidean",
                 hc_method = "ward.D")
fviz_dend(cluster1,
          rect = T,
          cex = 0.5,
          k_colors = c("blue", "red", "orange", "brown"))

# Me ha dado los 4 clusters segun colores.

