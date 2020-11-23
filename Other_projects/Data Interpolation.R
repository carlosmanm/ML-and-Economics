# Regresiones y Analisis Factorial

library(car)
library(openxlsx)
library(GGally)
library(dplyr)
library(rio)


# -------------- de año a trimestres ----------------

file.choose()

sdata1 <- read.xlsx("C:\\Users\\Lenovo\\Documents\\1. ECONOMICS\\Concursos\\Moot Comp\\1.4.1. Estadisticas Generales MootComp.xlsx",
                    sheet = 3, detectDates = T)

str(sdata1)

DateSeq <- seq.Date(sdata1$Date[1],tail(sdata1$Date,1),by="quarter")

gerQuarter <- data.frame(Date=DateSeq, 
                         PIB.Inter=spline(sdata1, 
                                          method="natural", 
                                          xout=DateSeq)$y)

newdata <- merge(sdata1, gerQuarter, by='Date', all.y = T)

names(newdata)

newdata <- rename(newdata,  "PIB" = "PIB.Inter")

newdata %>%
  View()

export(newdata, "myinterpoleseriesfortx.xlsx")




# --------- de trimestres a meses ------------------#

fdata <- read.xlsx("C:\\Users\\Lenovo\\Documents\\1. ECONOMICS\\Concursos\\Moot Comp\\1.4.1. Estadisticas Generales MootComp.xlsx",
                  sheet = 4, detectDates = T)


str(fdata)

DateSeq <- seq.Date(fdata$Date[1],tail(fdata$Date,1),by="month")

gerMonthly <- data.frame(Fecha=DateSeq, 
                         PIB.Inter=spline(fdata, 
                                             method="natural", 
                                             xout=DateSeq)$y)

export(gerMonthly, "tx_inter.xlsx")

# -------------- Ejemplo de modelo con datos mensuales # ------------


sdata <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\Base - Reduccion.xlsx",
                  sheet = 1, detectDates = T)

data <- cbind(sdata, extract)

names(data)

?rename

data <- rename(data,  "PIB" = "newdata.PIB.Inter")

data %>%
  View()

names(data)

attach(data)

model <- lm(log(PIB)~log(Tasa.de.Interes)+
              log(Remesas)+log(Empleos.Formales))

summary(model)

