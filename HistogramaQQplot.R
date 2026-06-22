#DESCRIPCIÓN: Gráfico compración rendimientos con la distribución gaussiana

library(readxl)

# Cargar datos
datos <- read_excel("C:/Users/guill/TFG/BASESDEDATOS/Arreglados/USAModSBEliminadas.xlsx")

# Columna de rendimientos
x <- as.numeric(datos[[2]])

# Mostrar 2 gráficos juntos
par(mfrow = c(1,2))

#=
# HISTOGRAMA

hist(x,
     probability = TRUE,
     breaks = 40,
     col = "lightblue",
     border = "white",
     main = "Histograma",
     xlab = "Rendimientos")

# Curva normal teórica
curve(dnorm(x,
            mean = mean(x, na.rm = TRUE),
            sd = sd(x, na.rm = TRUE)),
      col = "red",
      lwd = 2,
      add = TRUE)

# QQ-PLOT


qqnorm(x,
       main = "QQ-Plot")

qqline(x,
       col = "red",
       lwd = 2)