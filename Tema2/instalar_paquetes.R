dir.create('.library', showWarnings = FALSE)
.libPaths(c(normalizePath('.library'), .libPaths()))
paquetes <- c('rmarkdown', 'knitr', 'readr', 'dplyr', 'ggplot2',
              'DBI', 'RSQLite', 'rvest', 'BiocManager')
faltan <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltan)) install.packages(faltan, lib = '.library', repos = 'https://cloud.r-project.org')
if (!requireNamespace('rhdf5', quietly = TRUE))
  BiocManager::install('rhdf5', lib = '.library', ask = FALSE, update = FALSE)
