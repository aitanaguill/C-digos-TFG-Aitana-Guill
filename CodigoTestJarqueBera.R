#DESCRIPCIÓN: test de jarque bera en todas las bases de datos

# Cargamos la librería que permite leer archivos Excel
library(readxl)

# Cargamos la librería que contiene el test de Jarque-Bera
library(tseries)

# Indicamos la carpeta donde están guardadas todas las bases de datos
ruta <- "C:/Users/guill/TFG/BASESDEDATOS/Arreglados/"

# Creamos una lista con los nombres de todos los archivos Excel que vamos a analizar
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

# Creamos una tabla vacía donde se irán guardando los resultados del test
resultados_jb <- data.frame()

# Iniciamos un bucle para repetir el mismo proceso con cada archivo de la lista
for (archivo in archivos) {
  
  # Leemos el archivo Excel y lo guardamos en datos
  datos <- read_excel(paste0(ruta, archivo))
  
  # Si el nombre del archivo contiene BC, buscamos la columna correspondiente a Bonos y Cash
  if (grepl("BC", archivo)) {
    col_obj <- grep("Bonos.*Cash|Bonds.*Cash|BC", names(datos), ignore.case = TRUE, value = TRUE)
    
    # Si el nombre del archivo contiene SB, buscamos la columna correspondiente a Bolsa y Bonos
  } else if (grepl("SB", archivo)) {
    col_obj <- grep("Bolsa.*Bonos|Stocks.*Bonds|Stock.*Bond|SB", names(datos), ignore.case = TRUE, value = TRUE)
    
    # Si el nombre del archivo contiene SC, buscamos la columna correspondiente a Bolsa y Cash
  } else if (grepl("SC", archivo)) {
    col_obj <- grep("Bolsa.*Cash|Stocks.*Cash|Stock.*Cash|SC", names(datos), ignore.case = TRUE, value = TRUE)
    
    # Si el archivo no contiene BC, SB ni SC, dejamos la columna objetivo vacía
  } else {
    col_obj <- character(0)
  }
  
  # Comprobamos si no se ha encontrado ninguna columna de rendimientos
  if (length(col_obj) == 0) {
    
    # Avisamos en consola de que no se ha encontrado la columna
    cat("NO se ha encontrado la columna de rendimientos.\n")
    
    # Mostramos los nombres de todas las columnas disponibles en esa base
    cat("Columnas disponibles en esta base:\n")
    print(names(datos))
    
    # Saltamos esta base y pasamos directamente al siguiente archivo
    next
  }
  
  # Si se han encontrado varias columnas posibles, nos quedamos con la primera
  col_obj <- col_obj[1]
  
  # Mostramos en consola qué columna se va a analizar
  cat("Columna analizada:", col_obj, "\n")
  
  # Extraemos la columna de rendimientos seleccionada
  x <- datos[[col_obj]]
  
  # Convertimos la serie a texto para poder limpiar comas, espacios y valores no válidos
  x <- as.character(x)
  
  # Sustituimos las comas decimales por puntos decimales
  x <- gsub(",", ".", x)
  
  # Eliminamos espacios en blanco al principio y al final de cada valor
  x <- trimws(x)
  
  # Convertimos valores no válidos o vacíos en NA
  x[x %in% c("NA", "N/A", "#N/A", "N/D", "ND", "", " ")] <- NA
  
  # Convertimos la serie limpia a formato numérico
  x <- as.numeric(x)
  
  # Eliminamos los valores ausentes antes de aplicar el test
  x <- na.omit(x)
  
  # Comprobamos que haya suficientes observaciones para aplicar el test
  if (length(x) < 3) {
    
    # Avisamos si la serie tiene demasiados pocos datos
    cat("No hay suficientes observaciones para aplicar el test.\n")
    
    # Saltamos esta base y pasamos al siguiente archivo
    next
  }
  
  # Aplicamos el test de Jarque-Bera a la serie de rendimientos
  jb <- jarque.bera.test(x)
  
  # Mostramos en consola el estadístico del test
  cat("Estadístico JB:", jb$statistic, "\n")
  
  # Mostramos en consola el p-valor del test
  cat("p-valor:", jb$p.value, "\n")
  
  # Creamos una tabla temporal con los resultados de la base actual
  temp <- data.frame(
    Base = archivo,
    Columna = col_obj,
    Estadistico_JB = as.numeric(jb$statistic),
    p_valor = as.numeric(jb$p.value)
  )
  
  # Añadimos los resultados de esta base a la tabla final
  resultados_jb <- rbind(resultados_jb, temp)
}

# Guardamos la tabla final de resultados en un archivo CSV
write.csv(
  resultados_jb,
  paste0(ruta, "jarque_bera_resultados.csv"),
  row.names = FALSE
)

# Mostramos un mensaje indicando que el proceso ha terminado correctamente
cat("\nProceso completado correctamente.\n")

# Mostramos en consola la tabla final con todos los resultados
print(resultados_jb)