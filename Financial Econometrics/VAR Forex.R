# VAR

library(vars)
library(car)
library(forecast)
library(tseries)
library(fImport)
library(urca)

getSymbols("EXUSEU", src = "FRED")
getSymbols("EXUSUK", src = "FRED")
getSymbols("EXCAUS", src = "FRED")

EURUSD = EXUSEU["2010-01::2019-01"]
GBPUSD = EXUSUK["2010-01::2019-01"]
USDCAD = EXCAUS["2010-01::2019-01"]

# Comprobar estacionariedad

plot(EURUSD, type="l")
plot(GBPUSD, type="l")
plot(USDCAD, type="l")

# VAR es un modelo que depende de sus propios valores pasados
# y de los valores pasados de las demas variables

adf.test(EURUSD)
# No es estacionaria
adf.test(GBPUSD)
# No es estacionaria
adf.test(USDCAD)
# No es estacionaria

?returns
?adf.test

adf.test(na.omit(diff(log(EURUSD)))) # SE APLICA la diferencia del logaritmo 
# se aplica un na.omit dado que ADF no acepta valores NA, al rezagar una variable
# obvio tendra.
# La funcion RETURNS te aplica la diferencia del logaritmo automaticamente. 
rEURUSD <- na.omit(returns(EURUSD))

adf.test(rEURUSD) # El resultado es exactamente el mismo. 

# Ejemplo grafico de la similitud entre diff(log) y returns

plot(diff(log(EURUSD)))
plot(returns(EURUSD), type="l")
# Es la misma grafica. 

# creamos las demas variables diferenciadas para hacerlas estacionarias. 

rGBUSD <- na.omit(returns(GBPUSD))
adf.test(rGBUSD)

rUSDCAD <- na.omit(returns(USDCAD))
adf.test(rUSDCAD)

# Las series ya son estacionarias

# NO ES RECOMENDABLE HACER ESTO, DADO QUE SE PUEDE CAER EN UN ERROR DE ESPECIFICACION
# ESTE ES UN CASO ESPECIFICO DADO QUE SE TRATA DE UN ANALISIS FOREX DONDE SE REQUIERE
# HACER LA DIFF DEL LOG -> TASAS DE CRECIMIENTO (ESTO ES NORMAL EN ANALISIS FINANCIERO). 
# MAS ADELANTE SE HARA EL VAR CON OTRAS VARIABLES. 

forex <- data.frame(rEURUSD, rGBUSD, rUSDCAD)
forex

# aplicamos var reducido

VARselect(forex, type = "none")

# None depende de la serie en estudio, como esto son divisas no hay una constante
# pero otras variables si se puede tomar en cuenta la tendencia, etc

# El resultado del VARselect fue:

# AIC(n)  HQ(n)  SC(n) FPE(n) 
#   1      1      1      1 

# Los criterios indican un VAR (1)


varF <- VAR(forex, p=1, type = "none", 
            ic = "AIC")
varF

summary(varF)

predictVAR <- predict(varF)

predictVAR

plot(predictVAR)

# Impulso Respuesta

impul <- irf(varF)
impul
plot(impul)

