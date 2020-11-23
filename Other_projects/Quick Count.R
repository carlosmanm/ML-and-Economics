
file.choose()

data <- read.xlsx( "C:\\Users\\Lenovo\\Documents\\Planeacion - migracion.xlsx", 
                   sheet = 3)

attach(data)

names(data)

data%>%
  group_by(Pais)%>%
  summarise(
    Apariciones = n(),
    Puntos = sum(Pts)
  )%>%
  arrange(desc(Puntos))%>%
  filter(Apariciones > 5)%>%
  View()

# Analisis Total 


# Analisis de Puntos Criticos
# Los puntajes tienen que ser mayores a 6 y las apariciones tienen que ser mayores a 4. 
# Se ordena por la suma de puntajes y las apariciones. 

data%>%
  group_by(Pais)%>%
  filter(Pts>6)%>%
  summarise(
    Apariciones = n(),
    Puntos_Criticos = sum(Pts)
  )%>%
  arrange(desc(Puntos_Criticos))%>%
  filter(Apariciones > 4)%>%
  View()




