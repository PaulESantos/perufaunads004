# Introducción a perufaunads004

## Introducción

El paquete **perufaunads004** facilita la validación taxonómica y la
consulta del estado de conservación de especies de fauna silvestre de
Perú, integrando el **Decreto Supremo N° 004-2014-MINAGRI** y el **Libro
Rojo de la Fauna Silvestre Amenazada del Perú** (SERFOR, 2018).

``` r

library(perufaunads004)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Validación y Reconciliación con `fauna_matching`

El núcleo del paquete es
[`fauna_matching()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md),
que implementa una jerarquía de matching:

1.  **Coincidencia exacta**: Identifica nombres idénticos a los
    aceptados.
2.  **Sinónimos**: Resuelve nombres históricos y reubicaciones
    taxonómicas (por ejemplo, *Oreonax flavicauda* a *Lagothrix
    flavicauda*).
3.  **Coincidencia difusa (*fuzzy*)**: Corrige errores tipográficos
    menores utilizando algoritmos de distancia de cadenas de
    `stringdist`.
4.  **Nivel de género**: Proporciona advertencias contextuales si solo
    se cuenta con el género (ej. *Telmatobius sp.*).

``` r

lista_ejemplo <- c(
  "Tremarctos ornatus",
  "Oreonax flavicauda",
  "Vultor gryphus",
  "Telmatobius culeus",
  "Panthera onca",
  "Panthera leo"
)

res <- fauna_matching(lista_ejemplo)

res |>
  select(submitted_name, matched_name, match_type, ds004_code, libro_rojo_code, clase)
#> # A tibble: 6 × 6
#>   submitted_name     matched_name    match_type ds004_code libro_rojo_code clase
#>   <chr>              <chr>           <chr>      <chr>      <chr>           <chr>
#> 1 Tremarctos ornatus Tremarctos orn… exact      VU         VU              Mamí…
#> 2 Oreonax flavicauda Oreonax flavic… exact      CR         NA              Mamí…
#> 3 Vultor gryphus     Vultur gryphus  fuzzy      EN         EN              Aves 
#> 4 Telmatobius culeus Telmatobius cu… exact      CR         CR              Anfi…
#> 5 Panthera onca      Panthera onca   exact      NT         NT              Mamí…
#> 6 Panthera leo       NA              no_match   NA         NA              NA
```

## Acceso a Fichas Técnicas con `get_ficha`

Para especies que cuentan con ficha técnica en el Libro Rojo (381
especies), se puede extraer la información detallada:

``` r

fc <- get_ficha("Tremarctos ornatus")
fc |> select(species_name, ficha_categoria, common_name, autores)
#> # A tibble: 1 × 4
#>   species_name                    ficha_categoria common_name            autores
#>   <chr>                           <chr>           <chr>                  <chr>  
#> 1 Tremarctos ornatus Cuvier, 1825 VU / A4cd       Oso de anteojos, oso … J. Ama…
```
