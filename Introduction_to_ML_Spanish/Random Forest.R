# Random Forest

# El bosque es un conjunto de arboles de decision, es decir,
# se trabaja con varios (inclusive cientos) arboles independientes entre si los cuales
# se promedian los arboles y se obtiene un valor, la varianza se va minimizando 
# (suponiendo que los arboles no estan correlacionados entre si)

# Ojo: si los arboles estan muy correlacionados, debido a que exista un predictor que 
# sea muy influyente o contenga mucha presencia varias veces en los distintos arboles, 
# no termina siendo muy practico este algoritmo.

# El bosque, a la hora seleccionar los predictores, los bosques aleatorios abordan el problema
# de correlacion, es decir, va tomando de forma aleatoria cada uno de los predictores y se les enfrenta
# a distintos criterios como , hace un 
# muestreo aletorio, obteniendo ciertos criterios que se conocen como los hiperparametros, tratando de 
# evitar la correlacion entre los arboles. 

# Esta es una de las tecnica mas potentes y computacionalmente costosa 

# Vamos a trabajar tan solo el % de una base. (debido al costo computacional)
# Estos modelos trabajan con Big Data. Por ejemplo si se tomara el 70% para un computador 3icore y 8 RAM, 
# El software procesara el info en por lo menos 2 horas y media, por lo que se recomienda ser cauteloso.

# En este caso solo tomaremos el 1% debido al tiempo de la tutoria, se le estaria exigiendo demasiado al computador.

# Algunos criterios del Random Forest

# * Numero de predictores 
# Normalmente se escoge (p-m)/p numero de divisiones. 

# * Como hay mucho arboles dentro del bosque, se debe elegir, si son modelo de regresion p/3 (p = predictores), ejemplo,
# si usted tiene 9 predictores (independientes del modelo), y este numero se divide entre 3, quedando unicamente p=3, estos se
# deben elegir y con base en estos 3 predictores para cada uno de los arboles.
# Esto viene por defecto.

# * Si son modelos de clasificacion, no va a tener el numero de predictores con p/3 sino raiz(p) y ese sera el no. de predictores.
# Esto viene por defecto.

# Existen 4 criterios para construir 1 random forest

# 1. mtry: numero de predictores obtenidos de forma aleatoria para cada arbol. 
# 2. min.node.size = el tamaño minimo que debe de tener cada nodo en cada arbol para ser dividido.
# 3. splitrule: criterio de division. (criterio de GINI)
# 4. El numero de arboles creados. 

# 1,2 y 4. Se pueden optimizar (existen varias formas de optimizar los hiperparametros)

# Hiperparametros (mtry, numero de divisiones y numero de arboles)

# 4. Normalmente se da un numero sencillo entre 300-500 arboles
# Para mtry y numero de divisiones es más complicado ya que se debe realizar el proceso de validacion cruzada.

# Primero se debe encontrar el primer lugar el numero de predictores optimos (mtry) y luego encontrar el numero de divisiones optimas
# y luego encontrar un punto donde se estabilice el algoritmo en funcion del numero de arboles que se calculen. 

# Si bien es un tecnica de bootstramping (remuestreo) y el cross validation, al final si el modelo esta bien hecho no importara
# el numero de arboles a usar ya que algoritmo convergera en un numero optimo. Y al final todo lo que este por encima o por debajo los valores
# seran muy similares.

# Por ello el calculo de los hiperparametros de mtry y numero de divisiones es más importante.

# Aunque no hay que olvidar que esta es una forma, es decir es una tecnica, no necesariamente se sigue esa secuencia dado que se trata de hiperparametros
# que conviven entre si y que dependen de si, por lo que a diferentes numeros distintas combinaciones. Es decir, se asume una relacion "lineal" entre los hiperparametros.

# Una forma más sencilla es usando en conjunto la libreria CARET y RandomForest atraves de la funcion 
# RANGER. Donde por cross validation se puede obtener el optimo de 1 y 2, lo cual es lo que nos interesa.
# Suponiendo que se pueden utilizar hasta 500 arboles. (numero generalmente utilizado para la obtencion de 
# resultados preliminares)

# mtry 

# numero de divisiones 

# numero de arboles (esto ya se tiene y sera de forma preliminar 500 arboles)

# Estamos ante la presencia de 500 arboles los cuales se calcularan 1 por 1 y seran ejecutados en funcion de 
# los hiperparametros mtry y numero de divisiones.

# Supongase que se tiene 10 variables entonces si es un arbol de clasificacion, la regla por default
# es raiz(10) pero ya sabe que se puede modificar esto, encontrando su optimo.

# No podemos olvidar el coste computacional y saber hasta donde llegan las capacidades de nuestros computadores, 
# por ejemplo, si se tienen 500 arboles, con 10 divisiones cada uno, y 5 predictores y DESPUES se añade a esto 
# los conceptos de validacion cruzada, es decir, en donde hay muestreos repetitivos y las particiones. 
# Por esto se aconseja tomar muestras chicas para ver que el modelo funcione, dado que de no hacerlo puede tomar demasiado tiempo.

# Nota: Dado lo anteriormente dicho, no es comun la graficacion. 
# Nota 2: Para hacer la prediccion es necesario para el modelo a tipo randomforest y conservar los
# resultados en keep.forest = TRUE.


# -------- Tratamiento previo de los Random Forest:

# Cargando librerias

library(foreign)
library(dplyr)
library(caret)
library(ROCR)
library(randomForest)
library(e1071)

# Cargando base de datos (encuesta de los nacidos vivos)

data <- read.spss("/Users/Lenovo/Documents/R/Proyectos/Betametrica/Machine Learning/Bases de datos ML/ENCUESTA NACIDOS VIVOS-20200720T210721Z-001/ENCUESTA NACIDOS VIVOS/ENV_2017.sav",
                  use.value.labels = T, to.data.frame = T)

data$peso <- as.numeric(data$peso)
data$edad_mad <- as.numeric(data$edad_mad) 
data$con_pren <- as.numeric(data$con_pren)
data$sem_gest <- as.numeric(data$sem_gest)

# Son 308K observaciones, los cuales partiocinaremos.

# Objetivo: determinar la probabilidad de que un niño nazca con un peso adecuado (x > 2.5K según la OMS).

# Nota: el peso se expresa en gramos.

histogram(data$peso)  

# Limpiar data 

summary(data$peso)

# La data se debe analizar antes para limpiarla y evitar la mayor parte de los errores.

# Depurando la data

nuevadata <- data %>%
  filter(prov_res=="Guayas") %>%
  select(peso,talla, sem_gest, sexo, edad_mad,
         sabe_leer, con_pren, est_civil) %>%
  filter(peso!=99, peso > 500, talla!=99,
         sem_gest!=99, con_pren!=99,
         est_civil!="Sin información", 
         talla!="Sin información")

histogram(nuevadata$peso)

summary(nuevadata$peso)

# Hora de categorizar la variable objetivo en 1s y 0s,
# es decir, es 1 si nace con un peso adecuado, 0 con un peso inadecuado.

# De la misma forma se categorizara de distinta manera.

nuevadata <- nuevadata %>%
  mutate(peso=if_else(peso > 2500, 1, 0),
         sexo=if_else(sexo=="Hombre", 1, 0),
         sabe_leer=if_else(sabe_leer=="Si", 1, 0),
         edad2 = edad_mad^2,
         con_pren=if_else(con_pren >= 7, 1, 0))

# Ya que tenemos la base podemos empezar a crear el modelo.

# Nota: para poder conocer el numero de nucleos logicos que su computador tiene, puede usar 
# las siguientes funciones de la libreria parallel.

num_cores <- detectCores()

num_cores

# Se tienen 4 nucleos logicos. 

# ----- crear nuestro modelo de random forest

## Advertencia ## 

# No cambiar el $ de particion de datos utilizados en este ejercicio
# a no ser que tenga un computadora los suficientemente robusta para los calculos.
# ademas de tener tiempo para esperar convergencia.

# Se cargaran 2 librerias diseñadas para utilizar todo el potencial de la computadora
# para que el algoritmo converga de la mejor manera.

library(ranger)
library(doMC)

registerDoMC(cores = 4)

nuevadata$peso <- factor(nuevadata$peso)

# Creamos la muestra de entrenamiento, con pequeña data.
# se debe primero probar con poca data para ver si el algoritmo converge
# claramente se debe seguir poniendo 0.7, sin embargo, para ello se requieren horas
# en las cuales podria resultar que el algoritmo no convergio debido a un problema que 
# nos pudimos ahorrar haciendo la prueba con poca data.

entrenamiento <- createDataPartition(nuevadata$peso,
                                     p=0.01,
                                     list = F)

# Escribiendo particiones, repeticiones para los hiperparametros.

particiones <- 10

repeticiones <- 5

hiperparametros <- expand.grid(mtry =c(2,3,4),
                               min.node.size=c(2, 3, 4, 5, 10, 15, 20, 30),
                               splitrule="gini")

# Con esto que acabamos de indicar, el algoritmo empezara a jugar con valores utilizando el criterio gini

# Colocar una semilla.

set.seed(1234)

seeds <- vector(mode="list", length = c(particiones*repeticiones)+1)
for (i in 1:(particiones*repeticiones)) {
  seeds[[i]] <- sample.int(1000, nrow((hiperparametros)))
}

seeds[[(particiones*repeticiones)+1]] <- sample.int(1000, 1)

# -- Definiendo el modelo de entrenamiento:

control_train <- trainControl(method = "repeatedcv", 
                              number = particiones,
                              repeats = repeticiones,
                              seeds = seeds, returnResamp = "final",
                              verboseIter = F, allowParallel = T)
# --- Calculando el modelo:

modelorandomforest <- train(peso~talla+factor(sexo)+
                              edad_mad+edad2+factor(sabe_leer)+
                              factor(est_civil), data = nuevadata[entrenamiento,],
                            method="ranger", tuneGrid=hiperparametros, metric ="Accuracy",
                            trControl = control_train,
                            # numero de arboles ajustados,
                            num.trees=500)
modelorandomforest

# Nos muestra el numero de variables que el modelo tomo, tambien indica 6 variables predictoras
# 2 clases para la variable objetivo clasifica 0s y 1s. 
# El numero de particiones (clusters) y reparticiones que hemos indicado, esto en cross validation. 

# Se calcula el accuracy segun distintas combinacion. 
# Y el de mejor accuracy es el mtry = 3 y el min.node.size de 30 por ejemplo.

modelorandomforest$finalModel

# Este comando me muestra el modelo con el que se quedo, de 500 arboles, 765 obs, 2 predictores,
# el tamaño de cada nodo seria de 30 y el prediction error (debe ser lo más pequeño posible), con
# los 500 arboles que indicamos. 
# Tambien podemos graficar esto para verlo de una manera distinta.

ggplot(modelorandomforest, highlight = T)+
  scale_x_continuous(breaks = 1:30)+
  labs(title = "Accuracy del modelo Random Forest")+
  guides(color = guide_legend(title = "mtry"),
         shape=guide_legend(title = "mtry"))+
  theme_bw()

# Este grafico me arroja lineas en un grafico que representan el numero
# de predictores vs el minimal node size, buscando en el eje y el accuracy más alto.

# --- Revisando resultados y generando pronosticos:

# Pasar de Validacion Cruzada a Random Forest

set.seed(1234)

modelo_randomforest <- randomForest(peso~talla+
                                      sem_gest+sexo+edad_mad+edad2+
                                      sabe_leer+est_civil, data = nuevadata[entrenamiento,],
                                    mtry = 2, ntree = 500, importance =T, nodesize=2,
                                    norm.votes = T, keep.forest = T)
# Este ya es el modelo random forest

modelo_randomforest

# El error rate es de 3.94. Y me viene la matriz de confusion, donde los errores son sumamente minimos.

varImpPlot(modelo_randomforest)

# Los resultados me indican que talla y edad son las variables
# de mayor importancia en el modelo.

# Estas variables son las que mayor peso tendran en los pronosticos.

# --- Pronostico con Random Forest:

newdata <- head(nuevadata, 10)

predict(modelo_randomforest, newdata, predict.all = T)

#  1  2  3  4  5  6  7  8  9 10 
#  0  0  0  0  0  0  0  0  0  0 

# Segun este modelo, y las caracteristicas de estas 10 personas, 
# es que el bebe nazca con un peso menor a los 2500 gramos.
# Nota: en este caso no se trabajo con validacion [-entrenamiento], 
# porque recordemos que particionamos la data en un 0.01%, cuando deberia ser
# 0.7, sin embargo, la validacion tomaria el analisis de 0.99 lo cual tardaria 
# seguramente horas, por lo cual no se realizo. Aunque en un modelo que se pretende 
# trabajar, este proceso SI se debe realizar.


