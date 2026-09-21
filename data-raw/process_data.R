# ==============================================================================
# Script de procesamiento y creación de datos para 'perufaunads004'
# ==============================================================================
suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(stringr)
  library(tibble)
})

root_clean <- "D:/mammalperu_data/clean_data"
f_ds004      <- file.path(root_clean, "ds004_minagri_clean.xlsx")
f_redbook_sp <- file.path(root_clean, "especies_libro_rojo_fauna_peru.xlsx")
f_redbook_fc <- file.path(root_clean, "libro_rojo_fauna_peru_20260104.xlsx")

# ------------------------------------------------------------------------------
# 1. Procesar DS 004-2014-MINAGRI
# ------------------------------------------------------------------------------
raw_ds004 <- read_excel(f_ds004)

ds004_fauna <- raw_ds004 |>
  mutate(across(where(is.character), str_squish)) |>
  rename(
    ds004_id               = id,
    ds004_categoria_codigo = categoria_codigo,
    ds004_categoria        = categoria,
    clase                  = clase,
    genus                  = genus,
    species                = species,
    subspecies             = subspecies,
    scientific_name        = scientific_name,
    common_name            = common_name,
    synonym_scientific_name = synonym_scientific_name,
    observacion            = observacion
  ) |>
  mutate(
    ds004_categoria_codigo = factor(
      ds004_categoria_codigo,
      levels = c("CR", "EN", "VU", "NT", "DD"),
      ordered = TRUE
    ),
    clase = str_to_title(clase),
    scientific_name = str_squish(scientific_name)
  )

# ------------------------------------------------------------------------------
# 2. Procesar Especies del Libro Rojo (SERFOR, 2018)
# ------------------------------------------------------------------------------
raw_redbook_sp <- read_excel(f_redbook_sp)

libro_rojo_especies <- raw_redbook_sp |>
  mutate(across(where(is.character), str_squish)) |>
  rename(
    libro_rojo_id          = `N°`,
    libro_rojo_categoria   = `Categoría de amenaza`,
    libro_rojo_codigo      = `Código`,
    grupo_taxonomico       = `Grupo taxonómico`,
    scientific_name_raw    = `Especie (nombre científico)`,
    sinonimo               = `Sinónimo / nombre adicional`
  ) |>
  mutate(
    # Limpiar posibles comillas y nombres comunes incrustados (e.g. 'jabiru mycteria "jabirú"')
    scientific_name = scientific_name_raw |>
      str_remove_all('["\'”„«»]') |>
      str_replace_all("\\bjabirú\\b", "") |>
      str_squish(),
    libro_rojo_codigo = factor(
      libro_rojo_codigo,
      levels = c("CR", "EN", "VU", "NT", "DD"),
      ordered = TRUE
    ),
    grupo_taxonomico = str_to_title(grupo_taxonomico)
  )

# ------------------------------------------------------------------------------
# 3. Procesar Fichas Técnicas del Libro Rojo (SERFOR, 2018)
# ------------------------------------------------------------------------------
raw_redbook_fc <- read_excel(f_redbook_fc)

libro_rojo_fichas <- raw_redbook_fc |>
  select(-any_of(c("...17", ""))) |>
  mutate(across(where(is.character), str_squish)) |>
  rename(
    ficha_categoria = categoria,
    ficha_grupo     = grupo_taxonomico
  ) |>
  mutate(
    # Nombre binomial/trinomial limpio para cruce
    canonical_name = case_when(
      !is.na(subespecie) & subespecie != "" ~ paste(genus, species, subespecie),
      !is.na(species) & species != ""       ~ paste(genus, species),
      TRUE                                  ~ genus
    ) |> str_squish()
  )

# ------------------------------------------------------------------------------
# 4. Construir Backbone Consolidado para Reconciliación Taxonómica Rápida
# ------------------------------------------------------------------------------
# Obtenemos el universo completo de especies reconocidas
all_accepted_names <- unique(c(
  ds004_fauna$scientific_name,
  libro_rojo_especies$scientific_name
))

# Creamos la base unificada
backbone_list <- list()

for (sp in all_accepted_names) {
  row_ds  <- ds004_fauna |> filter(tolower(scientific_name) == tolower(sp))
  row_lr  <- libro_rojo_especies |> filter(tolower(scientific_name) == tolower(sp))
  row_fc  <- libro_rojo_fichas |> filter(tolower(canonical_name) == tolower(sp))
  
  # Si no hubo match exacto en ficha, intentar con genus y species
  if (nrow(row_fc) == 0) {
    parts <- str_split(sp, "\\s+")[[1]]
    if (length(parts) >= 2) {
      row_fc <- libro_rojo_fichas |> 
        filter(tolower(genus) == tolower(parts[1]), tolower(species) == tolower(parts[2]))
    }
  }

  clase_val <- if (nrow(row_ds) > 0 && !is.na(row_ds$clase[1])) {
    row_ds$clase[1]
  } else if (nrow(row_lr) > 0 && !is.na(row_lr$grupo_taxonomico[1])) {
    row_lr$grupo_taxonomico[1]
  } else if (nrow(row_fc) > 0 && !is.na(row_fc$class_name[1])) {
    row_fc$class_name[1]
  } else {
    NA_character_
  }

  common_val <- if (nrow(row_ds) > 0 && !is.na(row_ds$common_name[1])) {
    row_ds$common_name[1]
  } else if (nrow(row_fc) > 0 && !is.na(row_fc$common_name[1])) {
    row_fc$common_name[1]
  } else {
    NA_character_
  }

  syn_val <- c(
    if (nrow(row_ds) > 0 && !is.na(row_ds$synonym_scientific_name[1])) row_ds$synonym_scientific_name[1] else NULL,
    if (nrow(row_lr) > 0 && !is.na(row_lr$sinonimo[1])) row_lr$sinonimo[1] else NULL
  )
  syn_clean <- if (length(syn_val) > 0) paste(unique(syn_val), collapse = " | ") else NA_character_

  order_val <- if (nrow(row_fc) > 0 && !is.na(row_fc$order_name[1])) row_fc$order_name[1] else NA_character_
  family_val <- if (nrow(row_fc) > 0 && !is.na(row_fc$family_name[1])) row_fc$family_name[1] else NA_character_

  parts <- str_split(sp, "\\s+")[[1]]
  genus_val <- parts[1]
  species_val <- if (length(parts) >= 2) parts[2] else NA_character_
  subspecies_val <- if (length(parts) >= 3) paste(parts[3:length(parts)], collapse = " ") else NA_character_

  backbone_list[[sp]] <- tibble(
    scientific_name        = sp,
    genus                  = genus_val,
    species                = species_val,
    subspecies             = subspecies_val,
    clase                  = clase_val,
    order_name             = order_val,
    family_name            = family_val,
    common_name            = common_val,
    synonyms               = syn_clean,
    in_ds004               = nrow(row_ds) > 0,
    ds004_code             = if (nrow(row_ds) > 0) as.character(row_ds$ds004_categoria_codigo[1]) else NA_character_,
    ds004_categoria        = if (nrow(row_ds) > 0) row_ds$ds004_categoria[1] else NA_character_,
    in_libro_rojo          = nrow(row_lr) > 0,
    libro_rojo_code        = if (nrow(row_lr) > 0) as.character(row_lr$libro_rojo_codigo[1]) else NA_character_,
    libro_rojo_categoria   = if (nrow(row_lr) > 0) row_lr$libro_rojo_categoria[1] else NA_character_,
    has_ficha              = nrow(row_fc) > 0
  )
}

fauna_backbone <- bind_rows(backbone_list)

# Asegurar orden factores
fauna_backbone <- fauna_backbone |>
  mutate(
    ds004_code = factor(ds004_code, levels = c("CR", "EN", "VU", "NT", "DD"), ordered = TRUE),
    libro_rojo_code = factor(libro_rojo_code, levels = c("CR", "EN", "VU", "NT", "DD"), ordered = TRUE)
  )

cat("Procesamiento completado con éxito:\n")
cat("- ds004_fauna:", nrow(ds004_fauna), "especies\n")
cat("- libro_rojo_especies:", nrow(libro_rojo_especies), "especies\n")
cat("- libro_rojo_fichas:", nrow(libro_rojo_fichas), "fichas\n")
cat("- fauna_backbone:", nrow(fauna_backbone), "especies consolidadas\n")

# Guardar en perufaunads004/data/
dir_data <- "D:/mammalperu_data/perufaunads004/data"
if (!dir.exists(dir_data)) dir.create(dir_data, recursive = TRUE)

save(ds004_fauna, file = file.path(dir_data, "ds004_fauna.rda"), compress = "xz")
save(libro_rojo_especies, file = file.path(dir_data, "libro_rojo_especies.rda"), compress = "xz")
save(libro_rojo_fichas, file = file.path(dir_data, "libro_rojo_fichas.rda"), compress = "xz")
save(fauna_backbone, file = file.path(dir_data, "fauna_backbone.rda"), compress = "xz")

cat("Archivos .rda guardados exitosamente en:", dir_data, "\n")
