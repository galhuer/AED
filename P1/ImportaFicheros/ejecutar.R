if (dir.exists('.library')) .libPaths(c(normalizePath('.library'), .libPaths()))
if (.Platform$OS.type == 'windows' && Sys.which('pdflatex') == '') {
  tex_bin <- file.path(Sys.getenv('USERPROFILE'), '.TinyTeX', 'bin', 'windows')
  if (dir.exists(tex_bin))
    Sys.setenv(PATH = paste(tex_bin, Sys.getenv('PATH'), sep = .Platform$path.sep))
}
rmarkdown::render('ImportaFicheros.Rmd', output_format = 'pdf_document',
                  encoding = 'UTF-8', quiet = TRUE, envir = new.env())
knitr::purl('ImportaFicheros.Rmd', output = 'ImportaFicheros.R', quiet = TRUE)
