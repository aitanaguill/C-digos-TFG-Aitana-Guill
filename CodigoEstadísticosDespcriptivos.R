# DESCRIPCIÓN:
# Cálculo de estadísticos descriptivos de los rendimientos de todas las bases de datos

# Cargamos las librerías necesarias
library(readxl)
library(moments)

# ruta donde se encuentran las bases de datos
ruta <- "C:/Users/guill/TFG/BASESDEDATOS/Arreglados/"

# lista de bases de datos dentro de la ruta anterior:
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

# tabla vacía donde se guardan los resultados
resultados <- data.frame()

# bucle para procesar cada archivo
for (archivo in archivos) {
  
  # se lee el archivo
  datos <- read_excel(paste0(ruta, archivo))
  
  # nombre de la segunda columna, correspondiente a la variable de rendimientos
  nombre_columna <- names(datos)[2]
  cat("Variable analizada:", nombre_columna, "\n")
  
  # se coge la segunda columna, la de rendimientos
  x <- datos[[2]]
  
  # limpieza de la variable ( valores faltantes) y se pasa a númerico sino lo estuviese
  x <- as.character(x)
  x <- gsub(",", ".", x)
  x <- gsub("%", "", x)
  x <- trimws(x)
  x[x %in% c("NA", "N/A", "#N/A", "N/D", "ND", "", " ")] <- NA
  x <- as.numeric(x)
  
  # número de observaciones válidas
  n_validos <- sum(!is.na(x))
  
  # cálculo de estadísticos descriptivos con la función predeterminada de R
  media <- mean(x, na.rm = TRUE)
  desv_tipica <- sd(x, na.rm = TRUE)
  
  asimetria <- if (n_validos > 2) {
    skewness(x, na.rm = TRUE)
  } else {
    NA
  }
  
  curtosis <- if (n_validos > 3) {
    kurtosis(x, na.rm = TRUE)
  } else {
    NA
  }
  

  # se guarda en la base de datos actual
  temp <- data.frame(
    Base = archivo,
    Variable = nombre_columna,
    Observaciones = n_validos,
    Media = media,
    Desv_Tipica = desv_tipica,
    Asimetria = asimetria,
    Curtosis = curtosis
  )
  
  # se añaden a la tabla final los resultados
  resultados <- rbind(resultados, temp)
}

# se guardan los resultados en un archivo CSV (OPCIONAL)
write.csv(
  resultados,
  paste0(ruta, "rendimientos_estadisticos.csv"),
  row.names = FALSE
)

cat("\nProceso completado correctamente.\n") #para saber que hemos terminado

# Mostrar la tabla final
print(resultados)