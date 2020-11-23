#------ no hay librerías especiales #-----

file.choose()

db <- read.csv("C:\\Users\\Lenovo\\Documents\\R\\Proyectos\\Betametrica\\Micro 2\\material-bases-script\\credito.csv", header=TRUE)

attach(db)
modelo <-  glm(MDR ~  Age + Income, family = poisson(log), 
        data = db)

summary(modelo)

exp(coef(modelo))

#predecir
newdata = data.frame(Age=30, Income=1.2)
predict(modelo, newdata, type="response") 
