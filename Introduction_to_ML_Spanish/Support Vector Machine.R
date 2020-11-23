# Support Vector Machine

# Requerimientos previos: Algebra Lineal, Optimizacion lineal y cuadratica y Estadistica Multivariada.
# (Conocimientos solidos)

# El modelo se puede extender desde regresiones y clasificaciones (binomiales y multinomiales) 

# Se le conoce como un metodo controversial debido a que los econometristas comentan que 
# esta clase de modelos no encuentran relaciones causales atraves de los predictores que se esten utilizando
# sino que exprime la informacion, para que dicha informacion le proporcione informacion que no es recogida 
# atraves de las variables de forma directa, en otras palabras, estos modelos son de data mining, que explotan 
# la informacion existente en la muestra, pero de ninguna manera tiene un componente causal, no podemos demostrar causalidad.

# Esto hace que, las interpretaciones, por ejemplo en regresion no sean directamente interpretables, como en regresion
# lineal multiple. Inclusive en los modelo microeconometricos hay maneras de interpretar ciertos datos, en SVM las cosas se complican.

# Modelo SVM

# Se basan en un concepto de hiperplano. Un hiperplano se lo define como un espacio de dimensiones p-1
# Es decir, una recta que divida y clasifique a los grupos. 
# Un hiperplano separador debe pasar por lo puntos de tal forma que maximice la distancia entre el hiperplano
# y las observaciones a clasificar. Si este hiperplano llega a existir, se le conoce como hiperplano maximizador
# del margen (maximo margen).

# Pueden existir varios hiperplanos separadores, pero habra uno que maximiza.
# La distancia d+, más d-, se le conoce como corredor o pasillo. 
# Los hiperplanos frontera pasan por ciertos puntos. 
# Son vectores de soporte aquellos puntos que toman con las fronteras.
# W es el vector perpendicular al hiperplano. 

# Entonces existen las fronteras positivas y negativas (margen), un hiperplano separador que maximiza 
# los margenes y ademas de los vectores de soporte. 

# El problema se puede ir orientando por la maximizacion de dicho margen que discrimina de mejor manera. 
# Entonces si la idea es maximizar M (margen), tambien se debe minimizar la funcion de w (vector perpendicular)

# Este algoritmo depende del tamaño muestral, por lo que a mayor tamaño muestral, mayor eficiencia pero 
# se requira más carga computacional.

# Esto funciona en un mundo idealizado, es un mundo utopico donde los datos se diferencian de manera muy clara
# y puede existir una clara diferenciacion lineal.

# Comunmente NO hay linealidad, comunmente se recurre al problema de overlapping (superposicion), esto quiere decir que habra
# en algunos casos, datos que se traslapan en una clase que no corresponder a la clasificacion que corresponde. 

# Cuando se cae en este problema, deja de cumplirse la clasificacion perfecta en las maquinas de soporte.
# Con el fin de abordar ese problema y minimizar dicho error (que dicho lo anterior SIEMPRE se tendra).
# Se espera un tradeoff entre el sesgo (vias) y la varianza. Este se le conoce como el Costo Computacional (C). 
# Se busca un C pequeño, para experimentar menores tasas de errores y mayores vectores de soporte.

# Iremos encontrar el valor de C durante la validacion cruzada. 

# Tanto la minimizacion como la expresion del coste y su relacion se expresa mediante lagrangianos
# (por ello la importancia de la optimizacion, "Problema Dual de Wolfe"). Las expresiones no son resueltas de 
# manera automatica sino que tendremos que trabajar y establecer ciertas condiciones.

# Se complica el asunto cuando no todo es perfectamente separable, por ello debemos apalancarnos de los errores que
# pudieran cometer los modelos, o que la data tenga algun tipo de problema de overlapping, entonces a traves de los 
# multiplicadores lagrangianos, se expresa un problema dual de Wolfe y finalmente se realiza la estimacion de la maquina 
# de soporte lineal a traves de ciertas funciones conocidas como Kernels. 

# Kernels es una funcion que devuelve el resultado del producto escalar de 2 vectores realizando en un nuevo espacio 
# dimensional distinto al original en el que se encuentras los vectores.

# Las funciones originales contienen productos escalares que pueden ser reemplazados por cualquier Kernel.

# Es decir las funciones a traves del problema dual, pueden ser reemplazadas atraves de distintos Kernel.
# Normalmente los Kernel que se utilizan son los Lineales, Polinomiales y Radiales. 

# Usualmente se reemplaza con los Kernel Lineales, pero cuando nuestra data no se ajuste o 
# no pueda ser linealmente separable, cuando suceda eso se debe recurrir a los otros tipos de Kernel.

# Condiciones de los Kernel

# Polinomial:

# Si d=1 y c = 0, el resultado es un Kernel Lineal
# Si d>1, se generan limites de decision no lineales
# No se recomienda usar una "d" muy grande (problemas de overfitting)
# Se debe considerar que, para el calculo de los parametros influye el tamaño muestral, el numero de 
# predictores y el grado del polinomio.

# Radial (tambien conocido como Kernel Gaussiano):

# Aqui tenemos el parametro Gamma que controla el comportamiento del Kernel. Si es muy pequeño, se aproxima
# a un Kernel lineal.
# Es un hiperparametro que puede ser optimizado a traves de la cross validation.
# Si es muy grande, podria productir overfitting
# Generalmente se recomienda usar este kernel como punto de partida.
# Debido a que usted es capaz de controlar el Costo y el Gamma (tal vez pequeño que se parezca al lineal).

# -------- Flujo de trabajo para el modelamiento de un SVM ---------

library(foreign)
library(caret)
library(ROCR)
library(dplyr)
library(reshape2)
library(pROC)
library(e1071) 

# e1071: Libreria de SVM.

## Flujo de trabajo natural para SVM:

# 1. Cargar base de datos.
# 2. Depurar base de datos.
# 3. Separar la data de entrenamiento y la de validacion
# 4. Estimar el modelo
# 5. Tunear el modelo
# 6. Evaluar la data de entrenamiento:
# (matrices de clasificacion, curvas ROC y sens-spec, puntos de corte, 
#  predicciones dentro y fuera de la muestra (más importante)).
# 7. Evaluar el modelo con la data de validacion. 
# Matriz de confusion, ROC, sens-spec, punto de corte y prediccion dentro y fuera de la muestra.
# Ademas, cambiar el punto de corte y generar matriz de predicciones con los nuevos puntos.

# Esto funciona considerando que la data esta balanceada de forma correcta. (no más 1s que 0s o viceversa)
# Esto genera el problema de overfitting, ya que dados los pesos, buscara clasificar más los 1s cuando sean
# 1s que los 0s cuando sean 0s.
# Para abordar este problema existen Extensiones, las cuales son:

# * Evaluar implicancias del modelo con un remuestreo (Bootstrapping desproporcional.
# Y con estos remuestreos cambian las evaluaciones del modelo? El remuestreo tiene como objetivo 
# darle mayor robustez a nuestros resultados.

# * Comparar con otros modelos binarios (tal vez un Logit o un LDA)

# * Comparar con otros Kernels.


# -------- Estimacion de un modelo SVM ---------

file.choose()

data <- read.spss("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\ENCUESTA NACIDOS VIVOS-20200720T210721Z-001\\ENCUESTA NACIDOS VIVOS\\ENV_2017.sav",
                  use.value.labels = F,
                  to.data.frame = T)

# ---- Vamos a depurar la informacion. 

data$prov_nac <- as.numeric(as.character(data$prov_nac))

hist(data$peso)

# Filtramos la data

nuevadata <- data %>%
  filter(prov_nac==7)%>%
  select(peso, talla, sem_gest, sexo,
         edad_mad, sabe_leer, con_pren)%>%
  filter(peso!=99, talla!=99,
         sem_gest!=99, con_pren!=99, 
         sabe_leer!=9,talla!="Sin información")

# Categorizamos la data

nuevadata <- nuevadata %>%
  mutate(peso=if_else(peso > 2500, 1, 0),
         sexo=if_else(sexo=="Hombre", 1, 0),
         sabe_leer=if_else(sabe_leer=="Si", 1, 0),
         edad2 = edad_mad^2,
         con_pren=if_else(con_pren >= 7, 1, 0))

# Modificar la variable objetivo (opcional)

nuevadata$peso <- factor(nuevadata$peso)

nuevadata <- nuevadata %>%
  mutate(peso=recode_factor(
    peso, '0' = "no_adecuado",
    '1' = "adecuado"))

table(nuevadata$peso) 

# Fijar una semilla

# Una semilla aleatoria es un número (o vector) utilizado para inicializar 
# un generador de números pseudoaleatorios

set.seed(1234)

# Crear una muestra de entrenamiento (debe ser del 0.7 pero por practicidad
# y tiempo se utilizara el 0.05 por ciento de la data)

entrenamiento <- createDataPartition(nuevadata$peso,
                                     p=0.05,
                                     list = F)

# Realizamos el modelo de SVM con la muestra de [Entrenamiento]

model.train <- svm(peso~talla+sem_gest+sexo+
                     edad_mad+edad2+sabe_leer,
                   data = nuevadata[entrenamiento,],
                   kernel="linear", scale = T, cost = 10,
                   probability = T)

# Es importante escalar la base dado el optimo tiempo de calculo y respuesta
# Estamos dando un costo arbitario igual a 10 (por default es 1), aunque es atraves de la validacion
# cruzada como sabremos cual es el optimo. 


# ¿Como recupero los vectores de soporte? 
# Con el objeto Index del modelo.

model.train$index

# ¿Como recupero el termino independiente?
# Con el objeto Rho.
model.train$rho

# ¿Como recupero los coefs que se usan para multiplicar cada 
# observacion y obtener el vector perpendicular al plano (W)?
# Con el objeto coefs.

model.train$coefs

# Evaluar si el modelo funciona con ese costo arbitrario y de no hacerlo, buscar el optimo.

# ------ Validacion y Evaluacion de mi modelo SVM -----------

# Por defecto se clasifica con un punto de corte de 0.5.

ajustados <- predict(model.train,
                     nuevadata[entrenamiento,],
                     type="prob")

# Matriz de confusion: Forma Larga

ct <- table(nuevadata[entrenamiento,]$peso,
            ajustados, dnn = c("Actual", "Predicho"))

diag(prop.table(ct,1))
sum(diag(prop.table(ct))) # % de clasificacion correcta global.

# no_adecuado  adecuado 
# 0.6730769   0.9466667

# Se espera de esta forma dado que tenemos más datos de clase numero 1
# ademas de que es nuestra variable objetivo.

# Matriz de confusion: Forma Corta con Libreria ROCR.

confusionMatrix(nuevadata$peso[entrenamiento],
                ajustados, dnn = c("Actual", "Predicho"),
                levels(ajustados)[2]) 
# Con leves(ajustados)[2] Le pedimos que utilice como clase de referencia el "adecuado"
# es decir, el evento objetivo. De poner 1, el evento objeto seria "no adecuado"

#                Predicho
# Actual        no_adecuado adecuado
# no_adecuado          35       17
# adecuado             32      568

# Accuracy : 0.9248
# Sensitivity : 0.9709 
# Specificity : 0.5224
# Pos Pred Value : 0.9467          
# Neg Pred Value : 0.6731

# Debemos estas consientes de una disparidad (overfitting) en el modelo, por lo cual
# no podemos dejarnos engañar por dichos resultados, ademas, se espera que estos mejoren
# en el proceso de validacion. 

# ---- Graficar discriminacion entre variables del modelo 

plot(model.train,
     data=nuevadata[entrenamiento,],
     talla~edad_mad)

# Se observa el hiperplano separador segun la variable objetivo.
# (Solo trabaja para variables cuantitativas y NO categoricas)

#  ------- Optimizando los hiperparametros del modelo SVM (Tunear el modelo)

model.tun <- tune(svm,
                  peso~.,data = nuevadata[entrenamiento,],
                  ranges = list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 50 )),
                  kernel = "linear", scale = T, probability = T)

# Evaluara en este rango el costo optimizado.
# Centramos y normalizamos la base con escalado.
# Importantisimo que nos devuelva las probabilidades con las que evaluamos las curvas ROC 
# la matriz de confusion, etc.


summary(model.tun)

# Se ha hecho un remuestreo a traves de 10 folios.
# - best parameters: cost 1 -> nos indica que el mejor costo es el de 1.
# Se entiende como optimo el modelo que proporcione el menor error.

ggplot(data = model.tun$performances,
       aes(x=cost, y=error))+
  geom_line()+
  geom_point()+
  labs(title = "Error de Validación vs Hiperparametro C")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))

# En el grafico podemos ver como el menor error se ve en el cost numero 1. 

# --- Estimando el modelo más optimo.

# Es sumamente eficiente esta libreria, dado que inclusive me arroja el mejor 
# modelo posible. Ejemplo:

model.tun$best.model

# Me arroja que el mejor modelo es:

# Parameters:
# SVM-Type:  C-classification 
# SVM-Kernel:  linear -----> el Kernel Lineal
# cost:  1 --->      costo de 1. 
# Number of Support Vectors:  87

best.model <- model.tun$best.model

summary(best.model)

plot(best.model, data = nuevadata[entrenamiento,],
     talla~sem_gest)

# Podemos ver como esta clasificando de una manera muy correcta.

# ---- Evaluando el modelo SVM optimizado -----

# Una vez optimizados los parametros de nuestro modelo debemos validar el SVM optimizado.

fitted.best.model <- predict(best.model,
                             nuevadata[entrenamiento,],
                             type = "prob",
                             probability = T)

# Siempre debemos expresar en terminos de probabilidad, al final del dia 
# lo que interesa es la probabilidad de clasificacion. 

# Debemos verificar como capturar las probabilidades.

head(attr(fitted.best.model, "probabilities"), 5)

# Hacemos un head para ver cual es el numero de clase correspondiente a la clase objetivo.
# En este caso es la clase numero 1. 
# Es decir, es importante verificar cual es la primera variable que arroja el modelo tuneado. 
# No podemos asumir que siga apuntando al mismo vector. En este caso si lo hace, pero debe corroborarse.

# Ahora, evaluaremos mediante Matriz de Confusion

levels(fitted.best.model)


table(attr(fitted.best.model, "probabilities")[,1]> 0.5,
      nuevadata$peso[entrenamiento])

#         no_adecuado adecuado
# FALSE          22        5
# TRUE           30      595

# La libreria caret ofrece el confusion matrix auto.

levels(nuevadata$peso)

# "no_adecuado" "adecuado" -> en mi data la posicion del evento objetivo es 2
# sin embargo, en mi modelo optimizado es 1. Por lo que debemos ser cautos a la 
# hora de escribir el codigo. 

confusionMatrix(fitted.best.model,
                nuevadata$peso[entrenamiento],
                positive = levels(nuevadata$peso)[2])

# Accuracy : 0.9463 (mejoró)
# Sensitivity : 0.9917 (mejoró)          
# Specificity : 0.4231 (empeoró)          
# Pos Pred Value : 0.9520 (mejoró) 
# Neg Pred Value : 0.8148 (mejoró)
# 'Positive' Class : adecuado 

# Analizar las Curvas ROC

pred <- prediction(attr(fitted.best.model, 
                        "probabilities")[,2],
                   nuevadata$peso[entrenamiento])

perf <- performance(pred, "tpr", "fpr")
plot(perf, colorize = T, lty = 3)
abline(0,1, col = "black")

# Area bajo la curva 

auc1 <- performance(pred, measure = "auc")
auc1 <- auc1@y.values[[1]]
auc1 

# El area bajo la curva es de 0.9150321

# Curva Sens-Spec

plot(performance(pred, measure = "sens",
                 x.measure = "spec",
                 colorize = T))

# Se presentan buenos resultados en la curva ROC, la curva Sens-Spec y en el AUC.

# ------ Analizando los puntos de corte optimo --------

# Recordemos que la matriz de clasificacion esta siendo generada con un punto de corte de 0.5
# Aunque este tambien se puede optimizar segun nuestra data.

#  ---------  Enfoque de Maximizacion Sens-Spec
# Recuperamos en el intercepto de estas curvas. 

# Nota: Para realizar esto la muestra debe ser equilibrada. (desproporcion muestral)
# este es el mismo caso del modelo con menor cantidad de 0s, y por ende una especificidad baja.

perf1 <- performance(pred, "sens", "spec")

sen <- slot(perf1, "y.values"[[1]])
spec <- slot(perf1, "x.values"[[1]])
alf <- slot(perf1, "alpha.values"[[1]])

mat <- data.frame(alf, sen, spec)

names(mat)[1] <- "alf"
names(mat)[2] <- "sen"
names(mat)[3] <- "spec"


m <- melt(mat, id=c("alf"))

p1 <- ggplot(m, aes(alf, value, group=variable,
                    colour = variable))+
  geom_line(size = 1.2)+
  labs(title = "Punto de Corte Optimo para SVM",
       x = "cut - off", y = "")

p1

# Podemos ver que el punto de corte optimo es de un 17 - 20 % 
# Lo cual es lo que maximiza las 2 curvas, esto se debe a la poca 
# especificidad (debido a los 0s y a nuestra data desbalanceada)
# sin embargo, esto no nos sirve, NO es valido dicho lo anterior. 
# Ademas, sabemos que una persona que tenga 20% de probabilidad
# no es igual a 1 en ningun momento. 

# ---- Enfoque de la maximizacion del Accuracy

max.accuracy <- performance(pred, 
                            measure = "acc")

plot(max.accuracy)

# Con esto se ve dibujando el accuracy para cada uno de los puntos de corte.
# pero desde esta vista no es tan sencillo verlo, por lo que lo buscaremos de distinta manera.

indice <- which.max(slot(max.accuracy, "y.values")[[1]])
acc <- slot(max.accuracy, "y.values")[[1]][indice]
cutoff <- slot(max.accuracy, "x.values")[[1]][indice]

print(c(accuracy = acc,
      cutoff = cutoff))

# Entonces, el cutoff que maximiza mi punto de corte es:
#     accuracy    cutoff.10882 
#    0.9493865    0.3937901

# Este umbral es mucho más valido que la version de la sens-spec 
# que arroja algo de 0.17 - 0.2

# ------- Enfoque de la curva ROC

# Buscaremos el maximo en la curva ROC.

prediccionescutoff <- attr(fitted.best.model, "probabilities")[,1]

curvaroc <- plot.roc(nuevadata$peso[entrenamiento],
                     as.vector(prediccionescutoff),
                     precent = T, ci = T, print.auc = T,
                     threholds = "best", print.thres = "best")

# El punto de corte optimo utilizando la curva ROC es de 0.865,
# el cual es el que maximiza la distancia entre la recta tangente y la curva roc.

# Y arroja un intervalo de confianza entre los umbrales. Es decir se puede jugar entre estos umbrales.

# ---- Evaluando cutoff sugerido

# Definamos el cutoff: El que maximiza el accuracy

cutoff

# 0.3937901

umbral <- as.numeric(cutoff)

table(attr(fitted.best.model, "probabilities")[,1]>umbral, 
      nuevadata$peso[entrenamiento])

# Ver las probabilidades

head(attr(fitted.best.model, "probabilities"))

# Seleccionamos la probabilidad objetivo

prediccionescutoff <- attr(fitted.best.model, "probabilities")[,1]

prediccionescutoff <- as.numeric(prediccionescutoff)

str(prediccionescutoff)

predcut <- factor(ifelse(prediccionescutoff>umbral, 1, 0))

matriz.cutoff <- data.frame(real = nuevadata$peso[entrenamiento],
                            predicho = predcut)

matriz.cutoff <- matriz.cutoff %>%
  mutate(predicho = recode_factor(predicho, '0' = "no_adecuado",
                                  '1' = "adecuado"))
confusionMatrix(matriz.cutoff$predicho, matriz.cutoff$real,
                positive = "adecuado")


# ------ Prediciendo dentro y fuera de la muestra -------

# Sabiendo que tenemos un buen accuracy y un buen area bajo la curva, toca hacer la prediccion dentro y fuera de la muestra.

newdata1 <- head(nuevadata, 5)

str(newdata1)

# Pronosticamos dentro de la muestra. 

# La data fuera de la muestra y dentro debe estar categorizada de la misma manera.

# Considerar que para la prediccion el cutoff es de 0.5 (default)
# Lo que este por arriba de 0.5 es 1, y por debajo es 0.
# O adecuado y no adecuado.

predict(best.model, newdata1)

# Aunque, sin arbitrariedades es mejor ver las probabilidades y evaluar por si mismo.
# sin restricciones por default.

p.probabilidades <- predict(best.model, newdata1, probability = T)
p.probabilidades

# Pronostico fuera de la muestra

names(newdata1)

newdata2 <- data.frame(talla = 45,
                       sem_gest = 38,
                       sexo = 1, 
                       edad_mad = 30, 
                       sabe_leer = 1,
                       con_pren = 1, edad2 = 900)

predict(best.model, newdata2, probability = T)


# No se puede hacer validacion data la enorme data y el tiempo 
# requerido de la tutoria. 

