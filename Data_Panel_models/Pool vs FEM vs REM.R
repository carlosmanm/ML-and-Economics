# Pool vs MEA vs MEF

library(foreign)
library(plm)
library(memisc)
library(car)
library(gplots)

file.choose()

panel <- read.csv("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Datos Panel 1\\basepanel1\\ocde2.csv", 
                  sep = ";")

names(panel)

#---------------- Analisis exploratorio

coplot(EV~ANIO|COUNTRY,type="l", data=panel)

scatterplot(EV~ANIO|COUNTRY,
            boxplot=F,
            data=panel)

plotmeans(EV ~ANIO,
          main="Heterogeneidad en el tiempo",
          data=panel)

plotmeans(EV ~COUNTRY,
          main="Heterogeneidad entre los agentes",
          data=panel)

#------------------- Estimar los modelos

# Lo primero que se hace es examinar los modelos que tengan coefs significativos.


Pool <- plm(EV~MED+GS, data = panel,
            index = c("COUNTRY", "ANIO"),
            model = c("pooling"))

summary(Pool)

MEF <- plm(EV~MED+GS, data = panel,
            index = c("COUNTRY", "ANIO"),
            model = c("within"))

summary(MEF)

MEA <- plm(EV~MED+GS, data = panel,
            index = c("COUNTRY", "ANIO"),
            model = c("random"))
summary(MEA)

# Comparando los modelos

# Pool vs MEF

# Ho: Pool
# H1: MEF

pFtest(MEF, Pool)

# p-value < 0.00000000000000022
# Resultado: MEF

# Pool vs MEA 
# Identificar si existe diferencia entre la varianza de los agentes

plmtest(Pool, type = c("bp"))

# p-value < 0.00000000000000022

# Rechazo la Ho: La varianza entre los agentes es 0

# En este caso MEA es mejor que Pool. 

# MEF es mejor que Pool y MEA es mejor que Pool. Ahora...

# MEF vs MEA : Hausman

# Ho: MEA
# H1: MEF

phtest(MEF, MEA)

# p-value = 0.0002182

# Rechazo Ho. MEF es mejor. 

# Estimar el modelo con dicotomicas en el tiempo

fixed.time <- plm(EV~MED+GS+factor(ANIO), data = panel,
           index = c("COUNTRY", "ANIO"),
           model = c("within"))

summary(fixed.time)

# Evaluar si el MEA que incorpora tiempo vs MEA que solo incorpora dicotomicas para los agentes

plmtest(MEF, c("time"), type = c("bp"))

# Ho: no es necesario incorporar el tiempo
# p-value = 0.4445
# No se rechaza Ho. 

# Si asumieramos que fuera mejor incorporar dicotomicas en el tiempo, estimariamos...

MEF1 <- plm(EV~MED+GS, 
            data = panel,
            index = c("COUNTRY", "ANIO"),
            model = "within",
            effect = "time")

summary(MEF1)

fixef(MEF1)
