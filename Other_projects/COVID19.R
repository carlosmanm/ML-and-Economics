
install.packages("COVID19")
library(COVID19)

Mex <- COVID19::covid19(country = "Mexico", raw = F)
View(Mex)

?covid19


attach(X)

names(X)

ggplot(Mex,aes(con, tests))+
  geom_point()
