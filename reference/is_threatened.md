# Verificar si una especie está categorizada como amenazada

Determina de forma vectorizada si una especie de fauna silvestre está
listada bajo alguna categoría de amenaza en el Decreto Supremo N°
004-2014-MINAGRI o en el Libro Rojo de la Fauna Silvestre Amenazada del
Perú (2018).

## Usage

``` r
is_threatened(species, only_threatened = FALSE)
```

## Arguments

- species:

  Vector de caracteres con nombres científicos de especies.

- only_threatened:

  Lógico. Si es `TRUE`, solo considera amenazadas las categorías UICN de
  amenaza estricta: En Peligro Crítico (`CR`), En Peligro (`EN`) y
  Vulnerable (`VU`). Si es `FALSE` (por defecto), incluye también Casi
  Amenazado (`NT`) y Datos Insuficientes (`DD`).

## Value

Un vector lógico de la misma longitud que `species`.

## Examples

``` r
is_threatened(c("Tremarctos ornatus", "Panthera leo"))
#> [1]  TRUE FALSE
is_threatened(c("Puma concolor", "Vultur gryphus"), only_threatened = TRUE)
#> [1] FALSE  TRUE
```
