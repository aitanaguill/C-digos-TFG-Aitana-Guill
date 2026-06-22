# Cargamos la librería necesaria para leer archivos Excel
library(readxl)

# Ruta donde están guardadas las bases de datos ya imputadas con MissForest
ruta <- "C:/Users/guill/TFG/BASESDEDATOS/MissForest/todos"

# Obtenemos todos los archivos Excel de la carpeta
archivos <- list.files(
  path = ruta,
  pattern = "\\.xlsx$",
  full.names = FALSE
)

# Creamos una tabla vacía donde se guardarán los resultados
resultados <- data.frame()

# Recorremos todos los archivos Excel encontrados en la carpeta imputada
for (archivo in archivos) {
  
  # Construimos la ruta completa del archivo
  path <- file.path(ruta, archivo)
  
  # Leemos el archivo Excel
  df <- read_excel(path)
  
  # Calculamos el número total de celdas de la base
  total_celdas <- nrow(df) * ncol(df)
  
  # Calculamos el número total de valores faltantes después de MissForest
  missing <- sum(is.na(df))
  
  # Calculamos el porcentaje de valores faltantes después de MissForest
  porcentaje <- (missing / total_celdas) * 100
  
  # Guardamos los resultados de esta base en una fila
  temp <- data.frame(
    Base = archivo,
    Total_celdas = total_celdas,
    Valores_faltantes_despues_MissForest = missing,
    Porcentaje_valores_faltantes_despues_MissForest = round(porcentaje, 2)
  )
  
  # Añadimos la fila a la tabla final
  resultados <- rbind(resultados, temp)
}

# Mostramos la tabla final
print(resultados)