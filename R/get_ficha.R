#' Obtener fichas técnicas del Libro Rojo de la Fauna Silvestre Amenazada
#'
#' Recupera la información monográfica detallada de las especies amenazadas que
#' cuentan con ficha técnica en el Libro Rojo de la Fauna Silvestre Amenazada
#' del Perú (SERFOR, 2018), incluyendo justificación de categorización,
#' distribución geográfica, principales amenazas, estado de conservación y autores.
#'
#' @param species Vector de caracteres con uno o más nombres científicos de especies.
#' @param print_details Lógico. Si es \code{TRUE}, imprime la ficha formateada en consola
#'   utilizando \code{cli}. Por defecto es \code{FALSE}.
#'
#' @return Un \code{\link[tibble]{tibble}} con los campos de la ficha técnica:
#'   \describe{
#'     \item{species_name}{Nombre científico completo con autoría original.}
#'     \item{canonical_name}{Nombre binomial o trinomial normalizado.}
#'     \item{common_name}{Nombres comunes.}
#'     \item{class_name}{Clase taxonómica.}
#'     \item{order_name}{Orden taxonómico.}
#'     \item{family_name}{Familia taxonómica.}
#'     \item{ficha_categoria}{Categoría y criterios UICN asignados.}
#'     \item{justificacion}{Justificación técnica del estado de amenaza.}
#'     \item{distribucion}{Distribución geográfica, altitudinal y localidades.}
#'     \item{amenazas}{Principales presiones antrópicas y ambientales.}
#'     \item{conservacion}{Presencia en Áreas Naturales Protegidas y medidas.}
#'     \item{autores}{Especialistas autores de la ficha.}
#'   }
#'
#' @examples
#' \donttest{
#' # Recuperar ficha del oso de anteojos
#' fc <- get_ficha("Tremarctos ornatus")
#'
#' # Imprimir en formato amigable en consola
#' get_ficha("Tremarctos ornatus", print_details = TRUE)
#' }
#'
#' @export
get_ficha <- function(species, print_details = FALSE) {
  if (missing(species) || length(species) == 0) {
    cli::cli_abort("Debe proporcionar al menos un nombre de especie en {.arg species}.")
  }

  fichas_db <- perufaunads004::libro_rojo_fichas

  # Limpiar nombres de consulta
  q_clean <- tolower(stringr::str_squish(species))
  
  matched_rows <- list()

  for (q in q_clean) {
    # 1. Match exacto en canonical_name
    hit <- fichas_db |> dplyr::filter(tolower(canonical_name) == q)

    # 2. Si no, match en species_name
    if (nrow(hit) == 0) {
      hit <- fichas_db |> dplyr::filter(tolower(species_name) == q)
    }

    # 3. Si no, match por género y especie
    if (nrow(hit) == 0) {
      parts <- stringr::str_split(q, "\\s+")[[1]]
      if (length(parts) >= 2) {
        hit <- fichas_db |> 
          dplyr::filter(tolower(genus) == parts[1], tolower(species) == parts[2])
      }
    }

    if (nrow(hit) > 0) {
      matched_rows[[length(matched_rows) + 1]] <- hit
    } else {
      cli::cli_warn("No se encontr\u00f3 ficha t\u00e9cnica para: {.val {q}}.")
    }
  }

  if (length(matched_rows) == 0) {
    return(fichas_db[0, ])
  }

  out_df <- dplyr::bind_rows(matched_rows)

  if (print_details) {
    for (i in seq_len(nrow(out_df))) {
      row <- out_df[i, ]
      cli::cli_rule(left = paste0("{.strong ", row$species_name, "}"))
      cli::cli_inform(c(
        "i" = paste0("{.bold Categor\u00eda:} ", row$ficha_categoria),
        "i" = paste0("{.bold Taxonom\u00eda:} ", row$class_name, " | ", row$order_name, " | ", row$family_name),
        "i" = paste0("{.bold Nombre com\u00fan:} ", ifelse(is.na(row$common_name), "No registrado", row$common_name)),
        " " = "",
        "v" = paste0("{.bold Justificaci\u00f3n:} ", row$justificacion),
        " " = "",
        "v" = paste0("{.bold Distribuci\u00f3n:} ", row$distribucion),
        " " = "",
        "!" = paste0("{.bold Amenazas:} ", row$amenazas),
        " " = "",
        "v" = paste0("{.bold Conservaci\u00f3n:} ", row$conservacion),
        " " = "",
        "i" = paste0("{.bold Autores:} ", row$autores)
      ))
      cli::cli_rule()
    }
  }

  out_df
}
