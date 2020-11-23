###------------ Carguemos las librerias ### ====

library(foreign)
library(gmodels)
library(ResourceSelection)
library(ROCR)
library(Epi)
library(QuantPsyc)
library(ggplot2)
library(memisc) # este se instala con la libreria "mclogit"

### Carguemos las bases #=====

file.choose()

data <- read.dta("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Micro 2\\material-bases-script\\randdata.dta")

attach(data)

#atachemos la base para manipularla de mejor manera

# Recortamos nuestra data para evitar el missing data

data <- data[year==2,]

attach(data)

data <- data[complete.cases(educdec), ]

summary(data$educdec)


#------ Estimemos el modelo probit y logit y comparemos los resultados #------------


# Tomamos las variables de interes 

data <- data[c("binexp","female","xage","linc")]



logit <- glm(binexp ~ .,
              family = binomial(logit), 
              data = data)

probit <- glm(binexp ~ .,
             family = binomial(probit), 
             data = data)

memisc::mtable(logit,probit,digits = 6,sdigits = 3) # comparacion de logit vs probit

# los criterios bayesianos + los r^2's me sugieren que el probit es mejor. Aunque los criterios subsecuentes
# son mucho más importantes. 

#--------- Bondad de Ajuste #-----------

# dado que son más numero de datos, podemos hacer 20 grupos.

hl1 <- hoslem.test(data$binexp, 
                   fitted(logit), g=20)

hl2 <- hoslem.test(data$binexp, 
                   fitted(probit), g=20)

# Ho: Bondad de Ajuste
# H1: No bondad de ajuste

options(scipen = 999)

hl1 # 0.000002107 -> se rechaza Ho, no hay buena bondad de ajuste

hl2 # 0.000002107 -> mismo caso. 

# este es un criterio global, podria estar sesgado por el numero de 0's y de 1's, por ellos se requiere proseguir.

# -----------  matriz de clasificación: herramienta más utilizada a la hora de analizar variables de 
# respuesta cualitativa. Es la que permite controlar el % de clasificacion correcta van los 1 y los 0's. 

#promedio de valores proyectados de arranque como umbral

threshold <-mean(logit$fitted.values)
thresholdp <-mean(probit$fitted.values)
threshold # 0.7680301 de media como umbral -> los menores a 0.76 van a 0 y los mayores a 1
thresholdp # 0.7683941 de media como umbral

# recordemos que los resultados son muy similares, las curvas son similares (probit y logit) solo que
# en logit las curvas son más largas en las colas. 

## tabla de clasificacion --- ya solo se realiza de manera sencilla.

#                 0         1
# FALSE      0.5491106 0.3907965
# TRUE       0.4508894 0.6092035

# Segun los valores de la diagonal son muy bajos. 

ClassLog(logit,data$binexp,cut = threshold) # overall: 0.5952637 -> esto se puede deber al contraste de hoslem
# no paso la prueba. Es una probabilidad parecida a tirar una moneda. 

ClassLog(probit,data$binexp,cut = thresholdp) # overall : 0.5931109


# CAMBIANDO UNMBRAL de manera arbitraria

threshold=0.80 


ClassLog(logit,data$binexp,cut = threshold) # overall: 0.4956943

ClassLog(probit,data$binexp,cut = threshold) # overall: 0.4973089

# Por ello definir el umbral NO es trivial

#------- Evaluemos la capacidad predictiva a través de otros criterios #---------

#--------------- LA CURVA ROC para LOGIT y PROBIT

# Logit - ROC
predlogit <- prediction(logit$fitted.values, data$binexp)


perfl <- performance(predlogit, 
                    measure = "tpr", 
                    x.measure = "fpr")
# Probit - ROC
predprobit <- prediction(probit$fitted.values, data$binexp)

perfp <- performance(predprobit, 
                     measure = "tpr", 
                     x.measure = "fpr")

plot(perfl, colorize=T,lty=3)
abline(0,1,col="black")

plot(perfp, colorize=T,lty=3)
abline(0,1,col="black")

# Se esperan las curvas más lejanas a la tangente de 45 grados.

# --- Calculamos area bajo la curva (clase de R^2)

?performance

# measure details:

# auc: Area under the ROC curve.

# Logit

aucl <- performance(predlogit, measure = "auc")
aucl <- aucl@y.values[[1]]
aucl
# Resultado: 0.6177979

# Probit
?performance
aucp <- performance(predprobit, measure = "auc")
aucp <- aucp@y.values[[1]]
aucp

# Resultado: 0.6182009

# Se sugiere que esta area bajo la curva sea mayor a un 80 - 85%

### Usemos otra la librería Epi combinada la Curva ROC del LOGIT: Alternativa 
  
ROC(form=binexp ~ female + xage + 
        linc,
      plot="ROC") #sp
  


#Encontrando punto de corte óptimo para el LOGIT
#optimal cutt off 

ROC(form=binexp ~ female + xage + 
      linc,
    plot="sp")

# 76.8 como umbral optimo



#----- Encontrando punto de corte optimo para el probit #-------

perf1 <- performance(predprobit,"sens","spec")

str(perf1)

# Lo unico que hacemos es guardar los valores de sensitividad que guarda perf1, de especificidad y alpha. 
# para despues crear un data frame con ello. 

sen <- slot(perf1,"y.values")[[1]]
esp <- slot(perf1,"x.values")[[1]]
alf <- slot(perf1,"alpha.values")[[1]]

mat <- data.frame(alf,sen,esp)


#----- Encontrando punto de corte optimo para el logit #------- Alternativa innecesaria, dado que para el logit
# se tiene la opcion de la libreria Epi: ROC. 

perf2 <- performance(predlogit,"sens","spec")

sen2 <- slot(perf2,"y.values")[[1]]
esp2 <- slot(perf2,"x.values")[[1]]
alf2 <- slot(perf2,"alpha.values")[[1]]

mat2 <- data.frame(alf2,sen2,esp2)

# - se toma solo los valores de alpha segun la variable (sensitividad y especificidad)

m <- melt(mat,id=c("alf")) # alpha de probit
m2<- melt(mat2,id=c("alf2")) # alpha de logit -> el cual ya obtuvimos con ROC: esto no es necesario, solo
# se usa en caso de querer mostrar informacion en graficos homogeneos. 



p1 <- ggplot(m,aes(alf,value,group=variable,
                   colour=variable))+
  geom_line(size=1.2)+
  labs(title="punto de corte para probit")

p1

p2 <- ggplot(m2,aes(alf2,value,group=variable,
                   colour=variable))+
  geom_line(size=1.2)+
  labs(title="punto de corte para logit")

p2

grid.arrange(p1, p2, ncol = 2) # nos muestra la comparacion de los puntos de corte. 

#------- proyectando la probabilidad #--------

names(data)

newdata <- data.frame(female=1,
                      xage=19,
                      linc=8.95)

predict(logit,newdata,type = "response") # segun los datos de la nueva persona la probabilidad es 0.8059028 
predict(probit,newdata,type = "response") # segun los datos de la nueva persona la probabilidad es 0.8063837 



