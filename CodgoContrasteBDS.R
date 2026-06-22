# DESCRIPCIÓN: test BDS para todas las baes de datos

library(readxl)
library(dplyr)
library(writexl)
library(tseries)

#Ruta y archivos

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


# función para encontrar la columna que contenga la palabra rendimientos

obtener_rendimientos <- function(datos) {
  
  nombres <- names(datos)
  
  # Busca la columna que contenga la palabra "Rendimiento"
  indice <- grep("rendimiento", nombres, ignore.case = TRUE)
  
  if (length(indice) == 0) {
    stop(paste(
      "No encuentro ninguna columna que contenga la palabra Rendimiento. Columnas disponibles:",
      paste(nombres, collapse = ", ")
    ))
  }
  
  columna_usada <- nombres[indice[1]]
  
  x <- datos[[indice[1]]]
  
  # Conversión robusta a numérico
  x <- as.character(x)
  x <- gsub(",", ".", x)
  x <- as.numeric(x)
  x <- x[!is.na(x)]
  
  return(list(
    serie = x,
    columna = columna_usada
  ))
}

# test bds con diferentes m ( al final en la tabla solo ponemos 2, 3 ,5)

aplicar_bds <- function(serie, m_values = c(2, 3, 4, 5, 6), alpha = 0.05) {
  
  serie <- as.numeric(serie)
  serie <- serie[!is.na(serie)]
  
  epsilon <- sd(serie)
  
  resultados <- data.frame()
  
  for (m in m_values) {
    
    resultado <- tryCatch({
      
      test <- bds.test(
        serie,
        m = m,
        eps = epsilon
      )
      
      estadistico <- as.numeric(test$statistic)[length(test$statistic)]
      p_valor <- as.numeric(test$p.value)[length(test$p.value)]
      
      decision <- ifelse(
        p_valor < alpha,
        "Se rechaza H0: la serie no es iid",
        "No se rechaza H0: no hay evidencia suficiente contra iid"
      )
      
      data.frame(
        m = m,
        epsilon = epsilon,
        Estadistico_BDS = estadistico,
        p_valor = p_valor,
        alpha = alpha,
        Decision = decision
      )
      
    }, error = function(e) {
      
      data.frame(
        m = m,
        epsilon = epsilon,
        Estadistico_BDS = NA,
        p_valor = NA,
        alpha = alpha,
        Decision = paste("ERROR:", e$message)
      )
    })
    
    resultados <- rbind(resultados, resultado)
  }
  
  return(resultados)
}

# se aplica a todos los archivos

resultados_bds <- data.frame()

for (archivo in archivos) {
  
  ruta_completa <- paste0(ruta, archivo)
  
  resultado_archivo <- tryCatch({
    
    datos <- read_excel(ruta_completa)
    
    info <- obtener_rendimientos(datos)
    
    rendimientos <- info$serie
    columna_usada <- info$columna
    
    res <- aplicar_bds(
      serie = rendimientos,
      m_values = c(2, 3, 4, 5, 6),
      alpha = 0.05
    )
    
    res$Archivo <- archivo
    res$Columna_usada <- columna_usada
    res$N_observaciones <- length(rendimientos)
    
    res
    
  }, error = function(e) {
    
    data.frame(
      m = NA,
      epsilon = NA,
      Estadistico_BDS = NA,
      p_valor = NA,
      alpha = 0.05,
      Decision = paste("ERROR:", e$message),
      Archivo = archivo,
      Columna_usada = NA,
      N_observaciones = NA
    )
  })
  
  resultados_bds <- rbind(resultados_bds, resultado_archivo)
}

# Reordenar columnas
resultados_bds <- resultados_bds[, c(
  "Archivo",
  "Columna_usada",
  "N_observaciones",
  "m",
  "epsilon",
  "Estadistico_BDS",
  "p_valor",
  "alpha",
  "Decision"
)]

print(resultados_bds)

# guardar resultados
write_xlsx(
  resultados_bds,
  "C:/Users/guill/TFG/resultados_bds.xlsx"
)
