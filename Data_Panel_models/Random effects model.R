library(foreign)
library(memisc)
library(plm)
library(car)


file.choose()


panel <- read.dta("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Datos Panel 1\\basepanel1\\data.dta")

attach(panel)


# Se estima por Metodo Generalizado de los Momentos (MGM) -> media ponderada entre el estimador between y el within

# Recordemos que estos modelos no arrojan dicotomicas, ni para el tiempo ni para los agentes, sino que dejaremos
# que varien en el tiempo. 

# Estimando el modelo de efectos aleatorios

mea <- plm(y~x1, data = panel, 
           index = c("country", "year"),
           model = c("random"))

summary(mea)

# se genera el calculo del coeficiente x1 
# primero se analiza la significancia, de no ser significativo, puede ser que no aporte a la explicacion
# o que este modelo no sea el correcto. 

# como es una estimacion de media ponderada, basicamente se trata del cambio, o del incremento en 1 unidad de x1
# en promedio, dara como resultado un incremento de 1247001782 cantidad, considerando el cambio en el tiempo y en los agentes. 


