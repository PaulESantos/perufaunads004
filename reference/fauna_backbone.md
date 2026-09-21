# Backbone Consolidado de Fauna Amenazada del Perú

Base taxonómica integrada que unifica el DS 004-2014-MINAGRI y el Libro
Rojo de la Fauna Silvestre Amenazada del Perú (2018), optimizada para
búsquedas y reconciliación de alta velocidad.

## Usage

``` r
fauna_backbone
```

## Format

Un tibble con 536 filas y 16 variables:

- scientific_name:

  Nombre científico aceptado.

- genus:

  Género taxonómico.

- species:

  Epíteto específico.

- subspecies:

  Subespecie (si aplica).

- clase:

  Clase o grupo taxonómico.

- order_name:

  Orden taxonómico.

- family_name:

  Familia taxonómica.

- common_name:

  Nombre común más representativo.

- synonyms:

  Sinónimos conocidos consolidados.

- in_ds004:

  Lógico indicando presencia en DS 004-2014-MINAGRI.

- ds004_code:

  Código en DS 004 (CR, EN, VU, NT, DD).

- ds004_categoria:

  Descripción en DS 004.

- in_libro_rojo:

  Lógico indicando presencia en Libro Rojo 2018.

- libro_rojo_code:

  Código en Libro Rojo 2018.

- libro_rojo_categoria:

  Descripción en Libro Rojo 2018.

- has_ficha:

  Lógico indicando si cuenta con ficha técnica en Libro Rojo.
