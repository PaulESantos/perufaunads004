#' Verificar si una especie está categorizada como amenazada
#'
#' Determina de forma vectorizada si una especie de fauna silvestre está listada
#' bajo alguna categoría de amenaza en el Decreto Supremo N° 004-2014-MINAGRI
#' o en el Libro Rojo de la Fauna Silvestre Amenazada del Perú (2018).
#'
#' @param species Vector de caracteres con nombres científicos de especies.
#' @param only_threatened Lógico. Si es \code{TRUE}, solo considera amenazadas las categorías
#'   UICN de amenaza estricta: En Peligro Crítico (\code{CR}), En Peligro (\code{EN}) y
#'   Vulnerable (\code{VU}). Si es \code{FALSE} (por defecto), incluye también Casi
#'   Amenazado (\code{NT}) y Datos Insuficientes (\code{DD}).
#'
#' @return Un vector lógico de la misma longitud que \code{species}.
#'
#' @examples
#' is_threatened(c("Tremarctos ornatus", "Panthera leo"))
#' is_threatened(c("Puma concolor", "Vultur gryphus"), only_threatened = TRUE)
#'
#' @export
is_threatened <- function(species, only_threatened = FALSE) {
  if (missing(species) || length(species) == 0) return(logical(0))

  matched <- fauna_matching(species, genus_match = FALSE)
  
  if (only_threatened) {
    strict_cats <- c("CR", "EN", "VU")
    (matched$ds004_code %in% strict_cats) | (matched$libro_rojo_code %in% strict_cats)
  } else {
    matched$in_ds004 | matched$in_libro_rojo
  }
}
