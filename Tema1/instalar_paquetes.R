dir.create('.library', showWarnings = FALSE)
.libPaths(c(normalizePath('.library'), .libPaths()))
paquetes <- c('MASS', 'signal', 'ggmap', 'rmarkdown', 'knitr')
faltan <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltan)) install.packages(faltan, lib = '.library', repos = 'https://cloud.r-project.org')
