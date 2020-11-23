# No todo en el mundo de los datos es lineal

# Kernel Gaussiano o Radial

modeloradial <- tune(svm, peso~.,
                     data = nuevadata[entrenamiento,],
                     kernel = "radial", ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 20), 
                                                      gamma = c(0.5, 1, 2, 3, 4, 5, 10)),
                     scale = T, probability = T)


ggplot(data = modeloradial$performances, aes(x = cost, y = error, color=as.factor(gamma)))+
  geom_line()+ geom_point()+
  labs(title = "Error de Valiación vs hiperparametros Gamma")+
  theme_bw()

# El mejor modelo quien considera un gamma de o.5

best.model.radial <- modeloradial$best.model

# --- Evaluando el modelo No Lineal 

# Nota: Se debe evaluar vs modelo Lineal.

# Para evaluar se deben generar los valores ajustados

fitted.model.radial <- predict(best.model.radial, 
                               nuevadata[entrenamiento,],
                               type ="prob", probability = T)

# Matriz de confusion

confusionMatrix(fitted.model.radial, nuevadata$peso[entrenamiento], 
                positive = levels(nuevadata$peso)[2])


# Curvas ROC

roc.curve(nuevadata$peso[entrenamiento],
          attr(fitted.model.radial, "probabilities")[,2], 
          col = "black")

# En consola se nos arroja el area bajo la curva y estad ebe ser comparada con 
# el modelo original.

roc.curve(nuevadata$peso[entrenamiento],
          attr(fitted.best.model, "probabilities")[,2], 
          col = "red", add.roc = T)

# Aunque en este punto, el lineal es mejor que el radial. Aunque todavia faltaria:
# Determinar el punto de corte optimo con el Kernel radial
# Evaluar la matriz de prediccion con los cutoffs del kernel lineal vs radial
# Evaluar curvas de sens-spec en lineal vs radial.

