# Codigos-TFG-Aitana-Guill
Este repositorio contiene los códigos utilizados en el Trabajo de Fin de Grado de Aitana Guill Beltrán.
## Contenido del repositorio
### `CodigoEstadísticosDescriptivos.R`
Este script calcula los principales estadísticos descriptivos de las series de rendimientos incluidas en las bases de datos. En concreto, obtiene la media, la desviación típica, la asimetría y la curtosis de cada serie.

Este análisis permite realizar una primera caracterización de los rendimientos financieros y comprobar si presentan rasgos habituales en este tipo de series, como asimetrías o curtosis elevada.

### `CodigoTestJarqueBera.R`

Este código aplica el contraste de normalidad de Jarque-Bera a las series de rendimientos. El test permite evaluar si los rendimientos se ajustan a una distribución normal a partir de su asimetría y curtosis.
Los resultados obtenidos permiten contrastar empíricamente la hipótesis de normalidad, mostrando si existen desviaciones significativas respecto al supuesto gaussiano clásico.


### `HistogramaQQplot.R`

Este script genera representaciones gráficas de las series de rendimientos mediante histogramas y QQ-plots.
El histograma permite observar la forma empírica de la distribución de los rendimientos, mientras que el QQ-plot permite comparar visualmente la distribución observada con una distribución normal teórica.

### `CodigoCorrelaciónRyR^2.R`

Este código calcula autocorrelaciones de los rendimientos y de los rendimientos al cuadrado.
La autocorrelación de los rendimientos permite estudiar la posible existencia de dependencia lineal temporal, mientras que la autocorrelación de los rendimientos al cuadrado permite analizar la persistencia de la volatilidad y la presencia de agrupamiento de volatilidad.

### `CodigoContrasteHurst.R`

Este script calcula el exponente de Hurst para las series financieras analizadas.
El exponente de Hurst se utiliza para estudiar la posible existencia de memoria de largo plazo en las series temporales. Valores distintos de 0,5 pueden indicar persistencia o reversión a la media.

### `CodigoContrasteBDS.R`

Este código aplica el contraste BDS a las series de rendimientos.
El contraste BDS permite analizar si una serie es independiente e idénticamente distribuida. Su aplicación resulta útil para detectar posibles estructuras no lineales o patrones de dependencia no capturados por modelos lineales tradicionales.
