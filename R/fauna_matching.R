#' Reconciliación y validación de nombres taxonómicos de fauna silvestre
#'
#' Compara y valida una lista de nombres de especies de fauna silvestre contra
#' la base oficial de especies amenazadas del Perú (DS 004-2014-MINAGRI y
#' Libro Rojo de la Fauna Silvestre Amenazada del Perú, SERFOR 2018). Aplica
#' un algoritmo de matching escalonado: exacto, sinónimos, difuso (fuzzy) y
#' nivel de género, de forma análoga a \code{wcvpmatch}.
#'
#' @param query Un vector de caracteres con nombres taxonómicos, o un
#'   \code{data.frame} / \code{tibble} con una columna de nombres.
#' @param target_df Base de datos de referencia. Por defecto es \code{NULL},
#'   utilizando el backbone consolidado incluido en el paquete (\code{fauna_backbone}).
#' @param species_col Nombre de la columna de nombres si \code{query} es un \code{data.frame}.
#' @param max_distance Distancia máxima de edición para matching difuso (por defecto \code{1}).
#' @param method Método de distancia de cadenas para \code{\link[stringdist]{stringdist}}
#'   (por defecto \code{"osa"}).
#' @param fuzzy Lógico. Si es \code{TRUE} (por defecto), realiza matching difuso cuando
#'   falla el match exacto y por sinónimos.
#' @param genus_match Lógico. Si es \code{TRUE} (por defecto), intenta emparejar al nivel
#'   de género cuando no se encuentra coincidencia a nivel de especie.
#' @param group Filtro opcional por clase/grupo taxonómico (ej. \code{"Mamíferos"},
#'   \code{"Aves"}, \code{"Anfibios"}, \code{"Reptiles"}, \code{"Invertebrados"}).
#'
#' @return Un \code{\link[tibble]{tibble}} con las siguientes columnas de auditoría y categorización:
#'   \describe{
#'     \item{submitted_name}{Nombre original recibido.}
#'     \item{clean_name}{Nombre normalizado utilizado para la búsqueda.}
#'     \item{matched_name}{Nombre científico aceptado en la norma o Libro Rojo.}
#'     \item{match_type}{Tipo de coincidencia: \code{"exact"}, \code{"synonym"}, \code{"fuzzy"}, \code{"genus"}, o \code{"no_match"}.}
#'     \item{match_status}{Estado: \code{"matched"}, \code{"ambiguous"}, o \code{"unmatched"}.}
#'     \item{distance}{Distancia de edición calculada (0 para exacto o sinónimo).}
#'     \item{similarity}{Puntaje de similaridad entre 0 y 1.}
#'     \item{clase}{Clase o grupo taxonómico (Mamíferos, Aves, etc.).}
#'     \item{order_name}{Orden taxonómico.}
#'     \item{family_name}{Familia taxonómica.}
#'     \item{common_name}{Nombre(s) común(es) registrado(s).}
#'     \item{ds004_code}{Categoría en DS 004-2014-MINAGRI (CR, EN, VU, NT, DD).}
#'     \item{ds004_categoria}{Descripción completa de la categoría en DS 004.}
#'     \item{libro_rojo_code}{Categoría en el Libro Rojo SERFOR 2018.}
#'     \item{libro_rojo_categoria}{Descripción completa de categoría en Libro Rojo.}
#'     \item{has_technical_sheet}{Lógico indicando si cuenta con ficha técnica descriptiva.}
#'     \item{in_ds004}{Lógico indicando si figura en el DS 004-2014-MINAGRI.}
#'     \item{in_libro_rojo}{Lógico indicando si figura en el Libro Rojo 2018.}
#'   }
#'
#' @examples
#' \donttest{
#' # Validación de nombres exactos, sinónimos y con error tipográfico
#' nombres <- c(
#'   "Tremarctos ornatus",
#'   "Oreonax flavicauda",           # Sinónimo de Lagothrix flavicauda
#'   "Vultor gryphus",               # Typo para Vultur gryphus
#'   "Telmatobius culeus",
#'   "Panthera leo"                  # No amenazada en Perú
#' )
#' res <- fauna_matching(nombres)
#' res[, c("submitted_name", "matched_name", "match_type", "ds004_code", "libro_rojo_code")]
#' }
#'
#' @export
fauna_matching <- function(query,
                           target_df = NULL,
                           species_col = NULL,
                           max_distance = 1,
                           method = "osa",
                           fuzzy = TRUE,
                           genus_match = TRUE,
                           group = NULL) {

  # 1. Resolver base de datos de referencia
  if (is.null(target_df)) {
    target_df <- perufaunads004::fauna_backbone
  }

  if (!is.null(group)) {
    target_df <- target_df |>
      dplyr::filter(tolower(clase) %in% tolower(group))
    if (nrow(target_df) == 0) {
      cli::cli_abort("No hay registros en la base de referencia que coincidan con el grupo {.val {group}}.")
    }
  }

  # 2. Parsear los nombres de entrada
  parsed <- classify_spnames(query, species_col = species_col)
  
  if (nrow(parsed) == 0) {
    return(tibble::tibble(
      submitted_name       = character(0),
      clean_name           = character(0),
      matched_name         = character(0),
      match_type           = character(0),
      match_status         = character(0),
      distance             = numeric(0),
      similarity           = numeric(0),
      clase                = character(0),
      order_name           = character(0),
      family_name          = character(0),
      common_name          = character(0),
      ds004_code           = character(0),
      ds004_categoria      = character(0),
      libro_rojo_code      = character(0),
      libro_rojo_categoria = character(0),
      has_technical_sheet  = logical(0),
      in_ds004             = logical(0),
      in_libro_rojo        = logical(0)
    ))
  }

  # Preparar vectores de búsqueda en target
  target_sci_lower <- tolower(target_df$scientific_name)
  target_genus_lower <- tolower(target_df$genus)

  # Extraer tabla de sinónimos desagregada para búsqueda rápida
  synonym_map <- list()
  for (i in seq_len(nrow(target_df))) {
    syns <- target_df$synonyms[i]
    if (!is.na(syns) && nzchar(syns)) {
      # Puede haber varios sinónimos separados por '|'
      split_syns <- stringr::str_split(syns, "\\|")[[1]]
      for (s in split_syns) {
        s_clean <- tolower(stringr::str_squish(s))
        # Quitar posibles paréntesis internos
        s_clean <- stringr::str_replace_all(s_clean, "[()]", "")
        if (nzchar(s_clean)) {
          synonym_map[[length(synonym_map) + 1]] <- tibble::tibble(
            synonym_clean = s_clean,
            target_idx = i
          )
        }
      }
    }
  }
  synonym_df <- if (length(synonym_map) > 0) dplyr::bind_rows(synonym_map) else NULL

  # Función auxiliar para armar fila de resultado
  build_match_row <- function(sub_nm, cln_nm, match_type, match_status, dist, sim, tgt_row) {
    if (is.null(tgt_row) || nrow(tgt_row) == 0) {
      return(tibble::tibble(
        submitted_name       = sub_nm,
        clean_name           = cln_nm,
        matched_name         = NA_character_,
        match_type           = match_type,
        match_status         = match_status,
        distance             = dist,
        similarity           = sim,
        clase                = NA_character_,
        order_name           = NA_character_,
        family_name          = NA_character_,
        common_name          = NA_character_,
        ds004_code           = NA_character_,
        ds004_categoria      = NA_character_,
        libro_rojo_code      = NA_character_,
        libro_rojo_categoria = NA_character_,
        has_technical_sheet  = FALSE,
        in_ds004             = FALSE,
        in_libro_rojo        = FALSE
      ))
    }

    tibble::tibble(
      submitted_name       = sub_nm,
      clean_name           = cln_nm,
      matched_name         = tgt_row$scientific_name[1],
      match_type           = match_type,
      match_status         = match_status,
      distance             = dist,
      similarity           = sim,
      clase                = tgt_row$clase[1],
      order_name           = tgt_row$order_name[1],
      family_name          = tgt_row$family_name[1],
      common_name          = tgt_row$common_name[1],
      ds004_code           = as.character(tgt_row$ds004_code[1]),
      ds004_categoria      = tgt_row$ds004_categoria[1],
      libro_rojo_code      = as.character(tgt_row$libro_rojo_code[1]),
      libro_rojo_categoria = tgt_row$libro_rojo_categoria[1],
      has_technical_sheet  = tgt_row$has_ficha[1],
      in_ds004             = tgt_row$in_ds004[1],
      in_libro_rojo        = tgt_row$in_libro_rojo[1]
    )
  }

  results_list <- vector("list", nrow(parsed))

  for (k in seq_len(nrow(parsed))) {
    sub_nm <- parsed$submitted_name[k]
    cln_nm <- parsed$clean_name[k]
    g_nm   <- parsed$genus[k]
    sp_nm  <- parsed$species[k]

    if (is.na(cln_nm) || cln_nm == "") {
      results_list[[k]] <- build_match_row(sub_nm, cln_nm, "no_match", "unmatched", NA_real_, 0, NULL)
      next
    }

    cln_lower <- tolower(cln_nm)

    # --------------------------------------------------------------------------
    # PASO 1: Coincidencia Exacta
    # --------------------------------------------------------------------------
    exact_idx <- which(target_sci_lower == cln_lower)
    if (length(exact_idx) > 0) {
      tgt_row <- target_df[exact_idx[1], ]
      results_list[[k]] <- build_match_row(sub_nm, cln_nm, "exact", "matched", 0, 1.0, tgt_row)
      next
    }

    # Probar exact match sin subespecie (binomio puro) si tenía subespecie
    if (!is.na(sp_nm) && !is.na(g_nm)) {
      binom_clean <- tolower(paste(g_nm, sp_nm))
      binom_idx <- which(target_sci_lower == binom_clean)
      if (length(binom_idx) > 0) {
        tgt_row <- target_df[binom_idx[1], ]
        results_list[[k]] <- build_match_row(sub_nm, cln_nm, "exact", "matched", 0, 1.0, tgt_row)
        next
      }
    }

    # --------------------------------------------------------------------------
    # PASO 2: Coincidencia por Sinónimo
    # --------------------------------------------------------------------------
    syn_match_idx <- integer(0)
    if (!is.null(synonym_df)) {
      s_hit <- synonym_df |> dplyr::filter(synonym_clean == cln_lower)
      if (nrow(s_hit) > 0) {
        syn_match_idx <- s_hit$target_idx[1]
      } else if (!is.na(sp_nm) && !is.na(g_nm)) {
        binom_clean <- tolower(paste(g_nm, sp_nm))
        s_hit2 <- synonym_df |> dplyr::filter(synonym_clean == binom_clean)
        if (nrow(s_hit2) > 0) {
          syn_match_idx <- s_hit2$target_idx[1]
        }
      }
    }

    if (length(syn_match_idx) > 0) {
      tgt_row <- target_df[syn_match_idx, ]
      results_list[[k]] <- build_match_row(sub_nm, cln_nm, "synonym", "matched", 0, 1.0, tgt_row)
      next
    }

    is_generic_sp <- is.na(sp_nm) || sp_nm %in% c("sp", "spp", "indet", "cf", "aff", "sp.")

    # --------------------------------------------------------------------------
    # PASO 3: Matching Difuso (Fuzzy Match)
    # --------------------------------------------------------------------------
    fuzzy_matched <- FALSE
    if (fuzzy && !is_generic_sp) {
      # Estrategia 3A: Si el género coincide exactamente, comparar epíteto específico
      if (!is.na(g_nm) && tolower(g_nm) %in% target_genus_lower) {
        genus_indices <- which(target_genus_lower == tolower(g_nm))
        genus_targets <- target_sci_lower[genus_indices]

        dists <- stringdist::stringdist(cln_lower, genus_targets, method = method)
        min_d <- min(dists)

        if (min_d <= max_distance) {
          best_in_genus <- which(dists == min_d)
          chosen_idx <- genus_indices[best_in_genus[1]]
          status_val <- if (length(best_in_genus) > 1) "ambiguous" else "matched"
          max_len <- max(nchar(cln_lower), nchar(genus_targets[best_in_genus[1]]))
          sim_val <- round(1 - (min_d / max_len), 4)

          tgt_row <- target_df[chosen_idx, ]
          results_list[[k]] <- build_match_row(sub_nm, cln_nm, "fuzzy", status_val, min_d, sim_val, tgt_row)
          fuzzy_matched <- TRUE
        }
      }

      # Estrategia 3B: Si no hubo match dentro del género, probar globalmente
      if (!fuzzy_matched) {
        all_dists <- stringdist::stringdist(cln_lower, target_sci_lower, method = method)
        min_global_d <- min(all_dists)

        if (min_global_d <= max_distance) {
          best_global <- which(all_dists == min_global_d)
          chosen_idx <- best_global[1]
          status_val <- if (length(best_global) > 1) "ambiguous" else "matched"
          max_len <- max(nchar(cln_lower), nchar(target_sci_lower[chosen_idx]))
          sim_val <- round(1 - (min_global_d / max_len), 4)

          tgt_row <- target_df[chosen_idx, ]
          results_list[[k]] <- build_match_row(sub_nm, cln_nm, "fuzzy", status_val, min_global_d, sim_val, tgt_row)
          fuzzy_matched <- TRUE
        }
      }
    }

    if (fuzzy_matched) next

    # --------------------------------------------------------------------------
    # PASO 4: Matching a Nivel de Género
    # --------------------------------------------------------------------------
    # Se activa a nivel de género si la especie no fue especificada (ej. 'Genus sp.',
    # 'Genus spp.', 'Genus indet.') o si genus_match = TRUE y no hay epíteto válido.
    if (genus_match && is_generic_sp && !is.na(g_nm) && tolower(g_nm) %in% target_genus_lower) {
      g_indices <- which(target_genus_lower == tolower(g_nm))
      first_row <- target_df[g_indices[1], ]
      status_val <- if (length(g_indices) > 1) "ambiguous" else "matched"
      matched_genus_label <- if (length(g_indices) > 1) {
        paste0(first_row$genus, " spp. (", length(g_indices), " especies amenazadas)")
      } else {
        paste0(first_row$genus, " sp. (", first_row$scientific_name, ")")
      }

      genus_tib <- tibble::tibble(
        scientific_name = matched_genus_label,
        clase           = first_row$clase,
        order_name      = first_row$order_name,
        family_name     = first_row$family_name,
        common_name     = if (length(g_indices) == 1) first_row$common_name else NA_character_,
        ds004_code      = if (length(g_indices) == 1) as.character(first_row$ds004_code) else "Multiple",
        ds004_categoria = if (length(g_indices) == 1) first_row$ds004_categoria else "M\u00faltiples categor\u00edas en el g\u00e9nero",
        libro_rojo_code = if (length(g_indices) == 1) as.character(first_row$libro_rojo_code) else "Multiple",
        libro_rojo_categoria = if (length(g_indices) == 1) first_row$libro_rojo_categoria else "M\u00faltiples categor\u00edas",
        has_ficha       = any(target_df$has_ficha[g_indices]),
        in_ds004        = FALSE, # La consulta no especifico una especie protegida exacta
        in_libro_rojo   = FALSE
      )

      results_list[[k]] <- build_match_row(sub_nm, cln_nm, "genus", status_val, NA_real_, 0.5, genus_tib)
      next
    }

    # --------------------------------------------------------------------------
    # PASO 5: Sin Coincidencia
    # --------------------------------------------------------------------------
    results_list[[k]] <- build_match_row(sub_nm, cln_nm, "no_match", "unmatched", NA_real_, 0, NULL)
  }

  dplyr::bind_rows(results_list)
}
