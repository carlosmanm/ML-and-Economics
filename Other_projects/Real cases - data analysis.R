# Modelizacion en R --------------------------------

options(na.action = na.warn) 
options("scipen"=999)

# Se nos dara una advertincia cuando se tomen en cuenta NA's
# Es importante declarar antes de empezar script

data <- tibble(BC_petrolera_y_total_Mexico)

attach(data)

data %>% 
  View()

data %>%
  ggplot(aes(`Exportaciones Petroleras`, `Importaciones Petroleras`))+
  geom_point()+
  geom_abline()

model1 <- lm(`Exportaciones Petroleras`~`Importaciones Petroleras`, data = data, 
             na.action = na.exclude)
summary(model1)
nobs(model1) # numeros de obs
coef(model1)
mean(resid(model1))
sum(model1$residuals)


df <- tribble(
  ~y, ~x, ~z,
  3,  4,  5,
  15, 10, 8
)

model_matrix(df, y~x)
model_matrix(df, y~x+z)

# Otros modelos no lineales -----------------------------------

# Modelo lineal generalizado 
stats::glm()

# Modelo generalizado aditivo
mgcv::gam()

# Modelos lineales penalizados
glmnet::glmnet()

# Modelos lineales robustos
MASS::rlm() # -> poco sensibles a outliers

# Árboles y bosques aleatorios
rpart::rpart()
randomForest::randomForest()


# CASOS REALES ------------------------------------------------------------

?add_predictions

install.packages("modelr")
library(modelr)
options(na.action = na.warn)

# Â¿Porque los diamantes de mala calidad son los mas caros?

diamonds %>%
  ggplot(aes(cut, price)) + geom_boxplot()

diamonds %>%
  ggplot(aes(carat, price)) +
  geom_hex(bins = 50)

diamonds2 = diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(lprice = log2(price), 
         lcarat = log2(carat))

diamonds2 %>%
  ggplot(aes(lcarat, lprice)) +
  geom_hex(bins = 50)

# la transformacion logaritmica es muy util  


# El caso de los diamantes # 


mod_diamonds = lm(lprice ~ lcarat, 
                  data = diamonds2)
grid = diamonds2 %>%
  data_grid(carat = seq_range(carat, 30)) %>%
  mutate(lcarat = log2(carat)) %>%
  add_predictions(mod_diamonds, "lprice") %>%
  mutate(price = 2^lprice)

grid  

diamonds2 %>%
  ggplot(aes(carat, price)) +
  geom_hex(bins = 50) +
  geom_line(data = grid, color = "red", 
            size =1)

diamonds2 = diamonds2 %>%
  add_residuals(mod_diamonds, "lresid")

diamonds2 %>%
  ggplot(aes(lcarat, lresid)) +
  geom_hex(bins = 50)

diamonds2 %>% 
  ggplot(aes(cut, lresid)) + 
  geom_boxplot()

diamonds2 %>% 
  ggplot(aes(color, lresid)) + 
  geom_boxplot()

diamonds2 %>% 
  ggplot(aes(clarity, lresid)) + 
  geom_boxplot()


mod_diamonds2 <- lm(lprice ~ lcarat +
                      color + cut + clarity,
                    data = diamonds2)


diamonds2 %>%
  data_grid(cut, .model= mod_diamonds2) %>%
  add_predictions(mod_diamonds2) %>%
  ggplot(aes(cut, pred)) +
  geom_point()

diamonds2 %>%
  data_grid(color, .model= mod_diamonds2) %>%
  add_predictions(mod_diamonds2) %>%
  ggplot(aes(color, pred)) +
  geom_point()

# La tendencia es a la baja: baja el precio del diamante cuanto peor es el color

diamonds2 %>%
  data_grid(clarity, .model= mod_diamonds2) %>%
  add_predictions(mod_diamonds2) %>%
  ggplot(aes(clarity, pred)) +
  geom_point()

# El color mas malo del diamante influye negativamente en el precio


ggplot(grid, aes(cut, pred)) +
  geom_point()

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamonds2, "lresid2")

ggplot(diamonds2, aes(lcarat, lresid2)) +
  geom_hex(bins = 50)


# El caso de los vuelos NYC #

# Â¿Que puede afectar el numero de vuelos de un dia?

daily <- flights %>%
  mutate(date = make_date(year, month, day)) %>%
  group_by(date) %>%
  summarise(n = n())
daily

daily %>%
  ggplot(aes(date, n)) +
  geom_line()

daily %>%
  mutate(wday = wday(date, label = TRUE)) -> daily

daily %>%
  ggplot(aes(wday, n)) +
  geom_boxplot()

# Hay muchos mas vuelos entre semana

# Vamos a predecir el numero de vuelos que saldran segun el dia

mod1 = lm(n ~ wday, data = daily)

summary(mod1)

grid <- daily %>%
  data_grid(wday) %>%
  add_predictions(mod1, "n")

daily %>%
  ggplot(aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, color = "red", size = 4)

daily <- daily %>%
  add_residuals(mod1)

daily %>%
  ggplot(aes(date, resid, color = wday)) +
  geom_ref_line(h = 0) +
  geom_line()

daily %>% 
  filter(abs(resid)>100)

daily %>%
  ggplot(aes(date, resid)) +
  geom_ref_line(h = 0) +
  geom_line(color = "grey30") +
  geom_smooth(se = F, span = 0.2)
# TENDENCIA DE LOS ERRORES  

# Vuelos por dia de la semana y trimestre

daily%>%
  filter(wday == "sáb")%>%
  ggplot(aes(date, n))+
  geom_point()+
  geom_line()+
  scale_x_date(NULL, date_breaks = "1 month",
               date_labels = "%b")

# R: Es mas comun planear vacaciones durante la primavera que durante otoño

term <- function(date){
  cut(date, 
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring", "summer", "fall"))
}

daily <- daily%>%
  mutate(term = term(date))

daily %>%
  filter(wday =="sáb")%>%
  ggplot(aes(date, n, color = term))+
  geom_point(alpha = 0.25)+
  geom_line()+
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

daily%>%
  ggplot(aes(wday, n, color=term))+
  geom_boxplot()

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday*term, data = daily)

daily%>%
  gather_residuals(without_term = mod1, 
                   with_term = mod2)%>%
  ggplot(aes(date, resid, color = model))+
  geom_line(alpha = 0.7)# el alpha es solo para que no sea tan opaco el grafico

# Las diferencias en los residuos del modelo consideran el trimestre y otro donde no se considera
# Se esperan los residuos con mayor ruido blanco, es decir, más cercanos a la media y menos volatiles

grid <- daily%>%
  data_grid(wday, term)%>%
  add_predictions(mod2, "n")

daily%>%
  ggplot(aes(wday, n))+
  geom_boxplot()+
  geom_point(data = grid, color ="red")+
  facet_wrap(~term)
# R: Una predicion para cada trimestre segun los dias de la semana. Esto es muy poderoso.
# Pero notamos un problema de outliers, por ello crearemos otro modelo.

mod3 <- MASS::rlm(n~wday*term, 
                  data = daily)

daily%>%
  add_residuals(mod3, "resid")%>%
  ggplot(aes(date, resid))+
  geom_hline(yintercept = 0, size =2, color = "white") +
  geom_line()

# El gapminder del dr hans rosling

library(tidyverse)
library(modelr)
library(gapminder)

?gapminder

gapminder%>%
  View()

gapminder%>%
  ggplot(aes(year, lifeExp, group = country))+
  geom_line(alpha = 0.5)

gapminder%>%
  count(country)%>%
  View()

unique(gapminder$country)

mx <- filter(gapminder, country =="Mexico")

mx%>%
  ggplot(aes(year, lifeExp))+
           geom_line()+
           ggtitle("Full data = ")+
  theme(plot.title = element_text(hjust = 0.5)) # esto es solo para central el titulo

mx_mod <- lm(lifeExp~year, data = mx)
mx%>%
  add_predictions(mx_mod)%>%
  ggplot(aes(year, pred))+
  geom_line()+
  ggtitle("Full data = ")+
  theme(plot.title = element_text(hjust = 0.5))

summary(mx_mod)
tidy(mx_mod) # te arroja el modelo limpio.
?tidy 

mx%>%
  add_residuals(mx_mod)%>%
  ggplot(aes(year, resid))+
  geom_hline(yintercept = 0, color = "white", 
             size =3)+
  geom_line()+
  ggtitle("Residual pattern")+
  theme(plot.title = element_text(hjust = 0.5))

# El data frame anidado: un df dentro de un df

# Todo lo que hicimos; para no hacerlo con cada uno de los paises
# No tenemos porque hacerlo. Esto se resuelve con un df anidado

by_country <- gapminder%>%
  group_by(country, continent)%>%
  nest()

by_country
# Por asi decirlo, hemos hecho que las observaciones, con excepcion de continent y country, se vuelvan tibbles
# es decir, hemos metido dentro del df by_country un df para cada fila. Llamada "data"

by_country%>%
  View()

by_country $data[[1]] # los datos de Afgahistan son mucho más accesibles.
# Ya no se tienen observaciones, se tienen metaobservaciones.


country_model <- function(df){
  lm(lifeExp~year, data = df)
}

?map

models <- map(by_country$data, country_model)


by_country <- by_country%>%
  mutate(model = map(data, country_model))

by_country
# se ha añadido la columna model que es un lm (la funcion de regresion del lifeExp vs years)

by_country%>%
  filter(continent =="Europe")

by_country%>%
  arrange(continent, country)

by_country <- by_country%>%
  mutate(resids = map2(data, model, 
                       add_residuals))
by_country
# se ha añadido la columna resid como un tibble

# desanidar los datos 

resids <- unnest(by_country, resids)
resids
# ya los residuos no se ven como un tibble, sino como datos normales
# Ya una vez aplicada la funcion para todos los paises
# con una funcion, se puede desanidar. 

resids%>%
  ggplot(aes(year, resid))+
  geom_line(aes(group = country), 
            alpha = 0.3)+
  geom_smooth(se = F)+
  facet_wrap(~continent) # 5 graficos por continente.
# El grafico nos indica que es en Americas donde mejor se explica el modelo
# La logica es la misma, los errores y el abline del modelo ajustado a esos errores. 

# Midiendo la calidad del video con broom

library(broom)

glance(mx_mod) # es una variante de Accuracy del paquete forecast con Criterios de Info Bayesianos

# El resultado es:

# r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC deviance df.residual
#   0.985       0.984      1.05   667.     1.76e-10    2  -16.5  38.9  40.4   10.9        10

g1 <- by_country%>%
  mutate(glance = map(model, glance))%>%
  unnest(glance)%>%
  select(-data, -model, -resids)

# R: se muestran todos los valores de R^2, AIC, BIC, etc para cada pais 

g1 %>%
  View()

g1 %>%
  arrange(desc(r.squared))
# Te enseña los paises donde el R^2 de su modelo es más alto: paises como Brazil o France

g1%>%
  ggplot(aes(continent, r.squared))+
  geom_jitter(width = 0.5)
# Todos los modelos de Africa son quienes ocupan los peores lugares, todos los modelo de Oceania
# tienen un R^2 muy alto, etc.

best_fit <- filter(g1, r.squared > 0.991) # solo 26 paises superan este R^2

best_fit%>%
  View()

gapminder%>%
  semi_join(best_fit, by = "country")%>%
  ggplot(aes(year, lifeExp, color = country))+
  geom_line()

# Hago un grafico de los paises con los mejores modelos y sus year vs life expected