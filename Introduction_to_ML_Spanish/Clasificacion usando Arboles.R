# Clasificacion usando arboles

# Supongase que usted tiene que diseñar un conjunto de reglas expresadas en un modelo
# econometrico o estadistico, de tal manera que permitan extraer perfiles de riesgos o 
# diseñar politicas para determinar ciertos perfiles o ciertas decisiones mas riesgosas. 
# o en su defecto, reglas que permiten identificar combinaciones que nos otorgen una 
# probabilidad alta o baja de fraude, en alguna transaccion o compra, o 
# inclusive la probabilidad de pago o no pago, por ejemplo. 

# Para esta clase de situaciones se puede hacer uso de modelos logisticos, como lo son los
# logit, probit o discriminante, sin embargo, para la construccion de reglas generalmente los arboles
# de clasificacion son un instrumento mucho mas eficiente porque le permite analizar atraves de todas 
# las ramas que van generando los arboles le permite analizar en que parte de las ramas se encuentran 
# los perfiles mas riesgosos, o aquellas que tienen mayor probabilidad de no pago.

# Hay 2 tipos de modelos de arboles (modelos no supervisados) 

# 1 - Arboles de clasificacion o modelos binarios o multinomiales -> Variables categoricas.
# El arbol tambien indica a las variables mas importantes para crear un modelo.


# 2 - Arbol de regresion. (Este puede ser comparado con una regresion multiple)
# La variable Y debe ser cuantitativa.

# ¿Porque se prefiere este tipo de tecnicas? Basicamente porque en la construccion de los arboles
# se tiene la posibilidad de ir desagregando aquella variable que esta en categorias, 

# rpart: Recursive Partitioning and Regression Trees
# Este algoritmo nos permite identificar segun el tipo de variable que tenemos.
# Si es un arbol de clasificacion o si es de regresion. 
# Para los arboles de clasificacion, el metodo sera Class, Y para la regresion el 
# metodo sera poisson, anova o exponencial. 



library(rpart) # Algoritmo CART
library(rpart.plot) # Grafica para arboles
library(caret) # para particionar la data y otros metodos de calculo.
library(foreign)
library(party) # Analisis no parametrico
library(partykit)
library(ROCR)
library(e1071)
library(dplyr)

file.choose()

data <- read.spss("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\arboles-20200720T210812Z-001\\arboles\\tree_credit.sav",
                  use.value.labels = F, to.data.frame = T)

names(data)

attach(data)

# Sembrar una semilla

# Antes de sembrar un arbol siempre se debe sembrar una semilla, recordemos que estos modelos
# son de aprendizaje automatico, por ello necesitan un valor de inicio o un valor de arranque, 
# la probabilidad de resulten los mismos valores, de 2 personas ingresan los mismos valores 
# de arranque en sus modelos, es mayor.

set.seed(1234) 
# Por simplicidad se pone 1234, y es lo que comunmente se hace.

# Ahora, tengo que particionar los datos en 2 conjuntos, el primer conjunto sera el conjunto
# de entrenamiento (generalmente un 70%) y el segundo conjunto es el de validacion. 
# el cual, generalmente es del 30%. 

# La idea es que para la muestra de entrenamiento, se construye el modelo, se lo valida, se pronostica
# y para la muestra de validacion, se compara con la de entrenamiento. (accuracy, matriz de clasificacion, 
# curvas ROC), es decir, se puede construir un modelo que trabaje bien en entrenamiento, pero tal vez no en
# validacion, y por ello, ese modelo no puede ser utilizado. Se espera que ese modelo trabaje inclusive mejor
# en validacion. 

unique(data$Valoración_credito)

# La variable que estudiaremos es class (binomial)

# Creando el modelo de entrenamiento

entrenamiento <- createDataPartition(data$Valoración_credito,
                                     p = 0.7,
                                     list = F)

m.entrenamiento <- rpart(Valoración_credito~ Edad+ordered(Ingresos)+
                           factor(Tarjetas_crédito)+
                           factor(Educación)+factor(Créditos_coche),
                         method ="class", data = data[entrenamiento,])

# rpart: Recursive Partitioning and Regression Trees

m.entrenamiento

# En primer lugar se arrojan los datos que ha trabajado el modelo, es decir,
# 1725. Y se esta dando el numero de nodos y el detalle de cada uno de ellos.
# es decir, me la un nodo principal (nodo raiz) de los cuales se desprenden los demas.
# En el nodo raiz nos arroja la probabilidad de que suceda 0 y de que suceda 1.
# Las cuales son 42.20 % y 57.79% respectivamenete. Y lo mismo para los demas casos
# por ejemplo, en nodo 2, la probabilidad de que ingreso sea igual a 1, existen 385 casos
# y la probabilidad de que esto suceda es de 83.63%.

# Debemos saber que, a pesar de que el algoritmo elige las variables mas representativas y 
# con ella(s) crea condiciones, tambien nosotros podriamos tener control sobre estas variables.

printcp(m.entrenamiento)

# Existen al menos 2 tipos de criterios para la construccion de estos arboles:

# El primero es que usted debe obtener el mismo error de validacion cruzada para diseñar el numero de nodos 
# a construir en el grafico. (más comun)

# El segundo es tomar el minimo error de validacion cruzada y tomar el valor anterior de la desviacion estandar
# correspondiente a la validacion cruzada, se suman estos valores. Por ejemplo:

0.47940+ 0.023065

# El resultado es 0.502465
# Se elegira el nodo inferior mas proximo a este valor como numero de nodos optimo, ejemplo:

# Nodos  xerror
# 3     0.55357 
# 4     0.48764

# En este caso el numero de nodos optimo seria 4, dado que es el nodo inferior proximo. 
# Ya que 3 sobrepasaria este valor. Aunque en este caso, donde solo se tienen 6 nodos como minimo
# no seria muy eficiente reducirlo, si bien lo que se quiere es que el modelo discrimine de la 
# mejor manera. 

plotcp(m.entrenamiento)

# La idea es tomar aquel valor que por debajo del error de validacion cruzada, en este caso 5 y 6
# serian los unicos casos, a este indicador se le conoce como el coste (error en validacion cruzada).
# a medida que el cp disminuye, el arbol sera mucho mas frondoso o mucho mas amplio. 

summary(m.entrenamiento)

# Graficando el arbol

setwd("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML")

# Aqui se guardaran los graficos.

plot(m.entrenamiento,
     uniform=T,main="")
text(m.entrenamiento, use.n = T,
     all = T, cex=0.8, pretty = 0)

# Guardando el grafico.

png(file="miarbol1.png",
    width = 840, height = 750)

plot(m.entrenamiento,
     uniform=T,main="")
text(m.entrenamiento, use.n = T,
     all = T, cex=0.8, pretty = 0)

dev.off() # Se recomienda escribir todo el codigo, con su dev.off
# que indica que ya se ha terminado de graficar y se guarda. Tambien
# se sugiere ejecutar todos los comandos al mismo tiempo. 

# Tuneando el grafico

# Creando funcion que cuente los casos
cuentacasos <- function(x, labs, digits, varlen)
{paste(labs,"\n\nn=", x$frame$n)}

# Graficando.

rpart.plot(m.entrenamiento,
           main = "Arbol de Clasificacion",
           shadow.col = "lightgreen",
           box.palette = "grey",
           cex = 1.2, tweak = 1,
           extra = 106, type = 2, under = F, 
           fallen.leaves = T, nn = T, node.fun=cuentacasos)

# El grafico se entiende muy facilmente, ejemplo de lectura:
# Si la probabilidad de ser 1 es mayor para los ingresos, ese
# sera el nodo raiz, y de ahi se desprenden condiciones que 
# pueden o no cumplirse. Ejemplo, en una de las condiciones
# si las tarjetas es igual a 2, tener un 3% de casos en donde la 
# probabilidad de que 0.62 y si la edad es menor de 24, la probabilidad
# de que me pague es del 4%. (62 personas se encuentran en este nodo).

# -- Podando el arbol

# Los arboles resultantes resultan siendo demasiado frondosos, eso hace que
# las reglas que usted construira segun el arbol sean muy extensas, por ello
# se debe hacer un tradeoff entre un arbol pequeño y uno frondoso. 
# (No es este caso, un arbol con 6 nodos se muestra como algo inclusive pequeño)

# Habiamos dicho que el xerror es el error de validacion cruzada, con eso
# tenemos 2 formas de podar un arbol, la primera ya mencionada, tomar el mininmo xerror
# y sumarlo con la desviacion anterior y elegir el numero de nodos inferior mas proximo. 
# la segunda forma es la mas comun y es unicamente tomar aquel numero de nodos donde el xerror
# sea el menor. (lo cual arroja el programa por default). En el primer caso, debe tomar su 
# numero de cp y se expresa la funcion de la siguiente manera:

printcp(m.entrenamiento)

poda <- prune(m.entrenamiento, cp=0.010000) 

# Le indicamos que el numero de nodos seria 4.

# Volvemos a graficar con el arbol ya podado.

rpart.plot(poda,
           main = "Arbol de Clasificacion",
           shadow.col = "lightgreen",
           box.palette = "grey",
           cex = 1.2, tweak = 1,
           extra = 106, type = 2, under = F, 
           fallen.leaves = T, nn = T, node.fun=cuentacasos)

# ------- Evaluando el modelo

# Se evalua a traves de la matriz de clasificacion. (debemos saber que tan bien esta clasificando)
# tasa de clasificacion vs tasa de aciertos

# Primero se debe hacer con la prueba de entrenamiento y despues con la de validacion.

ajustado <- predict(poda, data[entrenamiento,],
                    type = "class")

confusionMatrix(ajustado, data[entrenamiento,]$Valoración_credito)

# Me devuelve la prediccion y los valores reales. 
# Ejemplo: existen 512 donde la respuesta es 0 y el algoritmo acierta y 91 casos donde se equivoca
# ademas, existen 900 casos donde los valores reales son 1 y el modelo de entrenamiento acierta y 222 donde
# el modelo se equivoca

# Aqui tenemos un indicador muy importante (accuracy) y se espera que este sea cercano a 1. Una clase de R2.
# Se espera que sea lo mas alto posible (cercano a 1)
# Aunque por si mismo no se puede utilizar, dado que estamos ocupando solo la muestra de entrenamiento,
# por ello, se requiere medir este indicador (comparar) con el modelo el modelo que no contempla el entrenamiento 
# es decir, con el de validacion y con la muestra total. Si el modelo esta bien hecho se espera que el accuracy no 
# cambie o se mejore. 
# Tambien aqui se encuentran los conceptos de sensitividad (% de valores (de la variable de estudio, normalmente 1s) 
# correctamente clasificados relacionado al total de valores) y especificidad (porcentaje de 0's bien clasificados)
# Se arroja el porcentaje de clasificacion de los positivos y de los negativos, etc.

# De esta manera solo se obtiene la matriz de confusion.

table(data[entrenamiento,]$Valoración_credito,
      ajustado, dnn = c("Actual", "Ajustado"))


# Realizar fuera de la muestra de entrenamiento. (Validacion)


ajustado2 <- predict(poda, data[-entrenamiento,],
                    type = "class")

confusionMatrix(ajustado2, data$Valoración_credito[-entrenamiento])

# Cuando se pone [-entrenamiento] se refiere a los datos de validacion, es decir ese 30% que
# tambien se particiono fuera de la muestra obtenida.

# Verificamos el accuracy, si las diferencias son minimas no requiriremos podar o hacerlo mas frondoso.
# No todo en estos modelos es accuracy, se necesitan evaluar otros criterios, entre ellos la curva ROC.

# --- Curva ROC -----

# -------- Analisis de ROC y curvas de Sens-Spec para [Entrenamiento].

ajustado.train <- predict(poda,
                    data[entrenamiento,], type = "prob")

pred.train <- prediction(ajustado.train[,2],
                   data$Valoración_credito[entrenamiento])

perf.train <- performance(pred.train, measure = "tpr",
                    x.measure = "fpr")

# Curva ROC - Entrenamiento.

plot(perf.train, colorize=T, lty=3)
abline(0,1,col ="black")

# Curva de Sens-Spec - Entrenamiento. 

plot(performance(pred.train,
                 measure = "sens",
                 x.measure = "spec", 
                 colorize=T))


# ------- Analisis de ROC y curvas de Sens-Spec para [Validación].

ajustado <- predict(poda,
                    data[-entrenamiento,], type = "prob")

# Esto nos guardara los valores de probabilidad.

pred <- prediction(ajustado[,2],
                   data$Valoración_credito[-entrenamiento])

# Colocamos el 2, porque recordemos que aqui esperamos los 1.
# Es decir, se estila ser la variable en estudio, y se espera que existan menos errores en este grupo.

perf <- performance(pred, measure = "tpr",
                    x.measure = "fpr")

# Le pedimos el true positive rate y el false positive rate.

plot(perf, colorize=T, lty=3)
abline(0,1,col ="black")

# Esperamos que nuestra curva este lo más pegada posible al eje contrario 
# y alejado de la pendiente (linea) que indicamos. Esto indica que tan bien 
# discrimina y clasifica los tpr y los fpr.

# ------ Curva de Sensitividad y Especificidad.

plot(performance(pred,
                 measure = "sens",
                 x.measure = "spec", 
                 colorize=T))

# Contrario a la curva ROC esta curva necesito que este lo mas pegada posible a la curva derecha (contraria a la ROC)
# Y asi es como la sensitividad y la especificidad se maximizan. 
# NO deberia haber mucha diferencia entre la validacion y el entrenamiento.

# --- Calcular el area bajo la curva. 

# La idea es encontrar cuanta area queda completamente sobreada despues de la clasificacion de nuestro modelo.

# Area bajo la curva del Entrenamiento

auc1 <- performance(pred.train, measure = "auc")
auc1 <- auc1@y.values[[1]]
auc1

# El area bajo la curva del modelo de entrenamiento es de 0.8278758.

# Area bajo la curva de la Validacion.

auc2 <- performance(pred, measure = "auc")
auc2 <- auc2@y.values[[1]]
auc2

# El area bajo la curva del modelo de entrenamiento es de 0.81234543
# Lo cual, aunque no se espera que baje, el cambio es diminuto.

# --------- Pronosticos del Arbol de Decision. 

# Prediccion fuera de la muestra para evaluar nuestro modelo.
# Se puede hacer una prediccion para el conjunto de datos de entrenamiento y de validacion.

# Cuando se utilizan los modelos logit o probit, los coefs no son directamente interpretables, sino
# que se deben ocupar los efectos marginales o los odd ratios para tener una idea de interpretacion. 
# El caso es el mismo para los arboles de decision con los variables.importance:

poda$variable.importance

# Lo cual nos arroja coefs que no son directamente interpretables aunque existe un consenso
# acerca de su uso. En este caso lo podriamos leer de la siguiente manera:

# Podriamos inferir que la variable que más peso tiene es la de los ingresos (lo cual es acorde 
# un modelo que evalua si se paga o no se paga un credito), siendo el numero de creditos coche 
# la variable con menor peso. 

newdata <- data.frame(Edad=40,
                      Ingresos=1,
                      Tarjetas_crédito=2,
                      Educación=2,
                      Créditos_coche=1)

predict(poda, newdata)

#           0          1
#    0.9164087  0.08359133

# Un nuevo cliente, dadas estas caracteristicas, la probabilidad de que sea un
# es de 0.08 y la probabilidad de que sea mal pagador es de 0.91

# Conjunto de datos a evaluar (200 clientes) cargando la base, y nos dara el pronostico de 
# pago para cada cliente nuevo.

# Con este modelo me interesa obtener informacion de un nodo en particular para realizar 
# una campaña de colocacion de un productos a aquellos clientes que son considerados como 
# buenos pagadores, a partir de los resultados del arbol de clasificacion. 

# pasamos de rpart a partykit para obtener el conjunto de datos particular que buscamos

party.entrenamiento <- as.party(poda)

plot(party.entrenamiento)

# Este grafico me proporciona el arbol de distinta manera, en el formato party lo unico que cambia
# es el numero de nodo, pero son los mismos resultados y formas. 

# Aqui me doy cuenta que requiero del nodo numero 13 el cual contiene a los clientes pagadores.

party.entrenamiento$data <- model.frame(poda)
nodoespecifico <- data_party(party.entrenamiento, 13)

# Aqui recupero el data frame asociado a ese nodo de tal manera que usted podria utilizarlo para alguna campaña.
# Ejemplo, si son buenos clientes y estan proximos a finalizar su credito se les podria contactar para ofrecer nuevo producto.
