
### Carguemos las librerias ### ====

library(openxlsx)
library(foreign)
library(forecast)
library(gmodels)
library(lmtest)
library(ResourceSelection)
library(ROCR)
library(Epi)
library(QuantPsyc)
library(ggplot2)

library(reshape2)
library(gridExtra)

library(plotly)

### Carguemos las bases #=====

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Micro 2\\material-bases-script\\laboral.xlsx")

# utilizo las variables de interes 

data <- data[c("inlf","nwifeinc",
             "educ","exper","expersq",
             "age","kidsge6","kidslt6")]

attach(data)

#--------- Descripción de las Variables #---------
#...

#------ Estimemos el modelo probit #------------


probit <- glm(inlf ~.,family=binomial("probit"), 
          data = data)
summary(probit)

# no es interpretable directamente y se recomienda probar que sea un buen modelo
# para despues hacer pronostico, interpretacion de efectos marginales, etc. 

#--------- Bondad de Ajuste #-----------

# hosmer lemeshow

hl1 <- hoslem.test(data$inlf, 
                   fitted(probit), g=10)
hl1

#Ho: Bondad de Ajuste
#H1: no bondad de ajuste

# p-value = 0.06296 no rechazo la Ho de Bonda de Ajuste

str(hl1)
cbind(hl1$observed,hl1$expected)


# ---- matriz de clasificación

#promedio de valores proyectados como primer umbral

threshold<-mean(fitted(probit))

threshold

# el promedio es de 0.5701086 y por ende sera nuestro umbral de arranque
# cualquier valor por encima de 0.57 es 1 y cualquier punto por debajo es 0

CrossTable(data$inlf, 
           fitted(probit) > threshold,
           expected=F, 
           prop.r=T, prop.c=T,
           prop.t=F, prop.chisq=F, 
           chisq = F, fisher=F)

## tabla de clasificacion

ClassLog(probit,data$inlf,cut = threshold)

# 0.7357238 de overall pero no esta clasificando bien segun la tabla de porcentajes.

#CAMBIANDO El UNMBRAL

threshold=0.80


CrossTable(data$inlf, 
           fitted(probit) > threshold,
           expected=FALSE, 
           prop.r=TRUE, prop.c=TRUE,
           prop.t=F, prop.chisq=F, 
           chisq = FALSE, fisher=FALSE)


ClassLog(probit,data$inlf,cut = threshold)

# 0.6215139 es el nuevo umbral -> no es trivial colocar cualquier umbral dado que este
# es muy sensible a cualquier cambio. Y por ello es tan importante encontrar un punto de corte optimo. 

#------- Evaluemos la capacidad predictiva a través de otros criterios #---------


# La curva ROC: sensitividad vs 1-especificidad

pred <- prediction(probit$fitted.values, data$inlf)

perf <- performance(pred, 
                    measure = "tpr", 
                    x.measure = "fpr") 

plot(perf, colorize=T,lty=3)
abline(0,1,col="black")

# se busca que se encuentre lo más lejana de la tangente de 45 grados

# ----------- curva precision-sensibilidad


# La Precisión es una medida util cuando hay desbalances en la data (se tienen más 0's que 1's por ejemplo)
# una alta precisión está relacionado a bajas tasas de falsos positivos
# una alta sensibilidad está relacionado a bajas tasas de falsos negativos

# precision =Tp/Tp+Fp
# sensibilidad =Tp/Tp+Fn

# se crea de la misma manera que la curva ROC pero cambiando los valores a prec y a rec. 

perf <- performance(pred, 
                    measure = "prec", 
                    x.measure = "rec") 

plot(perf, colorize=T,lty=3)

# se espera que la curva sea lo mas pronunciada posible

# -------- punto de corte optimo para el probit: a diferencia de los logit aqui no se puede ocupar ROC 
# como funcion de la libreria Epi, por lo cual habra que construir el grafico desde abajo. 

perf1 <- performance(pred,
                     "sens",
                     "spec")

# ya no colocamos measure porque lo que me interesa es la curva. 

str(perf1)

# Formal class 'performance' [package "ROCR"] with 6 slots (hay 6 espacios) en nuestro performance

# esto nos indica que @ x.values:List of 1, y.values:List of 1, alpha.values:List of 1

# ?slot -> lugar donde esta almacenado 

sen <- slot(perf1,"y.values"[[1]]) # me interesan los valores de y que se encuentran en el primer espacio, es decir los valores de sensitividad
esp <- slot(perf1,"x.values"[[1]]) 
alf <- slot(perf1,"alpha.values"[[1]]) # -> este es el punto de corte optimo

mat <- data.frame(alf,sen,esp) # creo un data frame almancenando mis valores
View(mat)

# le damos nombres a nuestras columnas

names(mat)[1] <- "alf"
names(mat)[2] <- "sen"
names(mat)[3] <- "esp"


?melt # convierte cualquier data set a un melt 

m <- melt(mat,id=c("alf")) # solo tomamos los valores de alpha y los separamos.

View(m)

# en m: alf tiene el punto alpha (intercepcion), variable tiene las unicas 2 variables
# sensitividad y especificidad y value es el valor ya sea de especificidad y el valor 
# de sensitividad. 

# 0.9799039 sen 0.002336449 -> para el punto alpha de 0.9799 (intercepto), el valor de sen es 0.002
# 0.9799039 esp 1.000000 -> y el valor de especificidad es de 1

# graficamos alpha vs su valor 

p1 <- ggplot(m,
             aes(alf, value,
                 group=variable,
                 colour=variable)) + geom_line(size=1.2)+
  labs(title="punto de corte optimo PROBIT")

p1

# esto hace que nuestro ggplot se vuelva dinamico y cuando sobrepongamos el cursor en cualquier punto nos
# arroje valores.
# hacemos zoom y el punto de corte optimo es 0.58, con esta construiremos nuestra nueva matriz de clasificacion y verificar de que 
# forma varia la clasificacion de las variables. 
ggplotly(p1)

