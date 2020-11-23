# Econometria Financiera: modelos de series temporales y modelos de volatilidad

plot(AirPassengers)
stl(AirPassengers, s.window = "period") # crea descomposicion temporal
plot(stl(AirPassengers, s.window = "period")) # ploteo de los 4 componentes. 

# estacionariedad

plot(AirPassengers)
abline(v=1952)
abline(v=1956)

g1  <- (window(AirPassengers, start = c(1949, 1), end =c(1952, 12)))

g2  <- (window(AirPassengers, start = c(1953, 1), end =c(1956, 12)))

mean(g1)
mean(g2)
# medias bastante diferentes

sd(g1^2)
sd(g2^2)
# varianzas muy distintas

t.test(g1, g2)

plot(diff(AirPassengers, 1))

file.choose()

data <- read.table("https://www.betametrica.ec/wp-content/uploads/2017/02/PIB.txt")

tsdata <- ts(data = data, start = c(2000, 1), frequency = 4)

plot(tsdata)

library(highcharter)

hchart(tsdata)

# Autorregresivo

# Propiedad de estabilida del modelo = coeficientes AR > 1

ar1 <- arima.sim(list(order = c(1,0,0),
                      ar=0.8), 
                 n=100)
ar1
plot(ar1)

ar2 <- arima.sim(list(order = c(1,0,0),
                      ar=1), 
                 n=100)
# No se puede: 'ar' part of model is not stationary

par(mfrow =c(1, 2))
acf(ar1, xlim=c(1, 24)) # dado que el primer rezago no cuenta de FAS, donde Rho = 1
pacf(ar1, xlim =c (1, 24))

# Media Movil

ma1 <- arima.sim(list(order = c(0,0,1),
                      ma=1.2), 
                 n=100)

par(mfrow =c(1, 2))
acf(ma1, xlim=c(1, 24))
pacf(ma1, xlim =c (1, 24))

arima1 <- arima.sim(list(order = c(3,1,1),
                      ar=c(0.45, 0.43, -0.98), 
                      ma = 1.2), 
                 n=1000)
plot(arima1)
abline(h=-400)
abline(h=0)


file.choose()


getws()

list.object()

console(-25)
history()
?na.rm 

a <- c(1, 2, 3)
b <- c(2, 34, 4)

c<- a < c


m <- matrix(1:6, 3, 2)

m[, -1]

x <- c(1, 2, 3)
x[2] <- "2"
x

dat <- as.Date("2020/2/28")
dst <- as.Date("2020/3/1")
dst - dat


data <- read.xlsx("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Econometria Financiera\\BC Mexico.xlsx")

exports <- data[, 2]
exports_1 <- data.frame(exports)
mean(exports_1$exports)
