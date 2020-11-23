# Regresiones y Analisis Factorial

library(car)
library(openxlsx)
library(GGally)
library(dplyr)


file.choose()


# --------- de trimestres a meses ------------------#

fdata <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\Base - Reduccion.xlsx",
                  sheet = 2, detectDates = T)

fdata <- fdata[,1:2]

str(fdata)

DateSeq <- seq(fdata$Fecha[1],tail(fdata$Fecha,1),by="1 month")

gerMonthly <- data.frame(Fecha=DateSeq, 
                         PIB.Inter=spline(fdata, 
                                             method="natural", 
                                             xout=DateSeq)$y)

newdata <- merge(fdata, gerMonthly, by='Fecha', all.y = T)

extract <- data.frame(newdata$PIB.Inter)

# New data guarda el PIB interpolado de trimestres a meses.

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


# -------------- de año a trimestres ----------------

sdata1 <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Machine Learning\\Bases de datos ML\\Base - Reduccion.xlsx",
                   sheet = 4, detectDates = T)

str(sdata1)

DateSeq <- seq.Date(sdata1$Date[1],tail(sdata1$Date,1),by="quarter")

gerQuarter <- data.frame(Date=DateSeq, 
                         PIB.Inter=spline(sdata1, 
                                          method="natural", 
                                          xout=DateSeq)$y)

newdata1 <- merge(sdata1, gerQuarter, by='Date', all.y = T)

names(newdata)

newdata <- newdata1%>%
  select(-c("GDP"))

newdata <- rename(newdata,  "PIB" = "PIB.Inter")

newdata %>%
  View()

