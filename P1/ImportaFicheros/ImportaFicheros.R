params <-
list(lang = "ES")

## ----setup, include=FALSE------------------------------------------------
library(knitr)
options(width = 75)
opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE,
               error = FALSE, comment = NA, fig.align = 'center',
               dpi = 200, tidy = FALSE)
library(readr)
library(hms)
library(haven)
library(jsonlite)
dir.create('results', showWarnings = FALSE)


## ----deposito------------------------------------------------------------
fname <- 'data/DFP1_11122015 124700.csv'
Deposito <- read.csv(fname, sep = '\t', stringsAsFactors = FALSE)
Deposito_readr <- read_delim(fname, delim = '\t', col_types = 'ccddd')
all.equal(Deposito, as.data.frame(Deposito_readr),
          check.attributes = FALSE)
Deposito$FECHA <- as.POSIXlt(Deposito$FECHA,
                           format = '%d/%m/%Y', tz = 'UTC')
Deposito$HORA <- as_hms(Deposito$HORA)
save(Deposito, file = 'results/Deposito.RData')
dim(Deposito)


## ----deposito-inspeccion, results='hide'---------------------------------
str(Deposito)
head(Deposito)
tail(Deposito)
Deposito_resumen <- Deposito
Deposito_resumen$HORA <- as.numeric(Deposito_resumen$HORA)
summary(Deposito_resumen)




## ----bakery--------------------------------------------------------------
BreadBasket <- as.data.frame(read_csv('data/bakery_sales_revised.csv',
  col_types = cols(Transaction = col_integer(), Item = col_character(),
    date_time = col_datetime('%m/%d/%Y %H:%M'),
    period_day = col_character(), weekday_weekend = col_character())))
save(BreadBasket, file = 'results/BreadBasket.RData')
dim(BreadBasket)


## ----bakery-inspeccion, results='hide'-----------------------------------
str(BreadBasket)
head(BreadBasket)
tail(BreadBasket)
summary(BreadBasket)




## ----psychbike-----------------------------------------------------------
PsychBike <- as.data.frame(read_sav('data/PsychBike.sav'))
save(PsychBike, file = 'results/PsychBike.RData')
dim(PsychBike)


## ----psychbike-inspeccion, results='hide'--------------------------------
str(PsychBike)
head(PsychBike)
tail(PsychBike)
PsychBike_resumen <- PsychBike
PsychBike_resumen$hour <- as.numeric(PsychBike_resumen$hour)
summary(PsychBike_resumen)


## ----iris-zip------------------------------------------------------------
unzip('data/iris.zip', exdir = 'data')


## ----iris-data-----------------------------------------------------------
lineas <- readLines('data/iris.data', warn = FALSE)
texto <- paste(gsub(',', ' ', lineas, fixed = TRUE), collapse = '\n')
iris <- as.data.frame(read_table(I(texto), col_types = 'ddddc',
  col_names = c('Sepal.Length', 'Sepal.Width', 'Petal.Length',
                'Petal.Width', 'Species')))
save(iris, file = 'results/iris.RData')
dim(iris)


## ----iris-inspeccion, results='hide'-------------------------------------
str(iris)
head(iris)
tail(iris)
summary(iris)


## ----codificado----------------------------------------------------------
lista <- read_json('data/FileCodificado.json')
FileCodificado <- read_json('data/FileCodificado.json',
                            simplifyVector = TRUE)
class(lista)
class(FileCodificado)
save(FileCodificado, file = 'results/FileCodificado.RData')
dim(FileCodificado)


## ----codificado-inspeccion, results='hide'-------------------------------
str(FileCodificado)
head(FileCodificado)
tail(FileCodificado)
summary(FileCodificado)


## ----iris-json-----------------------------------------------------------
lista_iris <- read_json('data/iris_json.json')
iris_json <- read_json('data/iris_json.json', simplifyVector = TRUE)
iris_fromJSON <- fromJSON('data/iris_json.json')
identical(iris_json, iris_fromJSON)
save(iris_json, file = 'results/iris_json.RData')
dim(iris_json)


## ----iris-json-inspeccion, results='hide'--------------------------------
str(iris_json)
head(iris_json)
tail(iris_json)
summary(iris_json)


## ----exportar-json-------------------------------------------------------
load('results/iris.RData')
write_json(iris, 'data/iris_json_v2.json', pretty = TRUE, digits = NA)
compacto <- toJSON(iris, pretty = FALSE, digits = NA)
legible <- toJSON(iris, pretty = TRUE, digits = NA)
write_file(compacto, 'data/iris_compacto.json')
write_file(legible, 'data/iris_pretty.json')

