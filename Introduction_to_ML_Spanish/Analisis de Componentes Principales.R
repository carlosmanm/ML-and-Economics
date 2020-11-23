# Analisis de componentes principales 

# El analisis de componentes principales es un tecnica que se
# encasilla en la estadistica multivariante y sirve para
# reducir el numero de variables a utilizar en un modelo.

# Usted tiene 20 o 30 variables y las reduce a 3 o 4 componentes
# que contegan cierto nivel de varianza explicada (un 60 o 70%)

# Sirve como incentivo para crear modelos por ejemplo de regresion
# o un modelo tipo cluster. 

# 1. El analisis de componentes principales no responde a missing data
# por ello estos valores se debe borrar o interpolarizar.

# 2. El bloque de las variables X (matriz) esas variables deben estar 
# relacionadas entre si. Es decir, si se encuentran correlacionadas. 

# 3. Funciones para crear identicar los componentes principales

#---------- cargando librerias ---------#

library(psych)
library(corrplot)
library(openxlsx)

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\vab_industrias.xlsx")

data <-data[,2:19]

# --- Realizar un analisis de correlación --- #

cor(data)

correlacion <- cor(data)

corrplot(correlacion)

corrplot(correlacion, type = "lower")

# Mientras más azul son los puntos, mayor correlacion existe entre las variables


corrplot(correlacion, type = "lower", 
         tl.cex = 0.7,
         method = "pie")

# ------ Calcular el estadistico KMO

# La idea es el el KMO > 0.60 para concluir 
# es una buena idea utilizar este analisis y el analisis 
# factorial -> dicta si es bueno utilizar estas tecnicas

KMO(data)

# Overall MSA =  0.89

# Esto nos indica que es buena idea utilizar el analisis
# de componentes principales y reducir el numero de componentes

?KMO # Kaiser, Meyer, Olkin Measure of Sampling Adequacy

# ---------- Modelo de componentes principales --- #

mcp <- princomp(data, cor = T, scores = T)

summary(mcp)

# Obtenemos un analisis desagregado de cada compente que añade 
# la desviacion estandar (la cual es la que más utilizamos). 
# La primera compenente es aquella que se lleva la mayor parte de 
# la varianza, de hecho es Proportion of Varianza explica que esta 
# variable tan solo contiene el 87.19% de la varianza, el segundo 
# componente contiene el 6.08% de la varianza. Es decir si decidimos
# quedarnos tan solo con los primeros 2 componentes, estariamos
# trabajando con 2 variables que extraen el 93.27% de la varianza de 
# toda la base de datos. 

# ---- Cargas factoriales ---- #

loadings(mcp)

# Las cargas factoriales nos demuestran los coeficientes o los pesos 
# asociados a cada una de las variables. (los espacios en blanco, el peso
# es tan pequeño que no se muestran). Por ejemplo en la primera componente
# principal en la cual estan metidas las 18 variables, usted debe identificar
# que variable tiene más peso en este componente, es decir, aquellas que tengan
# un numero mayor dentro del componente. 

# ¿ Cuantas componentes debo mantener?

# Se recomienda utilizar aquellos componentes donde su valor propio sea mayor 
# a 1, y esto se encuentra en la varianza, por ende elevaremos al cuadrado la 
# desviacion estandar y analizaremos:

3.9616261* 3.9616261 # componente 1 -> 15.69448

1.04616523*1.04616523 # componente 2 -> 1.094462

0.72112278*0.72112278 # componente 3 -> 0.5200181

# Asi que aqui, segun la recomendaciones, nos quedariamos unicamente con los
# primeros 2 componentes. 

# Otra forma de analizarlo es mediante el screeplot

screeplot(mcp, type = "l")
abline(h=1)

# Tambien podemos trabajar con la libreria factoextra con un scree plot 
# mucho más detallado. Este grafico que nos otorga el analisis en varianza 
# y se muestra que solo los principales componentes serian los primeros 2. 

p1 <- fviz_eig(mcp, choice = c("variance"), addlabels = T)
p1

p2 <- fviz_eig(mcp, choice = c("eigenvalue"), addlabels = T)
p2 

# La diferencia es que p1 nos arroja los valores en varianza porcentual
# y p2 nosarroja los eigenvalues o valores propios en varianza, los cuales, 
# deben ser mayores a 1. 

View(mcp$scores)

# La idea es que en este nuevo data frame que se estructura en componentes, 
# tomamemos esos 2 primeros componentes seleccionados y trabajaremos con ellos. 

scores <- data.frame(mcp$scores)

nueva_data <- scores[,1:2]
