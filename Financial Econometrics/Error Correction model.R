# ECM

# Mecanismo de correccion del error

library(forecast)
library(quantmod)
library(TSA)
library(fImport)
library(tseries)
library(lmtest)
library(openxlsx)

file.choose()

data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Econometria Financiera\\BC Mexico.xlsx")

attach(data)

names(data)

datats <- ts(data = data, start = c(1993, 1), frequency = 12)

adf.test(Exportaciones)

adf.test(Importaciones)

modelo <- lm(Exportaciones~Importaciones, data = data)
summary(modelo)
res <- residuals(modelo)
res1 <- data.frame(res)
plot(res1$res, type = "l")

adf.test(res1$res)
# Hay cointgracion

res_1 <- residuals.lm(modelo)

lagR <- lag(res_1)

lagRR <- res_1[1:length(lagR)-1]

exports_d <- diff(Exportaciones)
imports_d <- diff(Importaciones)

mce <- lm(exports_d~imports_d + lagRR)

options("scipen"=999)

summary(mce)
# El error es significativo: menor a 1 en terminos absolutos pero mayor a 0, y negativo
# por lo cual se afirma que la dinamica de corto plazo tiende al largo plazo.

