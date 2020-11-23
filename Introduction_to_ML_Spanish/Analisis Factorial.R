# Analisis Factorial

# Es una tecnica de la estadistica multivariante y permite agrupar a traves de 
# factores las variables de una base, pero con la diferencia, en detrimento con 
# en analisis de componentes principales, que tambien es una tecnica de reduccion, 
# lo que hace el analisis factorial es encontra variables latentes inobservables 
# que pueden ser nombradas, a traves de los factores reducidos. Esta tecnica trabaja
# con la maxima verosimilitud por lo cual se requiere mucha data. 

# y de esta manera ponerle nombre a los factores, por ejemplo: gustos y preferencias,
# caracteristicas de un producto, entre otros. 

# Ejemplo de como se aplica el analisis factorial: Determinar caracteristicas
# un candidado presidencial, o caracteristicas de un nuevo producto. Problematicas 
# que no se cuantifican en una base de datos. 

# Lo que es factor seria el equivalente a componente en el analisis de componentes
# principales, dado que busca asociar variables a factores o caracteristicas que
# engloben distintos aspectos. 

# Se espera que las variables esten correlacionadas entre si, se trata de una tecnica
# de interdependencia (correlacion) y no de dependencia (correlacion) y al igual
# se ocupa como insumo para modelos de tipo de regresion o cluster. 
# Se puede utilizar el estadistico KMO.

# Se espera que las variables sean cuantitativas o por lo menos dicotomicas mayores 
# a 4 opciones. Es decir, multinomiales. 
 
# En componentes principales, la varianza de las variables se explica por las variables cuya
# combinacion lineal las determina, y en analisis factorial solo parte de la varianza de cada 
# variable original se explica completamente por las variables cuya combinacion lineal las 
# determinan. Es decir:
# La varianza estara compuesta por 2 compenentes, llamado Comunalidad y Unicidad. 
# La varianza estara explicada en una parte por las demas factores que la determinan,
# a esto se le conoce como Comunalidad, por otro lado esa parte de la varianza que no se explica 
# por los factores comunes se le conoce como Unicidad o Especificidad. 
# La suma de Comunalidad y Unicidad es 1, pero si por si sola Comunalidad es 1, el analisis de 
# componentes principales coincide con el analisis factorial. Por ende el analisis de componentes 
# principales es un caso especial, del analisis factorial. 

# A veces resulta complicado clasificar en factores ciertas variables, por tal motivo hay que 
# utilizar metodos de rotacion factorial. En las cargas factoriales cuando los pesos son muy
# parecidos entre si, y casi no se distingue una diferencia, se estila realizar una rotacion factorial.
# Entre estas:

# Varimax: obtiene los ejes de los factores maximizando la suma de las varianzas de las cargas
# factoriales al cuadrado dentro de cada factor.

# Quartimax: se consigue que muchas varibles tengan pesos grandes en el mismo factor y es 
# aconsejable si se cree que un solo factor explica toda la varianza. 

# Oblicua: Mediante la rotacion oblicua rotamos los factores de modo que estos esten correlacionados.

# Se retiene el numero de factores en funcion:

# Grafico de sedimentacion
# Valores propios mayores que 1.
# % de la varianza para ACP. 

library(magrittr)
library(foreign)
library(openxlsx)
library(psych)
library(GPArotation)
library(factoextra)

file.choose()


data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\dientes.xlsx")

data %>%
  View()
data <- data[,2:7]
attach(data)

# ----- criterio del Analisis Factorial por KMO ---- 

KMO(data)

# Overall MSA =  0.66
# No es el mejor, pero si es > 60.

# El analisis de componentes principales es previo al factorial para determinar 
# los grados de comunalidad y unicididad.

# ----- Analisis de componentes principales -----

?princomp
mcp <- princomp(data, scores = T,
                cor = F) # con cor = F, se especifica que no utilice el coeificente
# de correlacion, sino con el de covarianza dado que son variables cualitativas.

summary(mcp)

p1 <- fviz_eig(mcp, choice = c("eigenvalue"), addlabels = T)
p1

# Solo estariamos reteniendo los primeros 2 componentes.

# ----- Analizar los factores -------

?factanal
mf <- factanal(data, factors = 2,
               rotation = "none")
mf

# Aqui tenemos 1, los uniquenesses que son los valores de unicidad
# y los loadings o cargas factoriales que son los valores de comunalidad.
# Los espacios en blanco denotan que la carga es muy pequeña y se omite. 
# Enfocandose en las cargas factoriales, el criterio es el siguiente: 
# se tiene que clasificar aquellas variables en los factores correspondientes,
# en donde, se tenga un mayor peso en terminos absolutos, ejemplo:

#    Factor1 Factor2
# V1  0.968         
# V2          0.745 
# V3  0.904         
# V4 -0.123   0.779 
# V5 -0.882  -0.132 
# V6          0.831 

# Por ejemplo V5 en claro que estara clasificada en el primer factor. 
# mientras que V4 estara clasificada en el factor 2. 
# Pero cuando esta disticion no sea clara, se podra realizar la rotacion. 

mf2 <- factanal(data, factors = 2,
               rotation = "varimax")
mf2

# Se distingue la misma clasificación, aunque de manera más clara. 
# se muestran resultados similares ya que las diferencias ya eran claras
# normalmente se estila ocupar una rotacion cuando las variables estan muy 
# correlacionadas y la clasificacion se complica. Ejemplo:

#    Factor 1  Factor 2 
# v2   0.8765   0.8127

# ¿Donde se clasifica? estrictamente en el factor 1, pero para no generar dudas
# es un buena idea hacer rotacion factorial, donde las diferencias se hacen mas claras.


# Una vez clasificado donde se encuentran las variables, 

# ---- darle nombre a los factores -------

# El factor 1 tiene las variables v1, v3, v5.
# El factor 2 tiene las variables v2, v4, v6.

# La combinacion del factor 1 hace referencia a las variables
# que comprenden la salud, por ello sera factor salud.

# Por su parte el factor 2 sera el factor estetica. 

# Nota: Es importante saber que factanal solo permite hacer rotaciones
# por varimax, por lo cual se puede realizar, mediante la libreria pysch
# la formulacion del modelo factorial de la siguiente manera:

?fa
mf3 <- fa(data, nfactors =2, 
          rotate = "oblimin")

loadings(mf3)

weights(mf3) # Con los pesos tambien se puede 
# identificar las variables que mayor incidencia tienen dentro del factor.

# Y esto tambien se puede identificar con un grafico.

par(mfrow=c(1,2))

barplot(mf3$weights[,"MR1"], 
        las = 2,
        cex.names = 0.6, main = "Factor 1",
        xlab = "Variables", ylab = "Carga de los factores")

barplot(mf3$weights[,"MR2"], 
        las = 2,
        cex.names = 0.6, main = "Factor 2",
        xlab = "Variables", ylab = "Carga de los factores")

