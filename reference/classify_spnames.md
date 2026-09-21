# Clasificar y descomponer nombres científicos de especies

Descompone nombres científicos de especies de fauna en sus elementos
taxonómicos constitutivos: género, epíteto específico, epíteto
infraespecífico / subespecie y autoría taxonómica, siguiendo los
principios de 'wcvpmatch'.

## Usage

``` r
classify_spnames(data, species_col = NULL)
```

## Arguments

- data:

  Un vector de caracteres con nombres taxonómicos, o un `data.frame` /
  `tibble` que contenga una columna con nombres.

- species_col:

  Nombre de la columna que contiene los nombres científicos cuando
  `data` es un `data.frame`. Por defecto busca columnas como
  `"scientific_name"`, `"species"`, `"species_name"` o toma la primera
  columna.

## Value

Un [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) con
las siguientes columnas:

- submitted_name:

  El nombre tal como fue ingresado originalmente.

- clean_name:

  El nombre científico limpio (género + epíteto específico \[+
  subespecie\]).

- genus:

  El género taxonómico con mayúscula inicial.

- species:

  El epíteto específico en minúsculas.

- subspecies:

  El epíteto de subespecie (o `NA_character_` si no aplica).

- authorship:

  La autoría y año taxonómico detectado (o `NA_character_`).

## Examples

``` r
# A partir de un vector de nombres
nombres <- c(
  "Tremarctos ornatus (Cuvier, 1825)",
  "Telmatobius culeus",
  "Lama guanicoe cacsilensis",
  "Vultur gryphus Linnaeus 1758",
  "Puma concolor"
)
classify_spnames(nombres)
#> # A tibble: 5 × 6
#>   submitted_name                  clean_name genus species subspecies authorship
#>   <chr>                           <chr>      <chr> <chr>   <chr>      <chr>     
#> 1 Tremarctos ornatus (Cuvier, 18… Tremarcto… Trem… ornatus NA         (Cuvier, …
#> 2 Telmatobius culeus              Telmatobi… Telm… culeus  NA         NA        
#> 3 Lama guanicoe cacsilensis       Lama guan… Lama  guanic… cacsilens… NA        
#> 4 Vultur gryphus Linnaeus 1758    Vultur gr… Vult… gryphus NA         Linnaeus …
#> 5 Puma concolor                   Puma conc… Puma  concol… NA         NA        

# Integración con pipes tidyverse
library(tibble)
df <- tibble(sp = c("Lagothrix flavicauda", "Inia geoffrensis"))
df |> classify_spnames(species_col = "sp")
#> # A tibble: 2 × 6
#>   submitted_name       clean_name           genus  species subspecies authorship
#>   <chr>                <chr>                <chr>  <chr>   <chr>      <chr>     
#> 1 Lagothrix flavicauda Lagothrix flavicauda Lagot… flavic… NA         NA        
#> 2 Inia geoffrensis     Inia geoffrensis     Inia   geoffr… NA         NA        
```
