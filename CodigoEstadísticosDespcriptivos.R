# DESCRIPCIÓN:
# Cálculo de estadísticos descriptivos de los rendimientos de todas las bases de datos Excel utilizadas en el TFG.

# Cargamos las librerías necesarias
library(readxl)
library(moments)

# Ruta donde se encuentran las bases de datos
ruta <- "C:/Users/guill/TFG/BASESDEDATOS/Arreglados/"

# Lista de bases de datos a analizar
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

# Tabla vacía donde se almacenarán los resultados
resultados <- data.frame()

# Bucle para procesar cada archivo
for (archivo in archivos) {
  
  # Lectura del archivo Excel
  datos <- read_excel(paste0(ruta, archivo))
  
  # Nombre de la segunda columna, correspondiente a la variable de rendimientos
  nombre_columna <- names(datos)[2]
  cat("Variable analizada:", nombre_columna, "\n")
  
  # Selección de la segunda columna
  x <- datos[[2]]
  
  # Limpieza de la variable y conversión a formato numérico
  x <- as.character(x)
  x <- gsub(",", ".", x)
  x <- gsub("%", "", x)
  x <- trimws(x)
  x[x %in% c("NA", "N/A", "#N/A", "N/D", "ND", "", " ")] <- NA
  x <- as.numeric(x)
  
  # Número de observaciones válidas
  n_validos <- sum(!is.na(x))
  
  # Cálculo de estadísticos descriptivos con la función predeterminada de R
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
  

  # Guardar los resultados de la base actual
  temp <- data.frame(
    Base = archivo,
    Variable = nombre_columna,
    Observaciones = n_validos,
    Media = media,
    Desv_Tipica = desv_tipica,
    Asimetria = asimetria,
    Curtosis = curtosis
  )
  
  # Añadir los resultados a la tabla final
  resultados <- rbind(resultados, temp)
}

# Guardar los resultados en un archivo CSV (OPCIONAL)
write.csv(
  resultados,
  paste0(ruta, "rendimientos_estadisticos.csv"),
  row.names = FALSE
)

cat("\nProceso completado correctamente.\n") #para saber que hemos terminado

# Mostrar la tabla final
print(resultados)