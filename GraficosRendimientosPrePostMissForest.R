library(readxl)
library(ggplot2)
library(dplyr)

# Rutas
ruta_original <- "C:/Users/guill/TFG/BASESDEDATOS/Arreglados/"
ruta_imputada <- "C:/Users/guill/TFG/BASESDEDATOS/MissForest"

# Bases elegidas
bases <- data.frame(
  etiqueta = c(
    "USA Acciones vs Bonos",
    "UK Acciones vs Cash",
    "Japón Bonos vs Cash"
  ),
  archivo_original = c("USAModSBEliminadas.xlsx", "UKModSC.xlsx", "JAPANModBC.xlsx"),
  archivo_imputado = c("USAModSB1.xlsx", "UKModSC1.xlsx", "JAPANModBC1.xlsx")
)

leer_rendimiento <- function(ruta, archivo) {
  datos <- read_excel(file.path(ruta, archivo))
  
  col_rend <- grep("Rendimiento", names(datos), ignore.case = TRUE, value = TRUE)
  
  if (length(col_rend) == 0) {
    stop(paste("No se encontró columna con 'Rendimiento' en:", archivo))
  }
  
  rend <- as.numeric(datos[[col_rend[1]]])
  rend <- rend[!is.na(rend)]
  
  return(rend)
}

datos_graficos <- data.frame()

for (i in 1:nrow(bases)) {
  
  original <- leer_rendimiento(ruta_original, bases$archivo_original[i])
  imputada <- leer_rendimiento(ruta_imputada, bases$archivo_imputado[i])
  
  temp <- data.frame(
    Serie = bases$etiqueta[i],
    Rendimiento = c(original, imputada),
    Base = c(
      rep("Original", length(original)),
      rep("Tras imputación", length(imputada))
    )
  )
  
  datos_graficos <- rbind(datos_graficos, temp)
}

grafico <- ggplot(datos_graficos, aes(x = Rendimiento, fill = Base)) +
  geom_density(alpha = 0.35) +
  facet_wrap(~ Serie, scales = "free", nrow = 1) +
  labs(
    title = "Comparación de distribuciones de rendimientos antes y después de la imputación",
    x = "Rendimiento",
    y = "Densidad",
    fill = ""
  ) +
  theme_minimal(base_size = 13) +
  theme(
    strip.text = element_text(size = 12, face = "bold"),
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom"
  )

print(grafico)

ggsave(
  filename = "comparacion_distribuciones_missforest.png",
  plot = grafico,
  width = 12,
  height = 5,
  dpi = 300
)