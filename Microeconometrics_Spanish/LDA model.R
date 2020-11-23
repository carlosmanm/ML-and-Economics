#------ cargando las libreria #-----

library(MASS)
library(gmodels)
library(ROCR)
library(Epi)
library(QuantPsyc)
library(ggplot2)
library(reshape2)
library(plotly)

#------cargar la base de datos #-------


file.choose()

data <- read.csv("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Micro 2\\material-bases-script\\germancredit.csv")

head(data,2)


db1 <- data[,c("Default","duration",
             "amount","installment",
             "age")]


head(db1,2)


attach(db1)

# El analisis discriminante no es per se un modelo econometrico, es una tecnica de la estadistica
# multivariante que cumple las condiciones de un modelo. En este caso, de un modelo microeconometrico.
# Su funcion es calcular la probabilidad de pertenencia de un grupo u otro. 

# Los logit y los probit dan un valor de probabilidad, y con base en un umbral nosotros clasificamos
# si es 0 o si es 1. Con el analisis discriminante, tambien conocida como LDA, linear discriminant analysis
# son muy utilizados, dada la facilidad de diseñar y su robustez. Aunque en el entorno empresarial, se siguen
# usando más modelos probit, logit que los de analisis discriminante. 



#------- modelo AD (LDA) #----------

# Voy a calcular la probabilidad de que un deudor, me pague o no me pague (default), en funcion de las duracion,
# la cuenta, las cuotas ya pagadas (installment), la edad, etc. 


?lda # de la libreria MASS



zlin <- lda(Default~., data=db1) # el modelo se construye como uno de regresion, normal, solo que lda arrojara resultados distintos
zlin

# Call:
# lda(Default ~ ., data = db1)

# Prior probabilities of groups:
#   0          1 
#   0.7       0.3 

# son las probabilidades a priori de lo que segun sus datos tienen
# en este caso es más probable que existan mas 0's que 1's. 

# Group means, aqui solo calcula las medias de cada variable agrupadas en 0 y 1:
#  duration   amount     installment      age
# 0 19.20714  2985.457    2.920000    36.22429
# 1 24.86000  3938.127    3.096667     33.96333

# en promedio, aquellas personas que estan categorizadas como 1, tienen una duracion de 24 (por ejemplo, meses)

# Coefficients of linear discriminants:
# solo tenemos una LD dado que q = 2 y funciones lineales q-1

#                  LD1
# duration     0.0515239296
# amount       0.0001324981
# installment  0.3399540088
# age         -0.0345087259
# estos coeficientes no se interpretan en terminos de unidad, lo que se verifica es que sea mayor a 0, dado que si es mayor a 0, contribuira 
# en la probabilidad de que se cumpla 1. 
# el coeficiente negativo, se entiende a que contribuye a que el evento 0 suceda, en lugar del evento 1

# el coeficiente que parece más fuerte es installment

#-------matriz de confusión #--------

# como la libraria quantpysc que tiene el classlog automatico, solo esta asociada a modelo probit y logit
# aqui se hace uso del crosstable -> aunque tampoco es directamente aplicable, habra que aplicar un poco de codigo.
# donde se hara una comparacion de la prediccion de la clase (1 o 0) del modelo vs la variable original (default)

predict(zlin)$class 

# esto es la prediccion aumatica de la clase del modelo lda, es decir son los valores ajustados.
# esto era lo equivalente a ocupar logit$fitted, pero para este modelo 


CrossTable(predict(zlin)$class,Default)
ct <- table(predict(zlin)$class,Default)
ct

# ¿que es lo que nos da esto? la matriz de confusion simplificada. 

#       0   1
#   0 669 256
#   1  31  44

# los porcentajes de correcta clasificacion y del overall se realiza manualmente.

diag(prop.table(ct,1))

#         0         1 
#   0.7232432 0.5866667  -> porcentaje de clasificacion correcta

sum(diag(prop.table(ct))) 

# overall -> 0.713


#------- controlando la posterior  #--------

# la posterior me arroja la probabilidad de clasificacion posterior a aplicar nuestro modelo para los 1's 
# y para los 0's y justo esto es lo que me interesa para poder construir mi umbral. 

predict(zlin)$posterior

#            0          1
# 500  0.8202638 0.17973618 y es que la suma de estas probabilidades es 100% -> esa es la probabilidad
# de ir a 0 y la prob de ir a 1 para esa observacion. 

# otra opcion para no usar predict, es crear una variable con otro nombre

fit <- predict(zlin)

predictl
?predict.lda # Clasificar observaciones multivariadas por discriminación lineal

# class: La clasificación MAP (un factor)
# posterior: probabilidades posteriores para las clases
# x: los puntajes de casos de prueba en variables discriminantes. 


# si visualizamos el contenido, se tiene una lista de 3 -> una clase (1 o 0's), la probabilidades de 
# clasificacion (posterior) y x. 

str(fit)

fit$class

fit$posterior

fit$x

#--- sin embargo en la tutoria se hace uso de esta manera. 

predict(zlin)$posterior


# los probit y los logit, y cualquier analisis o modelo de respuesta cualitativa se enfoca en la primera 
# variable, es decir, en el 1, por lo cual nos enfocaremos en el que probabilidad de 1 sea mayor. A favor de que
# suceda 1. 

catabase <- predict(zlin)$posterior[,2]

catabase # solo hemos tomado los valores de probabilidad de ser 1. 

# ¿Cual es la diferencia con el anterior thresold y la matriz de confusion? que con este se maximiza 
# la probabilidad sea a favor de que suceda 1. Estos modelos siempre estan orientados a que sucedan. 

threhold <- mean(catabase)

threhold # el umbral medio es 0.2990363

# con este umbral generamos nuestra matriz de confusion. los valores reales vs las estimaciones que maximizan 1
# + un umbral que, al igual maximiza 1. 

CrossTable(db1$Default,catabase>threhold)

# para poder visualizar la matriz de confusion de manera más rapida. 

ct <- table(catabase>threhold,Default)
ct

diag(prop.table(ct,1)) # % de clasificacion correcta: 0.7604690 y 0.3895782
sum(diag(prop.table(ct))) # overall: 0.611 




# proyectar con ad

newdata <- data.frame(duration=48,
                      amount=5951,
                      installment=15,
                      age=22)

predict(zlin,newdata,type="response")

# Esto nos arroja la probabilidad de que sea 0 y la probabilidad de ser 1 

#            0         1
#     0.06945561 0.9305444 
# tiene probabilidad de ser un buen pagador. -> con este thresold tan bajo 

# ------------- la curva ROC
pred <- prediction(catabase,db1$Default)

perf <- performance(pred,measure = "tpr",
                    x.measure = "fpr")


plot(perf, colorize=T,lty=3)
abline(0,1,col="black")


#---- punto de corte #------

perf1 <- performance(pred, "sens","spec")

sen <- slot(perf1,"y.values")[[1]]
esp <- slot(perf1,"x.values")[[1]]
alf <- slot(perf1,"alpha.values")[[1]]

mat <- data.frame(alf, sen, esp)

m <- melt(mat,id=c("alf"))

p1 <- ggplot(m, 
             aes(alf,value,group=variable,colour=variable))+
  geom_line(size=1.2)+
  labs(title="punto de corte optimo para AD",
       x="cut off",y="")


p1 # punto de corte optimo
# el punto de corte optimo es 0.28, coicidente con la media que elegimos
# aunque ese punto es demasiado bajo, inclusive con las curvas, se puede descartar el modelo
# una persona con una probabilidad de 0.3 seria igual a 1? pues es mejor tirar la moneda para saber si pagara.
# el punto de corte optimo siempre es en funcion del modelo que nosotros diseñamos, si nosotros diseñamos un mal 
# modelo, tendremos este tipo de punto de cortes optimos muy bajos. 