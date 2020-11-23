# Demasiadas Variables 

# Vamos a combinar la capacidad de reduccion del analisis factorial
# y la potencia predictiva de las SVM. 

library(openxlsx)
library(psych)
library(caret)
library(ROCR)
library(dplyr)
library(reshape2)
library(pROC)
library(e1071) 

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\variables_macro3.xlsx")

data2 <- data[,-1]

factores <- factanal(data2, factors = 6, scores = "regression")

# Se ponen 6 factores dado un analisis de componentes que explicaban que 6 factores eran
# los que explican cierto % de variabilidad.

datafinal <- data.frame(cbind(data[,1], factores$scores))

names(datafinal)[1] = "PIB"

# Ya tenemos nuestra informacion a partir del Analisis Factorial

# Crear SVM

modelo.pib <- tune(svm, PIB~., data = datafinal,
                   range = list(cost = c( 0.001, 0.01, 0.1, 1, 5, 10, 50)),
                   kernel = "linear")

# Tarda menos siendo una regression y no una clasificacion con variables categoricas

summary(modelo.pib)

best.model <- modelo.pib$best.model

best.model

# Pronosticando 

# Se necesitan tener valores futuros ya sea clasificacion o regresion
# lo cual es MUCHO mas sencillo para clasificacion (por ejemplo, caracteristicas de una persona)
# sin embargo, pero para la regresion, en este caso variables macro, se tendrian que hacer una clase de proyeccion
# tipo ARIMA, SARIMA, Holt Winters, etc.


newdatapib <- data.frame(head(factores$scores, 5))

pronosticos <- predict(best.model, newdatapib)

pronosticos

plot(c(datafinal$PIB, 
       pronosticos), type="l")
