# Reconciliación y validación de nombres taxonómicos de fauna silvestre

Compara y valida una lista de nombres de especies de fauna silvestre
contra la base oficial de especies amenazadas del Perú (DS
004-2014-MINAGRI y Libro Rojo de la Fauna Silvestre Amenazada del Perú,
SERFOR 2018). Aplica un algoritmo de matching escalonado: exacto,
sinónimos, difuso (fuzzy) y nivel de género, de forma análoga a
`wcvpmatch`.

## Usage

``` r
fauna_matching(
  query,
  target_df = NULL,
  species_col = NULL,
  max_distance = 1,
  method = "osa",
  fuzzy = TRUE,
  genus_match = TRUE,
  group = NULL
)

ds004_match(
  query,
  target_df = NULL,
  species_col = NULL,
  max_distance = 1,
  method = "osa",
  fuzzy = TRUE,
  genus_match = TRUE,
  group = NULL
)
```

## Arguments

- query:

  Un vector de caracteres con nombres taxonómicos, o un `data.frame` /
  `tibble` con una columna de nombres.

- target_df:

  Base de datos de referencia. Por defecto es `NULL`, utilizando el
  backbone consolidado incluido en el paquete (`fauna_backbone`).

- species_col:

  Nombre de la columna de nombres si `query` es un `data.frame`.

- max_distance:

  Distancia máxima de edición para matching difuso (por defecto `1`).

- method:

  Método de distancia de cadenas para
  [`stringdist`](https://rdrr.io/pkg/stringdist/man/stringdist.html)
  (por defecto `"osa"`).

- fuzzy:

  Lógico. Si es `TRUE` (por defecto), realiza matching difuso cuando
  falla el match exacto y por sinónimos.

- genus_match:

  Lógico. Si es `TRUE` (por defecto), intenta emparejar al nivel de
  género cuando no se encuentra coincidencia a nivel de especie.

- group:

  Filtro opcional por clase/grupo taxonómico (ej. `"Mamíferos"`,
  `"Aves"`, `"Anfibios"`, `"Reptiles"`, `"Invertebrados"`).

## Value

Un [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) con
las siguientes columnas de auditoría y categorización:

- submitted_name:

  Nombre original recibido.

- clean_name:

  Nombre normalizado utilizado para la búsqueda.

- matched_name:

  Nombre científico aceptado en la norma o Libro Rojo.

- match_type:

  Tipo de coincidencia: `"exact"`, `"synonym"`, `"fuzzy"`, `"genus"`, o
  `"no_match"`.

- match_status:

  Estado: `"matched"`, `"ambiguous"`, o `"unmatched"`.

- distance:

  Distancia de edición calculada (0 para exacto o sinónimo).

- similarity:

  Puntaje de similaridad entre 0 y 1.

- clase:

  Clase o grupo taxonómico (Mamíferos, Aves, etc.).

- order_name:

  Orden taxonómico.

- family_name:

  Familia taxonómica.

- common_name:

  Nombre(s) común(es) registrado(s).

- ds004_code:

  Categoría en DS 004-2014-MINAGRI (CR, EN, VU, NT, DD).

- ds004_categoria:

  Descripción completa de la categoría en DS 004.

- libro_rojo_code:

  Categoría en el Libro Rojo SERFOR 2018.

- libro_rojo_categoria:

  Descripción completa de categoría en Libro Rojo.

- has_technical_sheet:

  Lógico indicando si cuenta con ficha técnica descriptiva.

- in_ds004:

  Lógico indicando si figura en el DS 004-2014-MINAGRI.

- in_libro_rojo:

  Lógico indicando si figura en el Libro Rojo 2018.

## Examples

``` r
# \donttest{
# Validación de nombres exactos, sinónimos y con error tipográfico
nombres <- c(
  "Tremarctos ornatus",
  "Oreonax flavicauda",           # Sinónimo de Lagothrix flavicauda
  "Vultor gryphus",               # Typo para Vultur gryphus
  "Telmatobius culeus",
  "Panthera leo"                  # No amenazada en Perú
)
res <- fauna_matching(nombres)
res[, c("submitted_name", "matched_name", "match_type", "ds004_code", "libro_rojo_code")]
#> # A tibble: 5 × 5
#>   submitted_name     matched_name       match_type ds004_code libro_rojo_code
#>   <chr>              <chr>              <chr>      <chr>      <chr>          
#> 1 Tremarctos ornatus Tremarctos ornatus exact      VU         VU             
#> 2 Oreonax flavicauda Oreonax flavicauda exact      CR         NA             
#> 3 Vultor gryphus     Vultur gryphus     fuzzy      EN         EN             
#> 4 Telmatobius culeus Telmatobius culeus exact      CR         CR             
#> 5 Panthera leo       NA                 no_match   NA         NA             
# }
```
