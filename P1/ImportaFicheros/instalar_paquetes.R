dir.create('.library', showWarnings = FALSE)
.libPaths(c(normalizePath('.library'), .libPaths()))
paquetes <- c('readr', 'hms', 'haven', 'jsonlite', 'rmarkdown', 'knitr', 'tinytex')
faltan <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltan))
  install.packages(faltan, lib = '.library', repos = 'https://cloud.r-project.org')
if (.Platform$OS.type == 'windows' && Sys.which('pdflatex') == '') {
  tex_bin <- file.path(Sys.getenv('USERPROFILE'), '.TinyTeX', 'bin', 'windows')
  if (dir.exists(tex_bin))
    Sys.setenv(PATH = paste(tex_bin, Sys.getenv('PATH'), sep = .Platform$path.sep))
}
if (Sys.which('pdflatex') == '') {
  if (.Platform$OS.type == 'windows')
    tinytex::install_tinytex(dir = file.path(Sys.getenv('USERPROFILE'), '.TinyTeX'),
                           add_path = FALSE)
  else tinytex::install_tinytex()
}
