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

### `ComprobacionValoresFaltantesAntes.R`

Este código calcula el número total y el porcentaje de valores faltantes presentes en las bases de datos antes de aplicar el proceso de imputación.

El análisis permite identificar la magnitud inicial del problema de datos ausentes y comparar el grado de incompletitud entre las distintas bases utilizadas en el trabajo.

### `ComprobacionValoresFaltantesPost.R`

Este script calcula el número y porcentaje de valores faltantes después de aplicar la imputación mediante MissForest.

Su finalidad es verificar que el proceso de imputación ha sido correctamente aplicado y comprobar que las bases resultantes están completas para poder ser utilizadas posteriormente en los modelos predictivos y en la optimización de carteras.

### `GraficosRendimientosPrePostMissForest.R`

Este script genera gráficos comparativos de las series de rendimientos antes y después del proceso de imputación mediante MissForest.

Su objetivo es comprobar visualmente que la imputación no altera de forma significativa la estructura general de las series financieras. Para ello, permite observar la evolución temporal de los rendimientos originales y de los rendimientos imputados, facilitando la validación gráfica del tratamiento de valores faltantes.

### `MissForest.ipynb`

Notebook destinado a la imputación de valores faltantes mediante el algoritmo MissForest.

En este archivo se cargan las bases de datos originales, se aplica el procedimiento de imputación y se generan las bases completas que serán utilizadas en las fases posteriores del análisis empírico.

Este paso resulta fundamental para garantizar que los modelos de Random Forest y los procedimientos de optimización trabajen con matrices de datos sin valores ausentes.

### `RandomForest.ipynb`

Notebook correspondiente a la implementación del modelo Random Forest en la parte empírica del trabajo.

En él se construyen los modelos predictivos a partir de las bases imputadas, se separan las variables explicativas de la variable objetivo y se generan predicciones de rendimientos o señales para los distintos pares de activos analizados.



### `PrimeraparteOptimizacionSemiparametrica (2).ipynb`

Notebook correspondiente a la primera fase de la optimización semiparamétrica.

En este archivo se ejecuta el codigo de Random Forest con Rolling Window para sacar las tres señales para la segunda parte de optimización semiparamétrica.

### `Última_parte_OS.ipynb`

Notebook correspondiente a la fase final de optimización semiparamétrica.

Une las señales generadas previamente, las estandariza y construye las matrices necesarias para la optimización. Posteriormente, define la regla de pesos de cartera, la función de utilidad CRRA y los procedimientos de optimización, incluyendo el caso con muestra de entrenamiento y el enfoque rolling window.

Finalmente, calcula métricas de rendimiento y genera recomendaciones de pesos para el mes siguiente.

### `README.md`

Archivo descriptivo del repositorio.

Resume el contenido de cada script y notebook utilizado en el Trabajo de Fin de Grado, explicando brevemente la finalidad de cada código dentro del análisis empírico.

Su objetivo es facilitar la comprensión y reproducibilidad del trabajo.
