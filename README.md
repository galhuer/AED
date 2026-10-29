# Análisis Exploratorio de Datos

- `Tema0`: configuración de Git y ejercicio de control de versiones.
- `Tema1`: plantilla y conjuntos de datos en R.
- `Tema2`: ejercicios y ejemplos de obtención de datos.
- `Tema3`: ejercicios de visualización de datos y taller de gráficos.
- `Tema4`: ejercicios de texto y expresiones regulares.
- `Tema5`: ejercicios de manejo y transformación de datos.
- `P1/ImportaFicheros`: importación, apartados 1 a 8.
- `P2`: visualización de datos, ejercicios 1 a 8.
- `P3yP4/P3P4_ALUMNOS`: preparación y manejo de datos, ejercicios 1 a 8.

P1, Tema1 y Tema2 contienen `ejecutar.R` e `instalar_paquetes.R`.
Los datos de P1, Tema1 y Tema2 están en los proyectos locales y sus ZIP de entrega.
El repositorio incluye la memoria PDF de P1 y la entrega completa de P2:
Rmd, PDF, datos, figuras y `P2.zip`.

Para generar P2 se necesitan R, Pandoc (incluido en RStudio), LaTeX,
y los paquetes `rmarkdown` y `pacman`. El Rmd carga el resto de los paquetes.
Desde la raíz del repositorio:

```r
rmarkdown::render('P2/ProyectoR.Rmd', output_format = 'pdf_document')
```

Para ejecutar los ejercicios de los temas 3, 4 y 5 se necesitan los paquetes
`rmarkdown`, `knitr`, `ggplot2`, `dplyr`, `tidyr`, `stringr`, `MASS`,
`ggrepel`, `maps`, `lutz`, `sf` y `gapminder`.
