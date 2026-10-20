if (dir.exists('.library')) .libPaths(c(normalizePath('.library'), .libPaths()))
rmarkdown::render('ConjuntosDatos.Rmd', encoding = 'UTF-8', quiet = TRUE)
knitr::purl('ConjuntosDatos.Rmd', output = 'ConjuntosDatos.R', quiet = TRUE)
