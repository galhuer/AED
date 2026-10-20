if (dir.exists('.library')) .libPaths(c(normalizePath('.library'), .libPaths()))
for (nombre in c('Ejemplo2', 'Tema2')) {
  rmarkdown::render(paste0(nombre, '.Rmd'), encoding = 'UTF-8', quiet = TRUE,
                    envir = new.env())
  knitr::purl(paste0(nombre, '.Rmd'), output = paste0(nombre, '.R'), quiet = TRUE)
}
