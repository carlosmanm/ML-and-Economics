# Mi base de datos esta desbalanceada: desproporcion muestral
# ¿Que hago? 

# Para abordar este problema en ML se puede
# aplicar la tecnica de remuestreo asignado porcentajes mayores a
# la clase minoritaria con 3 metodos:

# 1. oversample
# 2. undersample
# 3. metodo rose (enfoque sintetico)

# Esta desproporcion debe ser significativa, ejemplo 95 % evento objetivo y 5% el otro evento.
# PERO si se tiene un, por ejemplo, 70 - 30 o inclusive un 80 - 20, no parece necesario 
# hacer un remuestreo.


library(ROSE)
library(foreign)
library(caret)
library(ROCR)
library(dplyr)
library(reshape2)
library(pROC)
library(e1071) 

# Transformar la data de entrenamiento en data frame

data <- read.spss("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\ENCUESTA NACIDOS VIVOS-20200720T210721Z-001\\ENCUESTA NACIDOS VIVOS\\ENV_2017.sav",
                  use.value.labels = F,
                  to.data.frame = T)

data$prov_nac <- as.numeric(as.character(data$prov_nac))

nuevadata <- data %>%
  filter(prov_nac==7)%>%
  select(peso, talla, sem_gest, sexo,
         edad_mad, sabe_leer, con_pren)%>%
  filter(peso!=99, talla!=99,
         sem_gest!=99, con_pren!=99, 
         sabe_leer!=9,talla!="Sin información")

nuevadata <- nuevadata %>%
  mutate(peso=if_else(peso > 2500, 1, 0),
         sexo=if_else(sexo=="Hombre", 1, 0),
         sabe_leer=if_else(sabe_leer=="Si", 1, 0),
         edad2 = edad_mad^2,
         con_pren=if_else(con_pren >= 7, 1, 0))

nuevadata$peso <- factor(nuevadata$peso)

nuevadata <- nuevadata %>%
  mutate(peso=recode_factor(
    peso, '0' = "no_adecuado",
    '1' = "adecuado"))

# Fijar una semilla

set.seed(1234)

# Crear muestra de entrenamiento

entrenamiento <- createDataPartition(nuevadata$peso,
                                     p=0.05,
                                     list = F)

train_data <- nuevadata[entrenamiento,]

table(train_data$peso)

# no_adecuado    adecuado 
#      52         600 

# SI esta desproporcionado.

# --------  Remuestreo: Oversample - Iguala las clases ---------

# Multiplicamos por 2 el numero del evento que mayor numero tiene.

600*2

overs <- ovun.sample(peso~., data = train_data,
                     method = "over", N = 1200)$data

table(overs$peso)

#    adecuado no_adecuado 
#       600         600 

# Se genera data sintetica y se equipara la data.

# -------- Remuestreo: Undersample ---------------

# Multiplicamos por 2 la data menor

52*2

unders <- ovun.sample(peso~.,
                      data = train_data,
                      method = "under", N= 104)$data

table(unders$peso)

#    adecuado no_adecuado 
#       52          52 

# Nota: No se recomienda porque se pierde mucha data.

# ----------- Remuestreo: Metodo Rose --------

# Metodo sintetico: metodo que completa la informacion mediante una estimacion condicional de
# la densidad de Kernel de las 2 clases seleccionado una observacion que pertenece a la clase k y
# generando nuevos datos en su vecinario (los que estan al rededor de la clase segun la estimacion)

# Se supone que es el metodo más robusto dado que utiliza toda la info al final del dia.
# Nota: hay que ser precavido, es mucha info sintetica que suponer.

roses <- ROSE(peso~.,
              data=train_data,
              seed = 1)$data

table(roses$peso)

#    adecuado no_adecuado 
#      338         314

# Si bien no son los mismos, la data ya no esta desproporcionada. 

# Corremos los modelos con las 3 tecnicas de remuestreo para desproporcion.

modelo.over <- tune(svm, peso~.,
                    data = overs, 
                    ranges = list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 50)),
                    kernel = "linear", scale = T, probability = T)

modelo.under <- tune(svm, peso~.,
                    data = unders, 
                    ranges = list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 50)),
                    kernel = "linear", scale = T, probability = T)

modelo.roses <- tune(svm, peso~.,
                    data = roses, 
                    ranges = list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 50)),
                    kernel = "linear", scale = T, probability = T)


# Over

summary(modelo.over)

best.model.over <- modelo.over$best.model

# Under

summary(modelo.under)

best.model.under <- modelo.under$best.model

# Roses

summary(modelo.roses)

best.model.roses <- modelo.roses$best.model


# ----- Evaluando los modelos -----------


fitted.over <- predict(best.model.over, overs, type = "prob", probability = T)

fitted.under <- predict(best.model.under, unders, type = "prob", probability = T)

fitted.roses <- predict(best.model.roses, roses, type = "prob", probability = T)


# --- Matrices de Confusion

# Over

confusionMatrix(overs$peso, fitted.over, dnn = c("Actuales", "Predichos"),
                levels(fitted.over)[1])

# Under

confusionMatrix(unders$peso, fitted.under, dnn = c("Actuales", "Predichos"),
                levels(fitted.under)[1])

# Rose

confusionMatrix(roses$peso, fitted.roses, dnn = c("Actuales", "Predichos"),
                levels(fitted.roses)[1])

# Dado el accuracy y los demas parametros, parece que nuestro modelo original
# es mejor que los remuestreados.
# La especificidad es mejor, dada la proporcionalidad, sin embargo, la sensitividad
# de nuestro evento objetivo empeora. 

# ---- Evaluando curvas ROC

predover <- prediction(attr(fitted.over, "probabilities")[,2], overs$peso)

predunder <- prediction(attr(fitted.under, "probabilities")[,2], unders$peso)

predroses <- prediction(attr(fitted.roses, "probabilities")[,2], roses$peso)

# roc.curve de la libreria ROSE.

roc.curve(overs$peso, attr(fitted.over, "probabilities")[,2],
          col = "blue")

roc.curve(unders$peso, attr(fitted.under, "probabilities")[,2],
          col = "red", add.roc = T)

roc.curve(roses$peso, attr(fitted.roses, "probabilities")[,2],
          col = "black", add.roc = T)

# add.roc = T, hace que se superpongan las curvas en un grafico (la primera cuva no lo debe llevar).

# Comparandolo con nuestro modelo original.

roc.curve(nuevadata$peso[entrenamiento,], attr(fitted.best.model, "probabilities")[,2],
          col = "brown", add.roc = T)

# Con nuestro modelo original podemos evaluar que el problema de desproporcionalidad 
# no es tan influyente y nuestro modelo es lo suficientemente discriminatorio. 

# Extension y más recomendado:

# * Ampliar el tamaño muestral de entrenamiento y volver a correr el script


