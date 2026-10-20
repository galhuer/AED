## ----setup, include=FALSE---------------------------------------------------------------
library(knitr)
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, error = FALSE)
options(width = 90)


## ----descargar--------------------------------------------------------------------------
source('DescargarDatos.R', local = TRUE, encoding = 'UTF-8')
kable(descargas[, c('Fuente', 'Formato', 'Archivo')], row.names = FALSE)


## ----poblacion--------------------------------------------------------------------------
leer_ine <- function(archivo, separador) {
  datos <- read.table(archivo, header = TRUE, sep = separador, quote = '"',
    comment.char = '', fileEncoding = 'UTF-8-BOM', colClasses = 'character',
    check.names = FALSE, na.strings = c('', '..'))
  datos$Periodo <- as.integer(datos$Periodo)
  datos$Total <- as.integer(gsub('.', '', datos$Total, fixed = TRUE))
  datos
}
poblacion <- leer_ine('data/INE/Valencia_poblacion_punto_coma.csv', ';')
poblacion_tab <- leer_ine('data/INE/Valencia_poblacion_tab.csv', '\t')
identical(poblacion, poblacion_tab)
dim(poblacion)
ultimo <- max(poblacion$Periodo)
municipios <- subset(poblacion, grepl('^[0-9]{5} ', Municipios) &
                       Sexo == 'Total' & Periodo == ultimo)
nrow(municipios)
sum(municipios$Total)
dir.create('resultados', showWarnings = FALSE)
write.csv(municipios, 'resultados/Poblacion_municipios.csv', row.names = FALSE)


## ----codificacion-----------------------------------------------------------------------
conexion <- file('data/INE/Valencia_poblacion.px', encoding = 'ISO-8859-15')
cabecera <- readLines(conexion, n = 20, warn = FALSE)
close(conexion)
cabecera[grepl('^(CHARSET|CODEPAGE|TITLE)=', cabecera)]


## ----gapminder--------------------------------------------------------------------------
fertilidad <- read.csv('data/Gapminder/Babies_per_woman.csv', check.names = FALSE)
mortalidad <- read.csv('data/Gapminder/Child_mortality.csv', check.names = FALSE)
head(fertilidad, 3)
head(mortalidad, 3)

