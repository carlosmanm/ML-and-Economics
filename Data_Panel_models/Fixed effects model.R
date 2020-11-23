# Modelo de Efectos Fijos

# 3 tipos de modelos de efectos fijos

# 1. Heterogeneidad para el tiempo

# 2. Heterogeneidad para los agentes

# 3. Heterogeneidad en ambos

library(foreign)
library(memisc)
library(plm)
library(car)


file.choose()


panel <- read.dta("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Datos Panel 1\\basepanel1\\data.dta")

attach(panel)

mco <- lm(y~x1, data = panel)


mco.mef <- lm(y~x1+factor(country)-1, data = panel)

# se le indica que genere a los agentes como una categoria, por lo tanto para cada pais
# va a generar la estimacion de cada pais. -1

# ¿porque menos 1?

# se resta 1, por el hecho de la multicolinealidad perfecta. Similar a modelos Ancova, total de categorias -1 o (k-1)

summary(mco) # aqui se genera un solo coeficiente x1
summary(mco.mef)

# se ha generado un coeficiente x1 para cada ciudad. 

# lo primero que vemos es que el coeficiente de x1 es significativo (cosa que no ocurrio con el MCO)
# con ello podemos empezar a afirmar que, puede existir algun tipo de heterogeneidad que sesga la estimacion de x1, y por ello
# en el mco normal no se muestra significtivo. 


# recuperacion valores ajustados

yhat <- mco.mef$fitted.values

scatterplot(yhat~panel$x1 | panel$country, 
            xlab = "x1", 
            ylab = "y proyectado")

# Generamos la recta de regresion a traves del modelo de regresion simple y silvestre vs a traves de dicotomicas
# Esto nos muestra que si trabajamos con un MCO, los resultados estarian sesgados

abline(lm(panel$y ~ panel$x1, lwd = 4, 
          col ="red"))


# La diferencia de los resultados. En pool vs mef

memisc::mtable(mco, mco.mef)


# Aunque esa es la forma de hacer MEF a mano, aunque existe una libreria para hacer automaticamente...

#------- Estimacion MEF por PLM

mef <- plm(y~x1, data = panel, 
           index = c("country", "year"),
           model = "within")
?plm

# Aqui puedes hacer en model es within (mef), random (MEA), pooling (en lugar de hacerlo como mco)

# Tambien tiene en efectos: individuales (agentes), tiempo (time), twoways (ambos)
# por default lo toma por agentes

summary(mef)
# Aqui el valor es significativo. Y la estimacion es distinta a Pool, aqui lo que buscamos el promedio.
# Si se quieres recuperar los valores de los agentes:

fixef(mef)

# Se arrojan los coefs por ciudad.

# si ponemos year, antes de country, en lugar de obtener los coefs de ciudades, los obtiene por año:

mef1 <- plm(y~x1, data = panel, 
           index = c("year", "country"),
           model = "within")

fixef(mef1)

summary(mef1)

# Probar si Pool es mejor que MEF con la prueba F

# Ho: MCO es mejor que MEF
# H1: MEF es mejor que MCO

pFtest(mef, mco)

# p-value = 0.01307

# Rechazo Ho. Por ello el MEF es mejor que Pool para este caso.
