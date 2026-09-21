#' Lista de Fauna Silvestre Legalmente Protegida (DS 004-2014-MINAGRI)
#'
#' Dataset con las 535 especies de fauna silvestre de Perú categorizadas como
#' amenazadas por el Decreto Supremo N° 004-2014-MINAGRI.
#'
#' @format Un tibble con 535 filas y 11 variables:
#' \describe{
#'   \item{ds004_id}{Identificador correlativo del DS 004 (1 a 535).}
#'   \item{ds004_categoria_codigo}{Código de categoría ordenado (CR, EN, VU, NT, DD).}
#'   \item{ds004_categoria}{Descripción completa de la categoría de amenaza.}
#'   \item{clase}{Clase taxonómica (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).}
#'   \item{genus}{Género taxonómico.}
#'   \item{species}{Epíteto específico.}
#'   \item{subspecies}{Subespecie (si aplica).}
#'   \item{scientific_name}{Nombre científico completo.}
#'   \item{common_name}{Nombre(s) común(es) registrado(s).}
#'   \item{synonym_scientific_name}{Sinónimo(s) registrado(s) en la norma.}
#'   \item{observacion}{Notas sobre subespecies u observaciones taxonómicas.}
#' }
#' @source Ministerio de Agricultura y Riego (MINAGRI, 2014).
"ds004_fauna"

#' Especies de Fauna Silvestre del Libro Rojo (SERFOR, 2018)
#'
#' Lista de 528 especies de fauna silvestre amenazada analizadas en el
#' Libro Rojo de la Fauna Silvestre Amenazada del Perú.
#'
#' @format Un tibble con 528 filas y 7 variables:
#' \describe{
#'   \item{libro_rojo_id}{Número correlativo.}
#'   \item{libro_rojo_categoria}{Nombre de la categoría de amenaza.}
#'   \item{libro_rojo_codigo}{Código de categoría ordenado (CR, EN, VU, NT, DD).}
#'   \item{grupo_taxonomico}{Grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).}
#'   \item{scientific_name_raw}{Nombre científico tal como figura en la publicación.}
#'   \item{sinonimo}{Sinónimo o nombre adicional.}
#'   \item{scientific_name}{Nombre científico normalizado.}
#' }
#' @source Servicio Nacional Forestal y de Fauna Silvestre (SERFOR, 2018).
"libro_rojo_especies"

#' Fichas Técnicas del Libro Rojo de Fauna Silvestre (SERFOR, 2018)
#'
#' Compendio de 381 fichas técnicas monográficas elaboradas por especialistas
#' para especies prioritarias de fauna silvestre amenazada del Perú.
#'
#' @format Un tibble con 381 filas y 16 variables:
#' \describe{
#'   \item{genus}{Género taxonómico.}
#'   \item{species}{Epíteto específico.}
#'   \item{subespecie}{Subespecie (si aplica).}
#'   \item{species_autor}{Autoría y año taxonómico.}
#'   \item{class_name}{Clase taxonómica.}
#'   \item{order_name}{Orden taxonómico.}
#'   \item{family_name}{Familia taxonómica.}
#'   \item{species_name}{Nombre científico con autoría.}
#'   \item{ficha_categoria}{Categoría y criterios UICN asignados.}
#'   \item{ficha_grupo}{Grupo taxonómico.}
#'   \item{common_name}{Nombre común registrado.}
#'   \item{justificacion}{Justificación de la categorización.}
#'   \item{distribucion}{Distribución geográfica y altitudinal.}
#'   \item{amenazas}{Principales factores de amenaza.}
#'   \item{conservacion}{Estado de conservación y presencia en áreas protegidas.}
#'   \item{autores}{Especialistas autores de la ficha.}
#'   \item{canonical_name}{Nombre binomial o trinomial normalizado.}
#' }
#' @source SERFOR (2018). Libro Rojo de la Fauna Silvestre Amenazada del Perú.
"libro_rojo_fichas"

#' Backbone Consolidado de Fauna Amenazada del Perú
#'
#' Base taxonómica integrada que unifica el DS 004-2014-MINAGRI y el Libro Rojo
#' de la Fauna Silvestre Amenazada del Perú (2018), optimizada para búsquedas y
#' reconciliación de alta velocidad.
#'
#' @format Un tibble con 536 filas y 16 variables:
#' \describe{
#'   \item{scientific_name}{Nombre científico aceptado.}
#'   \item{genus}{Género taxonómico.}
#'   \item{species}{Epíteto específico.}
#'   \item{subspecies}{Subespecie (si aplica).}
#'   \item{clase}{Clase o grupo taxonómico.}
#'   \item{order_name}{Orden taxonómico.}
#'   \item{family_name}{Familia taxonómica.}
#'   \item{common_name}{Nombre común más representativo.}
#'   \item{synonyms}{Sinónimos conocidos consolidados.}
#'   \item{in_ds004}{Lógico indicando presencia en DS 004-2014-MINAGRI.}
#'   \item{ds004_code}{Código en DS 004 (CR, EN, VU, NT, DD).}
#'   \item{ds004_categoria}{Descripción en DS 004.}
#'   \item{in_libro_rojo}{Lógico indicando presencia en Libro Rojo 2018.}
#'   \item{libro_rojo_code}{Código en Libro Rojo 2018.}
#'   \item{libro_rojo_categoria}{Descripción en Libro Rojo 2018.}
#'   \item{has_ficha}{Lógico indicando si cuenta con ficha técnica en Libro Rojo.}
#' }
"fauna_backbone"
