#' Normalizar nombres científicos
#'
#' Limpia espacios redundantes, signos de puntuación periféricos y asegura
#' formato de mayúscula inicial para el género y minúsculas para el epíteto.
#'
#' @param x Vector de caracteres con nombres científicos.
#'
#' @return Vector de caracteres normalizado.
#' @keywords internal
normalize_name <- function(x) {
  if (is.null(x)) return(character(0))
  x <- as.character(x)
  
  x <- stringr::str_replace_all(x, "[\"\'\\u201c\\u201d\\u201e\\u00ab\\u00bb]", "")
  x <- stringr::str_replace_all(x, "[\\t\\r\\n]", " ")
  x <- stringr::str_squish(x)
  
  # Remover puntos o comas finales
  x <- stringr::str_remove(x, "[,.;]+$")
  
  # Estandarizar capitalización: primera palabra título, resto minúscula
  vapply(x, function(nm) {
    if (is.na(nm) || nm == "") return(nm)
    parts <- stringr::str_split(nm, "\\s+")[[1]]
    if (length(parts) == 0) return(nm)
    parts[1] <- stringr::str_to_title(parts[1])
    if (length(parts) > 1) {
      parts[2:length(parts)] <- tolower(parts[2:length(parts)])
    }
    paste(parts, collapse = " ")
  }, character(1), USE.NAMES = FALSE)
}

#' Remover tildes y diacríticos
#'
#' @param x Cadena de texto o vector de caracteres.
#'
#' @return Cadena sin tildes ni acentos.
#' @keywords internal
remove_accents <- function(x) {
  if (is.null(x)) return(character(0))
  iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
}
