# --------- Que es Machine Learning ------------

# Los algoritmos de ML se ocupan diariamente y es tan normal su uso que
# no nos damos cuenta que se trabaja con algo que ocupa algoritmos ML.
# Ejemplo:

# Deteccion de correos spam.
# Reconocimiento facil de Facebook
# La publicidad no es espionaje, sino que tanto Google y Fb aprenden tanto
# de nosotros, que son capaces de presentar algo que nos interesa.

# Lo que normalmente se aprende ML es lo siguiente:

# Se trabaja con un modelo de aprendizaje supervisado o No supervisado.Entre estos:

# Supervisado: Lineal Regression, Polynomial Regression, Support Vector Regression,
# Decision Tree Regression, Random Forest Regression, Logistic Regression, K-Nearest 
# Neighbors (K-NN), Support Vector Machine (SVM), Decision Tree Classification,
# Random Forest Classification. 

# No Supervisado: K-means Clustering, Hierarchical Clustering. 

# ---------- La historia de ML -------------

# Lineal del Tiempo: Test de Turing (habilidad de una maquina de comportarse como un humano),
# Perceptron (red neuronal de reconocimiento de patrones), Stanford crea movil autonomo, 
# DeJong crea reglas generales de entrenamiento, NetTalk, Deep Blue vence a Kasparov, Hinton
# presenta el deep learning (reconocimiento en imagenes y videos), GoogleBrain, DeepFace de Facebook. 
# 2015 quiebre estructural por el boom del ML, Amazon crea plataforma de aprendizaje automatico, 
# Microsoft crea Distributed Machine Learning Toolkit, nace openAI, openAI entrena chat bots que inventan
# su propio lenguaje para cooperar y lograr su objetivo de manera efectiva. 
# ¿Nos estamos acercando a la Inteligencia Artificial?

# ---------- Definicion de ML -------------

# El ML es la ciencia de hacer que las computadoras actuen sin estar explicitamente programadas.

# El ML se basa en algoritmos que pueden aprender de los datos sin depender de la programacion basada en reglas.

# En pocas palabras: el ML es utilizar algoritmos para que puedan decir algo interesante con base en un conjunto de
# datos sin tener que escribir ningun codigo especifico para el problema. 

# --------- Clasificacion en ML: supervisado vs no supervisado ------------

# Aprendizaje Supervisado: La maquina aprende por la data de entrenamiento que esta etiquetada.
# para luego predecir la respuesta correcta cuando se presentan nuevos objetos.
# para luego decir la respuesta correcta cuando se presenta con nuevos ejemplo. 
# Se dice que el lenguaje supervisado es simil al aprendizaje de un maestro, donde este mediante
# ejemplos, el alumno memoriza y luego obtiene reglas generales.
# Ejemplo, le das data de entrenamiento en tu computadora, donde le enseñas, por ejemplo, la imagen de un
# animales y le indicas que animal es, una vez que se introduzca un animal nuevo sin indicar cual es, al algoritmo,
# segun lo que haya aprendido del entrenamiento, es como respondera. 

# Aprendizajo No Supervisado. La data de entrenamiento no se encuentra etiquetada, es decir, es cuando
# un algoritmo aprende de ejemplos simples, sin ningun respuesta asociada, dejando que el algoritmo determine
# los patrones de los datos que reconozca por si mismo. 
# Ejemplo: introducimos data en nuestro algoritmo no supervisado, este estudia la data y la agrupa en similitudes y
# una vez que le demos nueva info, este algoritmo clasificara esta data donde las caracteristicas hagan match.

# Aprendizaje Reforzado: La maquina aprende por su cuenta. (Ensayo y error, es decir, aprende a traves de sus errores)

# Aprendizaje de procesamiento de lenguaje natural: formula mecanismos eficaces para la comunicacion entre personas y 
# maquinas por medio de lenguajes naturales. 

# Deep Learning: Conjunto de algoritmos de ML que intentan modelar abstacciones de alto nivel en datos usando
# arquitecturas compuestas. Este requiere big data y tecnologia de punta para procesar dichos algoritmos. 


# ------ Temas Fundamentales de ML ----------------

#  ---- Lineal Regression:
# Este es el algoritmo más basico de ML, aunque bastante util y utilizado. 
# Establece dependencia y relaciones entre las variables ya sea mediante Regresion Simple o Multiple.  

# ---- Polynomail Regression:
# Cuando se tienen datos no lineales se puede ocupar la regresion polinomial o no lineal, modela la relacion entre 
# las variables dependiente y las variables independientes como un polinomio de orden n. 

# Polinomio es una expresion matematica constituida por una finita de productos entre variables y constantes, que pueden
# tener exponentes y cuyo valor maximo se conocera como grado del polinomio. Se debe estar experimentando con el grado del 
# polinomio segun que tan bien se ajusta a la relacion entre las variables.

# ---- Support Vector Regression:
# Este algoritmo se puede ocupar desde regresion hasta clasificacion. 
# En la regresion, se construye una curva o hiperplano que modele la tendencia de los datos, despues se trazan las bandas 
# inferiores y superiores (del mismo ancho), donde a la suma de las distancias se le llama maximo margen, y se espera que con estas
# banda se cubra el mayor numero de datos posible, y para aquellos datos que no son cubiertos, se les relaciona con la banda mas cercana,
# y a esta distancia entre la banda y el dato se le llama error, y son aquellos valores fuera del rango los que afectan la formula final, 
# mientras los valores dentro del rango son ignorados para la formula final. Aqui la diferencia con regresion lineal, es que no se trata de
# una linea, sino de un rango. Se basa en buscar la curva, con su respectivo maximo margen, que modele la tendencia de los datos. 

# ¿Que pasa si el problema no es lineal? Aqui no se espera una relacion lineal, ya que el algoritmo se basa en encontrar
# la curva y su maximo margen (rango) que mejor se adapte a los datos. Y claro, las bandas o rangos tendran la misma forma de la curva. 

# Los supuestos del algoritmo: Los datos deben estar limpios, es sensible a valores atipicos, no es adecuado para conjunto de datos grandes ya 
# que el tiempo de entrenamiento puede ser alto. 
# Es menos efectivo en conjunto de datos muy similares.

# ----- Decision Tree Regression:

# Este algoritmo se puede utilizar para problemas tanto de regresion como de clasificacion. 
# En regresion: La base de este algoritmo es que se evaluan todas las variables de entrada y todos los puntos
# de division de los datos, elegiendo el mejor de todos. 
# La estructura es la siguiente:

# El algoritmo comienza con una condicion base, el cual seria el tronco del arbol, de esa condicion deben salir 2 respuestas
# si se cumple o si no se cumple, si se cumple habra una nueva condicion, y si no lo hace tambien habra otra condicion, y de aqui se derivan
# otras condiciones que dependeran de la cantidad de datos que se tengan disponibles. 

# El nodo raiz es la primera condicion de todo el algoritmo, de ahi las ramas se les conoce como nodos de prueba, es decir, todas las 
# condiciones y pruebas que se requieren para llegar a un resultado. Y finalmente se tienen los nodos de decision que serian el resultado o prediccion
# de nuestro algoritmo.

# Al ser un algoritmo supervisado, se debe indicar una variable dependiente para la regresion, y las variables independientes.
# Ejemplo de como funciona el algoritmo:
# Si tenemos un conjunto de datos que no forma ningun patron en especifico sino que se comportan de manera completamente aletoria, por ello, lo que se hace 
# es separar los datos, esto en secciones aleatorias, sin patrones especificos, y podemos realizar tantas separaciones de los datos como nos parezcan, al final,
# cada una de estos subconjuntos o separaciones, sera una condicion dentro de nuestro algoritmo, y de esta manera construiremos nuestro arbol de decision. 

# Se comieza con una separacion inicial, y ese sera el nodo raiz, por ejemplo (El eje X menor a 30 (valores aleatorio del eje)), 
# y asi continuamos creando separaciones y por ende condiciones, donde cada espacio separado sera una zona (por ejemplo Zona A, Zona B, etc)
# y a cada zona se le calculara su promedio. Y esos promedios iran en los nodos de decision, al final.

# Para un nuevo valor pronosticado, este entrara en el algoritmo e ira pasando condiciones hasta caer en la zona que pertenece 
# y se pronosticara su valor segun el promedio de la zona. Lo importante hacer una buena separacion de datos.

# La salida es muy facil de entender, se pueden crear nuevas variables o caracteristicas que tengan mejor poder predictivo, este algoritmo requiere menos limpieza
# de los datos ya que no esta influenciado por valores atipicos y faltantes. 
# Se pueden trabajar con variables categoricas o cuantitativas.

# Desventaja: No es apto para variables continuas (se pierde informacion).

# ---- Random Forest Regression:

# Este se puede utilizar para regresion y clasificacion.
# Como su nombre lo sugiere, este algoritmo crea un bosque con varios arboles de decision,y entre mayor sea el numero de arboles
# de decision mayor sera la preciosion de este algoritmo. 
# Ejemplo si tenemos una data, la cual la dividimos en 3 para crear 3 arboles de decision, estos tienen sus subdivisiones o 
# nodos de prueba y sus nodos de decision. Cuando se tengan las decisiones de cada uno de los arboles, se juntan esas decisiones 
# que sigan los mismos ejemplos y se calcula el promedio. 

# Beneficios: manejar grandes cantidades de datos, metodo efectivo para estimar datos faltantes,
# hace un buen trabajo de clasificacion, sin embargo, no predice mas alla del rango en los datos de entrenamiento, y sobreajusta 
# los conjuntos de datos que son particularmente ruidosos. 

# ------Logistic Regression:

# Este es un algoritmo de clasificacion, a pesar de llevar en su nombre la palabra regresion.
# La regresion logistica es un clasificador binario, utiliza una funcion para predecir la probabilidad de que la respuesta a alguna
# pregunta sea 1 o 0, si o no, verdadero falso, bueno o malo. 
# Esto predice la probabilidad de clasificar en un grupo o en otro grupo.

# Las variable de salida es binaria 
# No asume errores en variable de salida, eliminando las instancias mal clasificadas de los datos de entrenamiento.
# Es un algoritmo lineal, con una transformacion no lineal de salida. 
# Es un algoritmo que requiere de una gran cantidad de datos para dar resultados consistentes. 

# La regresion logistica es ampliamente utlizada, a pesar de los algoritmos avanzados como redes neuronales, es porque es 
# muy eficientes y no requiere demasiados recursos computacionales. 

# ---- K-nearest Neighbors:

# El algoritmo de vecinos mas cercanos es un algoritmo de clasificacion. Ejemplo, si se tienen 2 tipos de datos, 
# como su nombre lo indica, lo que se verificamos son los datos más cercanos de un punto especifico y esta sera la respuesta
# a nuestro problema. 

# Lo que se hace primero, por ejemplo con un punto X que buscamos clasificar, asignamos un valor de K, es decir de vecinos, si 
# por ejemplo K = 1, se tomara a 1 solo vecino más cercano, y el valor de este vecino cercano, dadas las caracteristicas, 
# sera el valor de nuestro punto X, y esa sera la respuesta, aunque un K tan chico puede ser contraproducente. Se espera que el 
# valor de K siempre sea mayor a 1. Si se tienen por ejemplo 2 posibles resultados, Buen Pagador y Mal Pagador, el valor mayoritario sera
# el resultante, ejemplo 2 Buen Pagador, 1 Mal Pagador. 
# En caso de que los valores sean los mismos (poco comun), los resultados seran inconsistentes, esto tambien indica que no siempre es
# bueno aumentar tanto K. Lo importante de esto es probar con varios valores de K y promediar cual es la mejor o como se clasifica más. 

# Este es un algoritmo de clasificacion muy simple, aunque puede dar resultados altamente competitivos. 
# A menudo se usa como punto de referencia para clasificadores mas complejos como redes neuronales y maquinas de vector de soporte. 

# No hace suposiciones explicitas sobre la forma funcional de los datos, evitando los peligros de la distribucion subyacente de los datos.

# El algoritmo no aprende de un modelo, sino que memoriza la instancias de capacitacion posteriormente como conocimiento para la face de prediccion. 
# Es decir, solo cuando se solicite una predicciom, el algoritmo usara los datos para generar una respuesta

# Es un algoritmo computacionalmente costoso ya que el algoritmo debe almacenar todos los datos de entrenamiento. 

# --------- Support Vector Machine

# Este es un algoritmo de clasificacion aunque tambien puede ser utilizado para la regresion. 
# Support Vector Machine es la parte de clasificiacion y Support Vector Regression es la parte de Regresion. 

# Este algoritmo es un clasificador discriminatorio. Dados los datos de entrenamiento etiquetados (aprendizaje supervisado), el algoritmo genera un 
# hiperplano optimo que clasifica los nuevos ejemplos en 2 espacios dimensionales. Este hiperplano es una linea que divide un plano en 2 partes donde
# en cada clase se encuentra en cada lado. 

# Support Vector Machine es un clasificador discriminatorio definido por un hiperplano de separacion. 

# Ejemplo, se tienen 2 tipos de datos y lo que se debe definir es donde estara la division el hiperplano que separe los datos
# Una vez definido el hiperplano (el cual se debe colocar en la mejor posicion posible), se generan 2 lineas paralelas, tanto en
# el lado positivo, como en el negativo, estas lineas se crean utilizando los vectores de soporte, es decir, los datos de ambos planos 
# más cercanos al hiperplano se utilizaran como soportes para crear el hiperplano positivo y en negativo. Es decir los rangos toparan 
# hasta encontrarse con los valores más cercanos, los cuales fungiran el papel de soporte (que a su vez son vectores), a este rango positivo
# y negativo se conoce como maximo margen.

# Todo lo que cae en cada uno de los hiperplanos sera clasificado igual a los datos correspondientes a ese hiperplano. 
# Ejemplo si se tienen datos de perros y gatos de diferente raza y se traza un hiperplano que los clasifica, si tenemos un nuevo valor
# por ejemplo, un nuevo perro y graficandolo cae en el hiperplano donde se clasifico a los perros, esa sera su prediccion. 

# ¿Que pasa si los datos no son lineales? 

# Este algoritmo permite utilizar funciones llamadas Kernel en donde se pueden llevar los datos al espacio, en donde convierte el hiperplano
# en una solucion lineal lo que hace mas sencillo utilizar este modelo. 
# SVM permite utilizar las llamadas funciones Kernel (no lineales). Estas funciones resuelven el problema de clasificacion 
# trasladando los datos a un espacio donde el hiperplano solucion es lineal y, por lo tanto mas sencillo de obtener. 
# Aunque, una vez conseguida la solucion, se transforma de nuevo, al espacio original.

# Para datos linealmente separables, SVM funciona increiblemente bien. 
# Para los datos que son casi linealmente separables, SVM puede funcionar bien con el valor correcto del hiperplano. 

# Para los datos que no son separables linealmente, podemos proyectar los datos mediante funciones Kernel donde se vuelven 
# perfectamente o casi linealmente separables.

# Con linealmente separables se refiere a que una linea puede dividir el plano y distinguir facilmente los valores. 

# ------- Decision Tree Classification:

# Esta es la parte de clasificacion del Decisicion Tree Regression.

# Es un algoritmo de supervision en donde dividimos los datos o muestra en 2 o mas conjuntos homogeneos basados en el diferenciador
# mas significativo en las variables de entrada. El arbol de decision identifica la variable mas significativa y su valor que proporciona 
# los mejor conjuntos homogeneos de poblacion. Todas las variables de entrada y todos los puntos de decision posible se evaluan y se elige
# la que tenga mejor resultado.

# La variable mas significativa se encontrara en la base del algoritmo, creando 2 condiciones y a partir de estas se generan 2 posibles opciones, 
# si esta condicion es positiva o negativa y de ahi se desprenden nuevas condiciones. La cantidad de opciones a evaluar, dependera de la cantidad 
# de variables independientes que contemos. Al final de realizar la evaluacion a todas las caracteristicas nos quedara un algoritmo en formad de arbol.

# Al igual que la regresion, la primera condicion es el nodo raiz, de ahi le siguen los nodos de prueba, (condiciones que se deben evaluar) y finalmente
# estan los nodos de decision que seran el resultado o prediccion del algoritmo. 

# Aqui, al igual que en regresion se dividen los datos los cuales estan muy dispersos y se empiezan a crear condiciones, es decir separaciones. 
# La diferencia con regresion, es que al introducir un bueno valor, el cual pasara por el algoritmo, es que su respuesta no sera el valor promedio 
# de la zona en la que sea asignado, sino que su respuesta sera categorica, por ejemplo si cae en la Zona B y la Zona B es Mal Pagador, o "Blanco" en lugar de
# "Negro" es asi como clasificara. 

# Ejemplo, este algoritmo podria predecir si una persona puede vivir o morir en el hundimiento de un barco tomando en cuenta la edad, el sexo y su ubicacion
# en el barco, por el contrario no se podria predecir el valor de una accion, dado que ese resultado numero seria para la regresion. 

# ----- Random Forest Classification:

# Este es el algoritmo clasificador de Random Forest Regression. 

# Al igual que en regresion, se cultivan varioa arboles en lugar de 1 solo arbol, para clasificar un nuevo objeto basado en atributos. 
# Cada arbol da una clasificacion y finalmente el bosque elige la clasificacion con más votos. 
# Aqui, a diferencia de las regresiones, no se saca un promedio de resultados sino se toman en cuenta las clasificaciones de cada arbol
# y segun cada voto sera la clasificacion o prediccion de una nueva variable. 
# Ojo: este algoritmo puede parecer una caja negra en principio, dado que se tiene muy poco control sobre lo que hace el modelo, sin embargo,
# se precisa hacer varias pruebas, con diferentes parametros y datos aleatorios para identificar el comportamiento del algortimo.

# ---- K-means Clustering

# K-means es un tipo de aprendizaje no supervisado, que se utiliza cuando se tienen datos no etiquetados, es decir, datos sin categorias o grupos definidos.
# El objetivo de este algoritmo es ecnontrar grupos en los datos. Los puntos de datos se agrupan segun sus similitudes en caracteristicas.

# Aqui a diferencia de todos los algoritmos anteriores, se cuenta unicamente con variables indenpendientes (no hay datos etiquetados).
# Paso 1. Seleccionar el numero de cluster o agrupaciones que deseas identificar los datos, por ejemplo K = 3.
# Paso 2. Seleccionar al azar K puntos. No necesariamente deben ser puntos de nuestros datos, pueden ser puntos nuevos. 
# Paso 3. Medimos la distancia entre cada uno de los datos y los centroides, asignandole el punto que se encuentra mas cerca.

# Es decir, se asigna un centroide aleatorio y segun los puntos mas cercanos a ese centroide es como esa variable se clasificara en ese cluster, 
# el proceso de debe repetir varias veces para tomar distintos centroides y encontrar nuevas clasificaciones, segun las diferentes clasificaciones, sera
# el algoritmo el que, con base en las iteraciones elige la mejor clasificacion posible.

# Los centroides pueden ser puntos de nuestra data o nuevos puntos, donde se ubican en posiciones aletorias varias veces.
# El analisis se empieza a detener cuando se encuentran, a traves de las iteraciones, respuestas repetidos en analisis consecutivos.

# El un algoritmo rapido, robusto y simple. Que proporciona resultados confiables cuando los conjuntos de datos son distintos o bien
# separados linealmente entre si. Se utiliza mejor cuando se especifica el numero de centros de cluster debido a una lista bien definida de
# tipos que se muestran en los datos. 

# La agrupacion puede no funcionar bien si contiene datos muy superpuestos o si los datos son ruidosos o estan llenos de valores atipicos.

# ---- Hierarchical Clustering:

# Agrupamiento Jerarquico consiste en agrupar o segmentar una coleccion de objeto en subconjuntos o clusteres, de modo que los que estan dentro de 
# cada grupo estan mas estrechamente relacionados con unos a otros que los objetos asignados a diferentes grupos. 

# Solo se utilizan variables idenpendientes, es decir, no hay data etiquetada. 

# paso 1. Asignar a cada elemento un cluster, de modo que si tiene N elementos, ahora tiene N clusteres, cada uno con un solo elemento.
# paso 2. encuentre el par mas cercano de clusteres y combinelos en un unico cluster, de modo que ahora tengo un cluster menos. 
# paso 3. Recalcular las distancias entre el nuevo cluster y cada uno de los clusteres antiguos. 
# paso 4. Repetir los pasos 2 y 3 hasta que todos los elementos esten agrupados en un solo grupo de tamaño N.
# paso 5. cada combinacion de cluster que se realizo se debe representar mediante un dendograma el cual representara las combinaciones de las mas 
# generales (1 solo cluster), o 2 clusters hasta las mas particulares en N clusters, es decir representa las posibles combinaciones de clusters 
# que hay en nuestra data.

# ¿Como sabemos cual es la separacion mas adecuada? buscando las distancias mas largas de los datos. En el dendograma se trata de la que 
# contenga la linea mas larga sin cortes. Ejemplo si en el dendograma que divide la data en 2 clusters, y esa linea es la mas larga y sin cortes, esa
# sera la mejor separacion posible. 

# Las variables puede ser cuantitativas, binarias o de recuento. (aunque no se sugiere con grandes diferencias en escala)
# La omision de variables influyentes puede dar como resultado una solucion engañosa. Los resultados deben tratarse como tentativos hasta que confirme 
# con una muestra independiente. 
