install.packages("writexl")
library(readxl)
library(dplyr)
library(writexl)

# ruta y todos los archivos

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
# variable objetivo:

obtener_rendimientos <- function(datos) {
  
  nombres <- names(datos)
  
  # Busca cualquier columna que contenga "Rendimiento"
  indice <- grep("rendimiento", nombres, ignore.case = TRUE)
  
  if (length(indice) == 0) {
    stop(paste(
      "No encuentro ninguna columna que contenga la palabra Rendimiento. Columnas disponibles:",
      paste(nombres, collapse = ", ")
    ))
  }
  
  # Si hay varias, toma la primera
  x <- datos[[indice[1]]]
  
  # Convertir a numérico de forma robusta
  x <- as.character(x)
  x <- gsub(",", ".", x)
  x <- as.numeric(x)
  x <- x[!is.na(x)]
  
  return(x)
}

# Se define la función Hurst

hurst_gm2 <- function(rendimientos, alpha = 0.05, min_block = 5, max_block = NULL) {
  
  rendimientos <- as.numeric(rendimientos)
  rendimientos <- rendimientos[!is.na(rendimientos)]
  
  if (length(rendimientos) < 50) {
    return(data.frame(
      Hurst = NA,
      Estadistico = NA,
      p_valor = NA,
      alpha = alpha,
      Decision = "Serie demasiado corta"
    ))
  }
  
  # Reconstrucción de log-precios acumulados
  log_precios <- cumsum(rendimientos)
  
  N <- length(log_precios)
  
  if (is.null(max_block)) {
    max_block <- floor(N / 2)
  }
  
  # Tamaños de subintervalos
  n_values <- unique(floor(seq(min_block, max_block, length.out = 20)))
  n_values <- n_values[n_values >= min_block]
  
  Hn_values <- c()
  n_used <- c()
  
  for (n in n_values) {
    
    num_blocks <- floor(N / n)
    
    if (num_blocks < 2) next
    
    rangos <- c()
    
    for (i in 1:num_blocks) {
      
      inicio <- (i - 1) * n + 1
      fin <- i * n
      
      bloque <- log_precios[inicio:fin]
      
      # GM2: rango de los log-precios en cada subintervalo
      rango <- max(bloque, na.rm = TRUE) - min(bloque, na.rm = TRUE)
      
      if (!is.na(rango) && rango > 0) {
        rangos <- c(rangos, rango)
      }
    }
    
    # H_n: media de los rangos
    Hn <- mean(rangos, na.rm = TRUE)
    
    if (!is.na(Hn) && Hn > 0) {
      Hn_values <- c(Hn_values, Hn)
      n_used <- c(n_used, n)
    }
  }
  
  if (length(Hn_values) < 3) {
    return(data.frame(
      Hurst = NA,
      Estadistico = NA,
      p_valor = NA,
      alpha = alpha,
      Decision = "No hay suficientes subintervalos válidos"
    ))
  }
  
  # Regresión log(H_n) = log(c) + H log(n)
  modelo <- lm(log(Hn_values) ~ log(n_used))
  
  H <- as.numeric(coef(modelo)[2])
  se_H <- summary(modelo)$coefficients[2, 2]
  
  # Contraste H0: H = 0.5
  estadistico <- (H - 0.5) / se_H
  
  # p-valor bilateral
  p_valor <- 2 * (1 - pnorm(abs(estadistico)))
  
  decision <- ifelse(
    p_valor < alpha,
    "Se rechaza H0: existe memoria a largo plazo",
    "No se rechaza H0: no hay evidencia suficiente de memoria a largo plazo"
  )
  
  return(data.frame(
    Hurst = H,
    Estadistico = estadistico,
    p_valor = p_valor,
    alpha = alpha,
    Decision = decision
  ))
}


resultados_hurst <- data.frame()

for (archivo in archivos) {
  
  ruta_completa <- paste0(ruta, archivo)
  
  resultado <- tryCatch({
    
    datos <- read_excel(ruta_completa)
    
    rendimientos <- obtener_rendimientos(datos)
    
    res <- hurst_gm2(
      rendimientos = rendimientos,
      alpha = 0.05,
      min_block = 5
    )
    
    # Guardamos también el nombre de la columna usada
    columna_usada <- names(datos)[grep("rendimiento", names(datos), ignore.case = TRUE)[1]]
    
    res$Archivo <- archivo
    res$Columna_usada <- columna_usada
    res$N_observaciones <- length(rendimientos)
    
    res
    
  }, error = function(e) {
    
    data.frame(
      Hurst = NA,
      Estadistico = NA,
      p_valor = NA,
      alpha = 0.05,
      Decision = paste("ERROR:", e$message),
      Archivo = archivo,
      Columna_usada = NA,
      N_observaciones = NA
    )
  })
  
  resultados_hurst <- rbind(resultados_hurst, resultado)
}

# Reordenar columnas
resultados_hurst <- resultados_hurst[, c(
  "Archivo",
  "Columna_usada",
  "N_observaciones",
  "Hurst",
  "Estadistico",
  "p_valor"
)]

print(resultados_hurst)
