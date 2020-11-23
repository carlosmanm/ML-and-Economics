

#--------- Cargar librerias

library(openxlsx)
library(gmodels)
library(ResourceSelection)
library(ROCR)
library(Epi)
library(QuantPsyc)
library(ggplot2)

#------------ cargar base

# Antes de hacer estos analisis es importante realizar el analisis de la base
# antes de crear al modelo. 

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Micro 2\\material-bases-script\\laboral.xlsx")

attach(data)

# Solo seleccionar aquellas variables que me interesan.

names(data)
data <- data[c("inlf", "nwifeinc", "educ",
             "exper", "expersq", 
             "age", "kidsge6", 
             "kidslt6")]

# No nos enfocamos en la interpretacion de los coeficientes, sino que la validacion de que estos modelos esten funcionado correctamente

# inlf : si una mujer participa o no en el mercado laboral en algun momento en el tiempo (se debe evaluar un horizonte temporal)
# nwifeinc: otras fuentes de ingreso
# educ años de educacion
# age edad
# exper y exper al cuadrado
# kidslt6 numero de hijos menores de 6 años
# kidsg6 numero de hijos entre 6 y 18 años

# ---- estimando el modelo logit

logit <- glm(inlf~.,
             family = binomial("logit"),
             na.action = na.omit, 
             data = data)

summary(logit)

# coeficientes no interpretables directamente, solo se analiza signo y magnitud, ademas de su
# significancia individual. 

#----- bondad de ajuste # -------

# En si estos modelos no tienen una bondan de ajuste como un R^2 unica, sino que hay muchos, como el Kernel, cox snell, etc. 

# En este caso se ocupar el hosmer lemeshow test el cual es un criterio generalmente aceptado la evaluar bondad de ajuste

# En si lo interesa a estos criterios es que su modelo clasifique bien. Por ejemplo, aquellas personas que pagan y aquellas que no.

# este hoslem proviene de la libreria resource selection


hl1 <- hoslem.test(data$inlf, logit$fitted.values, 
                   g = 10)

# Los valores reales de la variable vs los valores ajustados de mi modelo. Aqui se debe definir
# cuantos grupos se generarar en nuestra tabla a traves de este criterios, la tabla expresara a traves de 
# rangos la probabilidad de que permanezca a un grupo u a otro. 
# Generalmente el numero de grupos que se construye esta en funcion de la cantidad de datos que tenemos, en este caso, de 700 datos
# por ejemplo, se puede trabajar 10 grupos (g = 10)


# Ho: bondad de ajuste
# H1: No bondad de ajuste

hl1

# p-value = 0.1171 -> no se rechaza Ho

# Lo ideal es que el valor p sea lo más alto posible ejemplo 0.50 es que se tiene
# una mejor bondad de ajuste. En este caso no se rechaza aunque no es tan alto.
# En este sentido se puede comparar modelos con sus valores de probabilidad del hosmer lemeshow test y
# optar por cual tenga un valor p más alto (o que mejor se ajuste)

# ¿Como se construye este test?

t <- cbind(hl1$observed, hl1$expected)

table <- as.data.frame(t)

View(table)

# se crea una tabla de contingencia que generan el p value y el valor de chi-square

#                  y0  y1     yhat0     yhat1
#[0.00867,0.197]   66  10   67.252618   8.747382
#  (0.197,0.291]   54  21   57.035877  17.964123
#  (0.291,0.41]    49  26   48.142746  26.857254
#  (0.41,0.513]    46  29   40.321825  34.678175
#  (0.513,0.611]   27  49   33.005822  42.994178
#  (0.611,0.688]   27  48   26.155244  48.844756
#  (0.688,0.762]   30  45   20.789459  54.210541
#  (0.762,0.825]   15  60   15.467967  59.532033
#  (0.825,0.89]     8  67   10.603755  64.396245
#  (0.89,0.969]     3  73    6.224686  69.775314

# Se crean 10 grupos donde: y0 y y1 son los valores observados y yhat0 y yhat1 son los valores estimados
# estos deben ser cercanos, por ejemplo si el dato y0 es 66 y y 67.25 como estimado (yhat0)
# el valor en 0 del segundo grupo es 54 y el valor estimado del segundo grupo es 57.03, con estos valores
# se determina si el p-value rechaza o no la Ho. 

# ----- matriz de confusion/clasificación
# Este es el contraste más importante. (dado que se determina la tasa de aciertos)

# Hay 2 formas para obtener la matriz de funsion:

# 1) definir un umbral ¿Ante la ausencia de un modelo econometrico, cual es el mejor pronostico?
# la teoria dice que ante la ausencia de un modelo y conocimiento tecnico, el mejor modelo 
# sera el que se mida con respecto a la media. 

# promedio del umbral

thresold <- mean(logit$fitted.values)

thresold

# El umbral sera de 0.5683931 -> el cual sera para arrancar

# matriz de confusion

CrossTable(data$inlf, logit$fitted.values>thresold)

# se agregan muchos valores a la tabla innecesarios, como chi-square, valores esperado, fisher, etc.
# pero eso se puede eliminar.

?CrossTable


CrossTable(data$inlf, logit$fitted.values>thresold, 
           expected = F, prop.r = F, prop.t = F, prop.c = F,
           prop.chisq = F, chisq = F, fisher = F)

#               | logit$fitted.values > thresold 
# data$inlf     |     FALSE |      TRUE | Row Total | 
#  -------------|-----------|-----------|-----------| -> el valor real es 0, y hay 233 que son 0, pero tambien hay 
#       0       |      233  |        92 |       325 | 92 resultado que fueron 1. (mal clasificado) y esto son un
#  -------------|-----------|-----------|-----------| falso positivo.
#       1       |       107 |       321 |       428 | -> el valor real es 1, hay 321 que si son 1 (acertados), 
#  -------------|-----------|-----------|-----------| sin embargo, hay 107 mal clasificados 
#  Column Total |       340 |       413 |       753 | 
#  -------------|-----------|-----------|-----------|
  
# Generalmente se analiza unicamente cuando son 1's y cuando son 0's, es decir, la diagonal principal, 
# he inclusive de ahi deriva el "indicador de clasificacion global". 

# prop.r -> row proportions will be included
# prop.c -> columns proportions will be included

CrossTable(data$inlf, logit$fitted.values>thresold, 
           expected = F, prop.r = T, prop.c = T, prop.t = F,
           prop.chisq = F, chisq = F, fisher = F)

#               | logit$fitted.values > thresold 
#data$inlf      |     FALSE |      TRUE | Row Total | 
#  -------------|-----------|-----------|-----------|
#             0 | tn    233 |fp      92 |       325 | -> ademas se tiene el 71% de clasificar los
#  |                  0.717 |     0.283 |     0.432 | los 0's cuando son 0's -> que resulta de 233/325
#  |                  0.685 |     0.223 |           | 
#  -------------|-----------|-----------|-----------|
#             1 |fn     107 |tp     321 |       428 | -> tengo el 75% de probabilidad de clasificar los
#  |                  0.250 |     0.750 |     0.568 | 1's cuando son 1's.
#  |                  0.315 |     0.777 |           | 
#  -------------|-----------|-----------|-----------|
#  Column Total |       340 |       413 |       753 | - y las tasas de equivocacion son de 28% y 25%,
#  |                  0.452 |     0.548 |           | considerando este threshold
#  -------------|-----------|-----------|-----------|

# Lo ideal es que ambas tasas sean muy altas, pero en este caso existe el trade-off. 

# A pesar de que la tabla nos arroja estos valores en automatico, se pueden considerar las formulas:

# precision = 321/321+92 = 0.777

# sensitividad = 321/321+107 = 0.75

# especificidad = 233/233+92 = 0.7169


?ClassLog

# Class Log -> Classification for Logistic Regression -> arroja la matriz de la segunda y más sencilla 
# manera más otras variantes del analisis. 

ClassLog(logit, data$inlf, cut = thresold)

# $rawtab
#    resp
#        0   1
#FALSE  233 107
#TRUE    92 321

#$classtab
#            resp
#            0         1
#FALSE 0.7169231 0.2500000
#TRUE  0.2830769 0.7500000

# $overall
# [1] 0.7357238  -> suma de probabilidades de diagonal principal -> 0.71+0.75/2 = 0.73
# este es el porcetaje de clasificacion global
# este tambien se puede considerar un R^2, dado que el 73%
# de los datos estan clasificados correctamente.

# $mcFadden
# [1] 0.2196814
# esta es otra clase de bondad de ajuste, aunque no es muy utilizada.

# --------- Evaluar la capacidad predictiva a traves de otros criterios

# La curva ROC

pred <- prediction(logit$fitted.values, data$inlf)

perfor <- performance(pred, 
                      measure = "tpr", # true positive rate
                      x.measure = "fpr") # false positive rate

plot(perfor) # aqui tenemos la curva ROC

plot(perfor, colorize = T, lty = 3)
abline(0,1, col = "black")
# Ahora si se puede analizar la curva ROC.Un modelo que esta clasificando bien es aquel
# que esta pegado lo más posible al eje opuesto a la tangente. Esto es acorde al porcentaje
# de clasificacion global, el cual, mayor alto que sea, más alejada de la tangente sera esta curva. 

# con esto podemos pensar que el modelo pinta bastante bien.

# Curva de ROC con libreria Epi: esto solo funciona para los modelos logit, para los probit se necesita lo mismo, pero
# se realizara de manera distinta.

names(data)

ROC(form = inlf~nwifeinc+
      educ+age+exper+expersq+age+
      kidsge6+kidslt6, plot = "ROC") # plot de ROC-curve

# y nos arroja un excelente grafico que nos dice en especifico el valor de especificidad (71.7%), 
# y de sensitividad (76.4%) a demas trae lo el resumen de los coeficientes del modelo logit y 
# su error. Y se tiene un criterio adicional del area bajo la curva (otra clase de R^2) que trata 
# de ser lo más alto posible.


# ------ Punto de corte optimo


# sensitividad y especificidad se interceptan, de la misma manera con el comanda ROC de la libreria Epi: solo se cambia
# el tipo de plot a "sp" de sensitivity, pero esto solo funciona para los logit. 

ROC(form = inlf~nwifeinc+
      educ+age+exper+expersq+age+
      kidsge6+kidslt6, plot = "sp")

# nos arroja un grafico donde la especificidad y la sensitividad cortan y nos dan el valor 0.56.6 
# (Umbral optimo) y con esto se crea la matriz de confusion optima. 