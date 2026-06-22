#DESCRPCIÓN: sacar correlacion de los rendientos y de los rendimientos al cuadrado

#permite leer archivos Excel
library(readxl)

# útil para manipulación de datos
library(dplyr)

#  permite mostrar tablas de forma más ordenada
library(knitr)


# ruta donde estan las bases de datos
ruta <- "C:/Users/guill/TFG/BASESDEDATOS/Arreglados/"


# vector de bases de datos
archivos <- c(
  "AUSTRALIAModBC.xlsx",
  "AUSTRALIAModSBEliminadas.xlsx",
  "AustraliaModSC.xlsx",
  "CANADAModBC.xlsx",
  "CANADAModSBEliminadas.xlsx",
  "CANADAModSC.xlsx",
  "EUROPEModBC.xlsx",
  "EUROPEModSB.xlsx",
  "EUROPEModSC.xlsx",
  "JAPANModBC.xlsx",
  "JAPANModSB.xlsx",
  "JAPANModSC.xlsx",
  "UKModBC.xlsx",
  "UKModSB.xlsx",
  "UKModSC.xlsx",
  "USAModBC.xlsx",
  "USAModSBEliminadas.xlsx",
  "USAModSC.xlsx"
)


# nombres para luego poner en las tablas
nombres <- c(
  "Bonos y Cash Australia", "Bolsa y Bonos Australia", "Bolsa y Cash Australia",
  "Bonos y Cash Canadá", "Bolsa y Bonos Canadá", "Bolsa y Cash Canadá",
  "Bonos y Cash Europa", "Bolsa y Bonos Europa", "Bolsa y Cash Europa",
  "Bonos y Cash Japón", "Bolsa y Bonos Japón", "Bolsa y Cash Japón",
  "Bonos y Cash Reino Unido", "Bolsa y Bonos Reino Unido", "Bolsa y Cash Reino Unido",
  "Bonos y Cash Estados Unidos", "Bolsa y Bonos Estados Unidos", "Bolsa y Cash Estados Unidos"
)


# Definimos una función para leer automáticamente la columna de rendimientos de cada archiv
# La función busca la primera columna cuyo nombre contenga la palabra "Rendimiento"
leer_rendimientos <- function(archivo) {
  
  # Leemos el archivo Excel correspondiente
  datos <- read_excel(file.path(ruta, archivo))
  
  # Buscamos el nombre de la columna que contiene la palabra "Rendimiento"
  col_rend <- grep(
    "Rendimiento",
    names(datos),
    ignore.case = TRUE,
    value = TRUE
  )
  
  # Si no se encuentra ninguna columna con "Rendimiento", el código se detiene y avisa
  if (length(col_rend) == 0) {
    stop(paste("No se encontró columna con 'Rendimiento' en:", archivo))
  }
  
  # Si se encuentra más de una columna, se toma la primera coincidencia
  rend <- datos[[col_rend[1]]]
  
  # Convertimos la serie de rendimientos a formato numérico
  rend <- as.numeric(rend)
  
  # Eliminamos los valores ausentes
  rend <- rend[!is.na(rend)]
  
  # Si después de limpiar la serie no queda ningún valor, el código se detiene y avisa
  if (length(rend) == 0) {
    stop(paste("La serie está vacía en:", archivo))
  }
  
  # Devolvemos la serie de rendimientos limpia
  return(rend)
}


# Aplicamos la función anterior a todos los archivos de la lista.
# El resultado es una lista donde cada elemento contiene una serie de rendimientos.
series <- lapply(archivos, leer_rendimientos)

# Asignamos a cada serie su nombre 
names(series) <- nombres


# Definimos una función para calcular autocorrelaciones: retardos 1, 2 y 5.
obtener_acf <- function(x, lags = c(1, 2, 5)) {
  
  # Calculamos la función de autocorrelación hasta el máximo retardo necesario
  acf_vals <- acf(
    x,
    lag.max = max(lags),
    plot = FALSE
  )$acf[-1]
  
  # Seleccionamos las autocorrelaciones de los retardos indicados y redondeamos a 4 decimales
  round(acf_vals[lags], 4)
}


# Creamos una tabla con las autocorrelaciones de los rendimientos r_t.
# Se calculan las autocorrelaciones para los retardos 1, 2 y 5.
tabla_rt <- data.frame(
  Serie = nombres,
  
  rho1 = sapply(series, function(x) obtener_acf(x)[1]),
  rho2 = sapply(series, function(x) obtener_acf(x)[2]),
  rho5 = sapply(series, function(x) obtener_acf(x)[3])
)


# Creamos una segunda tabla con las autocorrelaciones de los rendimientos al cuadrado r_t^2.
# Esta tabla sirve para analizar dependencia en la volatilidad o agrupamiento de volatilidad.
tabla_rt2 <- data.frame(
  Serie = nombres,
  
  rho1 = sapply(series, function(x) obtener_acf(x^2)[1]),
  rho2 = sapply(series, function(x) obtener_acf(x^2)[2]),
  rho5 = sapply(series, function(x) obtener_acf(x^2)[3])
)


# Mostramos la tabla de autocorrelaciones de los rendimientos r_t
kable(
  tabla_rt,
  digits = 4,
  col.names = c(
    "Serie",
    "rho_r(1)",
    "rho_r(2)",
    "rho_r(5)"
  )
)


# Mostramos la tabla de autocorrelaciones de los rendimientos al cuadrado r_t^2
kable(
  tabla_rt2,
  digits = 4,
  col.names = c(
    "Serie",
    "rho_r2(1)",
    "rho_r2(2)",
    "rho_r2(5)"
  )
)