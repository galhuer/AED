## ----setup, include=FALSE---------------------------------------------------------------
library(knitr)
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, error = FALSE)
options(width = 90)
dir.create('resultados', showWarnings = FALSE)


## ----catalogos--------------------------------------------------------------------------
data(package = 'signal')$results[, 'Item']
data(package = 'ggmap')$results[, 'Item']


## ----crabs------------------------------------------------------------------------------
data('crabs', package = 'MASS')
dim(crabs)
tipos <- data.frame(Variable = names(crabs),
  Clase = vapply(crabs, function(x) class(x)[1], character(1)),
  Tipo = c('Nominal', 'Nominal', 'Identificador', rep('Continua', 5)))
kable(tipos, row.names = FALSE, caption = 'Tipos de las variables de crabs.')


## ----figura-crabs, fig.cap='Longitud y anchura del caparazón.', fig.width=6, fig.height=4----
plot(crabs$CL, crabs$CW, xlab = 'Longitud (mm)', ylab = 'Anchura (mm)')


## ----factores---------------------------------------------------------------------------
catalogo <- unique(data(package = 'MASS')$results[, 'Item'])
recuento <- list()
for (nombre in catalogo) {
  entorno <- new.env()
  data(list = nombre, package = 'MASS', envir = entorno)
  for (objeto in ls(entorno)) {
    datos <- get(objeto, envir = entorno)
    recuento[[objeto]] <- data.frame(Conjunto = objeto,
      Factores = if (is.data.frame(datos)) sum(vapply(datos, is.factor, logical(1))) else 0)
  }
}
recuento <- do.call(rbind, recuento)
seleccion <- recuento[recuento$Factores >= 5, ]
kable(seleccion, row.names = FALSE)
nrow(seleccion)
write.csv(recuento, 'resultados/Recuento_MASS.csv', row.names = FALSE)
write.csv(tipos, 'resultados/Tipos_crabs.csv', row.names = FALSE)

