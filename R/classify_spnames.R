#' Clasificar y descomponer nombres científicos de especies
#'
#' Descompone nombres científicos de especies de fauna en sus elementos
#' taxonómicos constitutivos: género, epíteto específico, epíteto infraespecífico /
#' subespecie y autoría taxonómica, siguiendo los principios de 'wcvpmatch'.
#'
#' @param data Un vector de caracteres con nombres taxonómicos, o un \code{data.frame}
#'   / \code{tibble} que contenga una columna con nombres.
#' @param species_col Nombre de la columna que contiene los nombres científicos
#'   cuando \code{data} es un \code{data.frame}. Por defecto busca columnas como
#'   \code{"scientific_name"}, \code{"species"}, \code{"species_name"} o toma la primera columna.
#'
#' @return Un \code{\link[tibble]{tibble}} con las siguientes columnas:
#'   \describe{
#'     \item{submitted_name}{El nombre tal como fue ingresado originalmente.}
#'     \item{clean_name}{El nombre científico limpio (género + epíteto específico [+ subespecie]).}
#'     \item{genus}{El género taxonómico con mayúscula inicial.}
#'     \item{species}{El epíteto específico en minúsculas.}
#'     \item{subspecies}{El epíteto de subespecie (o \code{NA_character_} si no aplica).}
#'     \item{authorship}{La autoría y año taxonómico detectado (o \code{NA_character_}).}
#'   }
#'
#' @examples
#' # A partir de un vector de nombres
#' nombres <- c(
#'   "Tremarctos ornatus (Cuvier, 1825)",
#'   "Telmatobius culeus",
#'   "Lama guanicoe cacsilensis",
#'   "Vultur gryphus Linnaeus 1758",
#'   "Puma concolor"
#' )
#' ds004_classify_spnames(nombres)
#'
#' # Integración con pipes tidyverse
#' library(tibble)
#' df <- tibble(sp = c("Lagothrix flavicauda", "Inia geoffrensis"))
#' df |> ds004_classify_spnames(species_col = "sp")
#'
#' @rdname ds004_classify_spnames
#' @export
ds004_classify_spnames <- function(data, species_col = NULL) {
  # Manejo si data es data.frame o vector
  if (is.data.frame(data)) {
    if (is.null(species_col)) {
      candidates <- c("scientific_name", "species_name", "species", "name", "nombre_cientifico")
      matched_col <- intersect(tolower(candidates), tolower(names(data)))
      if (length(matched_col) > 0) {
        species_col <- names(data)[which(tolower(names(data)) == matched_col[1])[1]]
      } else {
        species_col <- names(data)[1]
        cli::cli_inform("Usando la columna {.var {species_col}} como fuente de nombres.")
      }
    }
    input_names <- data[[species_col]]
  } else {
    input_names <- as.character(data)
  }

  if (length(input_names) == 0) {
    return(tibble::tibble(
      submitted_name = character(0),
      clean_name     = character(0),
      genus          = character(0),
      species        = character(0),
      subspecies     = character(0),
      authorship     = character(0)
    ))
  }

  particulas_autor <- c("du", "von", "van", "de", "di", "da", "dos", "del", "degli", "y", "et", "&")
  rangos_infra <- c("subsp.", "subsp", "ssp.", "ssp", "var.", "var", "forma", "f.")

  parse_single_name <- function(raw_nm) {
    if (is.na(raw_nm) || raw_nm == "") {
      return(list(
        submitted_name = raw_nm,
        clean_name = NA_character_,
        genus = NA_character_,
        species = NA_character_,
        subspecies = NA_character_,
        authorship = NA_character_
      ))
    }

    # Limpiar comillas iniciales/finales y espacios
    s_clean <- stringr::str_replace_all(raw_nm, "[\"\'\\u201c\\u201d\\u201e\\u00ab\\u00bb]", "")
    s_clean <- stringr::str_squish(s_clean)

    # Identificar posibles autores entre parentesis al final
    # Ej: "Tremarctos ornatus (Cuvier, 1825)"
    author_paren <- stringr::str_extract(s_clean, "\\((?:[^)(]+|\\([^)(]*\\))*\\)$")
    name_no_paren <- if (!is.na(author_paren)) {
      stringr::str_squish(stringr::str_remove(s_clean, "\\((?:[^)(]+|\\([^)(]*\\))*\\)$"))
    } else {
      s_clean
    }

    words <- stringr::str_split(name_no_paren, "\\s+")[[1]]
    if (length(words) == 0) {
      return(list(
        submitted_name = raw_nm,
        clean_name = NA_character_,
        genus = NA_character_,
        species = NA_character_,
        subspecies = NA_character_,
        authorship = NA_character_
      ))
    }

    genus_val <- stringr::str_to_title(words[1])
    
    # Evaluar palabras subsecuentes
    epitetos <- character(0)
    author_words <- character(0)
    i <- 2
    
    while (i <= length(words)) {
      w <- words[i]
      w_clean <- stringr::str_remove(w, "[,.;]+$")
      w_lower <- tolower(w_clean)

      # Si es marcador de rango infraespecifico (ej. subsp., ssp.), saltar
      if (w_lower %in% rangos_infra) {
        i <- i + 1
        next
      }

      # Comprobar si parece epiteto latino
      is_epithet <- FALSE
      if (stringr::str_detect(w_clean, "^[a-z\\u00e1\\u00e9\\u00ed\\u00f3\\u00fa\\u00f1]") && 
          !(w_lower %in% particulas_autor) &&
          !stringr::str_detect(w_clean, "[0-9]") &&
          !stringr::str_detect(w_clean, "^[a-zA-Z]['\u00b4\u2019][A-Z]")) {
        # Si no hemos detectado autores aún, es epíteto
        if (length(author_words) == 0) {
          is_epithet <- TRUE
        }
      }

      if (is_epithet && length(epitetos) < 2) {
        epitetos <- c(epitetos, tolower(w_clean))
      } else {
        # Es inicio de autoría
        author_words <- c(author_words, words[i:length(words)])
        break
      }
      i <- i + 1
    }

    species_val <- if (length(epitetos) >= 1) epitetos[1] else NA_character_
    subspecies_val <- if (length(epitetos) >= 2) epitetos[2] else NA_character_

    # Consolidar autoría
    auth_str <- paste(author_words, collapse = " ")
    if (!is.na(author_paren)) {
      auth_str <- stringr::str_squish(paste(auth_str, author_paren))
    }
    auth_str <- stringr::str_squish(auth_str)
    if (auth_str == "") auth_str <- NA_character_

    # Clean name
    clean_parts <- c(genus_val, species_val, subspecies_val)
    clean_parts <- clean_parts[!is.na(clean_parts) & clean_parts != ""]
    clean_name_val <- paste(clean_parts, collapse = " ")

    list(
      submitted_name = raw_nm,
      clean_name = clean_name_val,
      genus = genus_val,
      species = species_val,
      subspecies = subspecies_val,
      authorship = auth_str
    )
  }

  parsed_list <- lapply(input_names, parse_single_name)
  
  tibble::tibble(
    submitted_name = vapply(parsed_list, `[[`, "submitted_name", FUN.VALUE = character(1)),
    clean_name     = vapply(parsed_list, `[[`, "clean_name", FUN.VALUE = character(1)),
    genus          = vapply(parsed_list, `[[`, "genus", FUN.VALUE = character(1)),
    species        = vapply(parsed_list, `[[`, "species", FUN.VALUE = character(1)),
    subspecies     = vapply(parsed_list, `[[`, "subspecies", FUN.VALUE = character(1)),
    authorship     = vapply(parsed_list, `[[`, "authorship", FUN.VALUE = character(1))
  )
}

#' @rdname ds004_classify_spnames
#' @export
ds004_classify_names <- ds004_classify_spnames

# Alias interno para retrocompatibilidad interna en el paquete
classify_spnames <- ds004_classify_spnames
