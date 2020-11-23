## ---- Analisis introductorio a datos panel

library(plm)
library(foreign)
library(car)
library(gplots)

# siempre se debe hacer un analisis preliminar previo al analisis en panel

file.choose()

panel <- read.dta("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Datos Panel 1\\basepanel1\\data.dta")

coplot(y ~ year|country, type = "l", data = panel)

# el grafico se lee de izquierda a derecha. 

coplot(y ~ year|country, type = "o", data = panel)

# el grafico nos ayuda a saber si existen muchas tendencias o variaciones en las medias: sin embargo
# los graficos pueden ser subjetivos, por ello se deben contrastar analisis, para saber que tipo
# de modelo panel vamos a ocupar. 

scatterplot(y~year|country, 
            boxplot=F,
            data = panel)

plotmeans(y ~ year, main ="Heterogeneidad en el tiempo",
          data = panel)

# aqui solo se calcula la media por tiempo a traves de los agentes


plotmeans(y ~ country, main ="Heterogeneidad entre los agentes",
          data = panel)
# cuando se nota mucha heterogeneidad seria bueno ocupar un modelo que pueda explotar esa heterogeneidad

## --------- modelo de datos de Panel Pool

library(memisc)

options(scipen = 999)

pool <- lm(y ~ x1, data = panel)

summary(pool)

# es un modelo de regresion multiple utilizando datos panel

# no importa a lo que se refiera x1, lo que sabemos es que x y y estan expresadas en niveles
# los coefs se intepretan como una regresion multiple, el incremente de una unidad en x1, dara como
# resultado en un aumento de x's unidades. Estamos asumiendo que no hay heterogeneidad.

# Al ser un mco combinado, se debe hacer la clasica prueba de significancia individual
# sin embargo, aunque nuestra variable no explique, no nos podemos adelantar y borrar la variable, dado que
# una base de datos de panel, es probable que sea una buena idea el utilizar otro modelo que recoja la heterogeneidad 
# entre los agentes, debemos seguir con el analisis, pues puede que en otro modelo si sea significativo

plot(panel$x1,
     panel$y,
     pch = 19, 
     xlab = "x1",
     ylab = "y")
abline(pool, lwd=3, col ="red")

# no es que sea malo ocupar un pool, digamos cuando los agentes realmente sean muy parecidos, y no haya heterogeneidad que explotar
# sin embargo, eso lo determinaran los contrastes.
