## ----setup, include=FALSE---------------------------------------------------------------
library(knitr)
library(readr)
library(dplyr)
library(ggplot2)
library(DBI)
library(RSQLite)
library(rvest)
library(rhdf5)
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE, error = FALSE,
              fig.align = 'center', fig.width = 6, fig.height = 4)
options(width = 90, timeout = 180)
dir.create('results', showWarnings = FALSE)
dir.create('figure', showWarnings = FALSE)


## ----auto-descarga----------------------------------------------------------------------
base_uci <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/'
for (nombre in c('auto-mpg.data', 'auto-mpg.names')) {
  destino <- file.path('data', nombre)
  if (!file.exists(destino)) download.file(paste0(base_uci, nombre), destino, mode = 'wb')
}
auto <- read.table('data/auto-mpg.data', quote = '"', na.strings = '?',
  col.names = c('mpg', 'cylinders', 'displacement', 'horsepower', 'weight',
                'acceleration', 'modelYear', 'origin', 'carName'))
dim(auto)
colSums(is.na(auto))
save(auto, file = 'results/AutoMPG.RData')


## ----descarga-ine-----------------------------------------------------------------------
source('DescargarDatos.R', local = TRUE, encoding = 'UTF-8')
kable(descargas[, c('Fuente', 'Formato', 'Archivo')], row.names = FALSE)
conexion_px <- file('data/INE/Valencia_poblacion.px', encoding = 'ISO-8859-15')
px <- readLines(conexion_px, n = 20, warn = FALSE)
close(conexion_px)
px[grepl('^(CHARSET|CODEPAGE)=', px)]


## ----pagina-web-------------------------------------------------------------------------
url <- 'https://www.ine.es/jaxiT3/Tabla.htm?t=2852&L=0'
if (!file.exists('data/Provincias.html'))
  download.file(url, 'data/Provincias.html', mode = 'wb')
pagina <- read_html('data/Provincias.html')
html_text2(html_element(pagina, 'title'))
censo <- read_html('data/CensoProvincias.html')
enlaces <- html_elements(censo, 'a.titulo')
provincias <- data.frame(Titulo = trimws(html_text2(enlaces)),
                        Enlace = html_attr(enlaces, 'href'))
head(provincias, 3)
write.csv(provincias, 'results/Enlaces_INE.csv', row.names = FALSE)


## ----baltimore--------------------------------------------------------------------------
fichero <- 'data/Baltimore_City_Employee_Salaries_FY2015.csv'
baltimore_base <- read.csv(fichero, stringsAsFactors = FALSE, check.names = FALSE)
baltimore_readr <- read_csv(fichero, col_types = cols(.default = col_character()))
dim(baltimore_base)
head(baltimore_base, 3)
names(baltimore_readr)


## ----cuentas----------------------------------------------------------------------------
fichero <- 'data/Unclaimed_bank_accounts.csv'
Uba <- read.csv(fichero, stringsAsFactors = FALSE)
Uba2 <- read_csv(fichero, col_types = cols(.default = col_character()))
names(Uba)
names(Uba2)
Uba3 <- read_csv(fichero, quote = '"', col_types = cols(.default = col_character()))
kable(head(Uba3, 3), row.names = FALSE)


## ----comilla-incorrecta-----------------------------------------------------------------
Uba4 <- suppressWarnings(read_csv(fichero, quote = "'",
  col_types = cols(.default = col_character())))
nrow(problems(Uba4))
head(problems(Uba4), 3)


## ----lineas-----------------------------------------------------------------------------
Uba_lines <- readLines('data/Unclaimed_bank_accounts.csv', warn = FALSE)
length(Uba_lines)
head(Uba_lines, 3)


## ----gapminder--------------------------------------------------------------------------
fertilidad <- read.csv('data/Gapminder/Babies_per_woman.csv', check.names = FALSE)
mortalidad <- read.csv('data/Gapminder/Child_mortality.csv', check.names = FALSE)
names(fertilidad)[4] <- 'fertilidad'
names(mortalidad)[4] <- 'mortalidad'
gap <- merge(fertilidad, mortalidad[, c('geo', 'time', 'mortalidad')],
             by = c('geo', 'time'))
for (ano in c(1900, 1950, 2000)) {
  datos <- gap[gap$time == ano, ]
  plot(datos$fertilidad, datos$mortalidad, main = ano,
       xlab = 'Hijos por mujer', ylab = 'Mortalidad infantil por 1000')
}
save(gap, file = 'results/Gapminder.RData')


## ----auto-texto-------------------------------------------------------------------------
lineas <- readLines('data/UCIautoMpg.txt')
partes <- strsplit(lineas, '\t')
medidas <- vapply(partes, function(x) trimws(x[1]), character(1))
coches <- vapply(partes, function(x) gsub('"', '', x[2], fixed = TRUE), character(1))
matriz <- do.call(rbind, strsplit(medidas, '[[:space:]]+'))
matriz[matriz == '?'] <- NA
autoMpgFrame <- as.data.frame(matrix(as.numeric(matriz), ncol = 8))
autoMpgFrame$carName <- coches
metadatos <- readLines('data/auto-mpg.names')
campos <- grep('^    [1-9]\\. ', metadatos, value = TRUE)
nombres <- sub('^    [1-9]\\. ([^:]+):.*', '\\1', campos)
names(autoMpgFrame) <- make.names(nombres)
head(autoMpgFrame, 3)
all.equal(unname(as.matrix(autoMpgFrame[, 1:8])), unname(as.matrix(auto[, 1:8])))
identical(autoMpgFrame[[9]], auto$carName)


## ----guardar-graficos-------------------------------------------------------------------
p1 <- ggplot(mtcars, aes(factor(cyl), mpg)) + geom_boxplot() +
  labs(x = 'Cilindros', y = 'Millas por galón')
p2 <- ggplot(mtcars, aes(hp, mpg, colour = factor(gear))) + geom_point()
p3 <- ggplot(mtcars, aes(hp, mpg, colour = factor(gear), size = carb)) + geom_point()
pdf('figure/mtcars.pdf', width = 6, height = 4)
print(p1)
print(p2)
print(p3)
dev.off()
png('figure/Rplot%03d.png', width = 900, height = 600)
plot(mtcars$mpg ~ mtcars$cyl, xlab = 'Cilindros', ylab = 'mpg')
plot(mtcars$mpg ~ mtcars$disp, xlab = 'Cilindrada', ylab = 'mpg')
plot(mtcars$mpg ~ mtcars$hp, xlab = 'Potencia', ylab = 'mpg')
dev.off()
p1
p2
p3


## ----uniones----------------------------------------------------------------------------
band_members
band_instruments
inner_join(band_members, band_instruments, by = 'name')
left_join(band_members, band_instruments, by = 'name')
right_join(band_members, band_instruments, by = 'name')
full_join(band_members, band_instruments, by = 'name')
semi_join(band_members, band_instruments, by = 'name')
anti_join(band_members, band_instruments, by = 'name')
left_join(band_members, band_instruments2, by = c('name' = 'artist'))


## ----sqlite-----------------------------------------------------------------------------
conexion <- dbConnect(SQLite(), 'results/MusicosInstrumentos.sqlite')
dbWriteTable(conexion, 'MusicoGrupo', band_members, overwrite = TRUE)
dbWriteTable(conexion, 'MusicoInstrumento', band_instruments, overwrite = TRUE)
dbListTables(conexion)
dbListFields(conexion, 'MusicoGrupo')
dbGetQuery(conexion, 'SELECT COUNT(*) AS Total FROM MusicoGrupo')
dbGetQuery(conexion, "SELECT * FROM MusicoGrupo WHERE band = 'Beatles'")
dbGetQuery(conexion, 'SELECT name, plays FROM MusicoInstrumento')
dbWriteTable(conexion, 'AutoMPG', auto, overwrite = TRUE)
dbGetQuery(conexion, 'SELECT cylinders, modelYear, carName FROM AutoMPG
                     WHERE cylinders = 3 OR cylinders = 5')
dbDisconnect(conexion)


## ----robot-ur---------------------------------------------------------------------------
catalogo <- h5ls('data/Robot.hdf5')
kable(catalogo[catalogo$group == '/URInput', c('name', 'dclass', 'dim')], row.names = FALSE)
UR <- h5read('data/Robot.hdf5', 'URInput')
fechahora <- data.frame(
  fecha = as.POSIXct(UR$timestamp_date, format = '%Y-%m-%d %H:%M:%OS', tz = 'Europe/Madrid'),
  posix = as.POSIXct(as.numeric(UR$timestamp_posix), origin = '1970-01-01', tz = 'Europe/Madrid'))
head(fechahora)
summary(as.numeric(difftime(fechahora$fecha, fechahora$posix, units = 'secs')))
intervalo <- diff(as.numeric(UR$timestamp_posix))
intervalo_redondeado <- round(intervalo, 3)
summary(intervalo)
length(unique(intervalo_redondeado))
head(sort(table(intervalo_redondeado), decreasing = TRUE))
summary(1 / intervalo)
save(fechahora, intervalo, intervalo_redondeado, file = 'results/TiemposUR.RData')
H5close()

