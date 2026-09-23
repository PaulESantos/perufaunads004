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

      # 1. Badge de Categoría UICN con color representativo
      cat_str <- ifelse(is.na(row$ficha_categoria), "Sin categor\u00eda", row$ficha_categoria)
      cat_badge <- if (grepl("CR", cat_str)) {
        cli::col_br_red(cli::style_bold(paste0("[CR] ", cat_str)))
      } else if (grepl("EN", cat_str)) {
        cli::col_magenta(cli::style_bold(paste0("[EN] ", cat_str)))
      } else if (grepl("VU", cat_str)) {
        cli::col_yellow(cli::style_bold(paste0("[VU] ", cat_str)))
      } else {
        cli::col_cyan(cli::style_bold(paste0("[\u25cf] ", cat_str)))
      }

      # 2. Atributos complementarios
      com_name <- ifelse(is.na(row$common_name) || row$common_name == "", 
                         "No registrado", row$common_name)
      grupo_str <- ifelse(is.na(row$ficha_grupo), row$class_name, 
                          paste0(row$ficha_grupo, " (Clase ", row$class_name, ")"))
      autor_str <- ifelse(is.na(row$species_autor) || row$species_autor == "", 
                          "", paste0(" ", row$species_autor))

      # 3. Encabezado principal
      cli::cli_rule(
        left = paste0(
          cli::col_red(cli::style_bold("FICHA T\u00c9CNICA \u2022 ")), 
          cli::style_bold(cli::style_italic(row$canonical_name))
        )
      )

      # 4. Metadatos taxonómicos y de conservación
      cli::cli_bullets(c(
        "*" = paste0("{.field Especie:} ", cli::style_bold(cli::style_italic(row$canonical_name)), autor_str),
        "*" = paste0("{.field Nombre com\u00fan:} ", com_name),
        "*" = paste0("{.field Categor\u00eda Libro Rojo:} ", cat_badge),
        "*" = paste0("{.field Jerarqu\u00eda taxon\u00f3mica:} ", grupo_str, " \u2192 ", row$order_name, " \u2192 ", row$family_name)
      ))

      # 5. Secciones temáticas con indentación y estilo
      if (!is.na(row$justificacion) && nchar(trimws(row$justificacion)) > 0) {
        cli::cli_text("")
        cli::cli_alert_info(cli::style_bold("Justificaci\u00f3n T\u00e9cnica de la Categorizaci\u00f3n"))
        cli::cli_div(theme = list(body = list("margin-left" = 2)))
        cli::cli_text("{row$justificacion}")
        cli::cli_end()
      }

      if (!is.na(row$distribucion) && nchar(trimws(row$distribucion)) > 0) {
        cli::cli_text("")
        cli::cli_alert(cli::style_bold("Distribuci\u00f3n Geogr\u00e1fica y Localidades"), class = "alert-info")
        cli::cli_div(theme = list(body = list("margin-left" = 2)))
        cli::cli_text("{row$distribucion}")
        cli::cli_end()
      }

      if (!is.na(row$amenazas) && nchar(trimws(row$amenazas)) > 0) {
        cli::cli_text("")
        cli::cli_alert_danger(cli::style_bold("Principales Amenazas y Presiones Antr\u00f3picas"))
        cli::cli_div(theme = list(body = list("margin-left" = 2)))
        cli::cli_text("{row$amenazas}")
        cli::cli_end()
      }

      if (!is.na(row$conservacion) && nchar(trimws(row$conservacion)) > 0) {
        cli::cli_text("")
        cli::cli_alert_success(cli::style_bold("Medidas de Conservaci\u00f3n y Representatividad en el SINANPE"))
        cli::cli_div(theme = list(body = list("margin-left" = 2)))
        cli::cli_text("{row$conservacion}")
        cli::cli_end()
      }

      if (!is.na(row$autores) && nchar(trimws(row$autores)) > 0) {
        cli::cli_text("")
        cli::cli_bullets(c(
          "i" = paste0("{.field Especialistas autores:} ", cli::style_italic(row$autores))
        ))
      }

      # 6. Cierre de ficha
      cli::cli_rule(
        right = cli::col_grey("SERFOR (2018) \u2022 Libro Rojo de la Fauna Silvestre Amenazada del Per\u00fa")
      )

      if (i < nrow(out_df)) {
        cli::cli_text("")
      }
    }
  }

  out_df
}

#' @rdname get_ficha
#' @export
ds004_get_ficha <- get_ficha
