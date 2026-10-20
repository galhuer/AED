# Ejemplo 2. Descarga de datos del INE y de Gapminder.
# Carlos Galdámez Huertas (galhuer).
# Ejecutar desde la carpeta del proyecto de RStudio.

options(timeout = 180)

# Tabla 2903 del INE: Valencia/València, población por municipios y sexo.
base_ine <- "https://www.ine.es/jaxiT3/files/t/es/"

# Hojas publicadas en las páginas oficiales de documentación de Gapminder.
base_gapminder <- "https://docs.google.com/spreadsheets/d/"
id_fertilidad <- "1j6zkY_a1vX7RtIGKsC9V6AXyfUgtYZl52_SCezwESZM"
id_mortalidad <- "1Av7eps_zEK73-AdbFYEmtTrwFKlfruBYXdrnXAOFVpM"
consulta_csv <- "/gviz/tq?tqx=out:csv&sheet=data-for-countries-etc-by-year"

descargas <- data.frame(
  Fuente = c(rep("INE", 5), rep("Gapminder", 2)),
  Formato = c("Excel XLSX", "CSV tabuladores", "CSV punto y coma", "PC-Axis",
              "JSON", "CSV UTF-8", "CSV UTF-8"),
  Archivo = c(
    "data/INE/Valencia_poblacion.xlsx",
    "data/INE/Valencia_poblacion_tab.csv",
    "data/INE/Valencia_poblacion_punto_coma.csv",
    "data/INE/Valencia_poblacion.px",
    "data/INE/Valencia_poblacion.json",
    "data/Gapminder/Babies_per_woman.csv",
    "data/Gapminder/Child_mortality.csv"
  ),
  URL = c(
    paste0(base_ine, "xlsx/2903.xlsx?nocab=1"),
    paste0(base_ine, "csv_bd/2903.csv?nocab=1"),
    paste0(base_ine, "csv_bdsc/2903.csv?nocab=1"),
    paste0(base_ine, "px/2903.px?nocab=1"),
    "https://servicios.ine.es/wstempus/jsCache/es/DATOS_TABLA/2903?tip=AM&",
    paste0(base_gapminder, id_fertilidad, consulta_csv),
    paste0(base_gapminder, id_mortalidad, consulta_csv)
  ),
  stringsAsFactors = FALSE
)

dir.create("data/INE", recursive = TRUE, showWarnings = FALSE)
dir.create("data/Gapminder", recursive = TRUE, showWarnings = FALSE)
dir.create("metadatos", showWarnings = FALSE)

registro <- "metadatos/Descargas.csv"
if (file.exists(registro)) {
  registros <- read.csv(registro, check.names = FALSE, fileEncoding = "UTF-8")
} else {
  registros <- data.frame()
}

for (i in seq_len(nrow(descargas))) {
  destino <- descargas$Archivo[i]

  # Conservar los archivos descargados y su fecha original al repetir el script.
  if (file.exists(destino) && file.info(destino)$size > 0 &&
      nrow(registros) > 0 && destino %in% registros$Archivo) {
    message("Ya descargado: ", destino)
    next
  }

  message("Descargando: ", destino)

  # El modo binario conserva los bytes tanto de Excel como de los archivos de texto.
  temporal <- paste0(destino, ".part")
  download.file(descargas$URL[i], destfile = temporal, mode = "wb",
                method = "libcurl", quiet = TRUE)
  if (!file.exists(temporal) || file.info(temporal)$size == 0) {
    stop("No se ha descargado correctamente: ", destino)
  }
  if (!file.rename(temporal, destino)) {
    stop("No se ha podido guardar: ", destino)
  }

  fila <- descargas[i, ]
  fila$Fecha_UTC <- format(Sys.time(), tz = "UTC", format = "%Y-%m-%d %H:%M:%S UTC")
  fila$Bytes <- file.info(destino)$size
  fila$MD5 <- unname(tools::md5sum(destino))

  if (nrow(registros) > 0) {
    registros <- registros[registros$Archivo != destino, ]
  }
  registros <- rbind(registros, fila)
  write.csv(registros, registro, row.names = FALSE, fileEncoding = "UTF-8")
}

message("Descargas terminadas. Los datos están en la carpeta data/.")
