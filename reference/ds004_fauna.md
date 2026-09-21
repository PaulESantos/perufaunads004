# Lista de Fauna Silvestre Legalmente Protegida (DS 004-2014-MINAGRI)

Dataset con las 535 especies de fauna silvestre de Perú categorizadas
como amenazadas por el Decreto Supremo N° 004-2014-MINAGRI.

## Usage

``` r
ds004_fauna
```

## Format

Un tibble con 535 filas y 11 variables:

- ds004_id:

  Identificador correlativo del DS 004 (1 a 535).

- ds004_categoria_codigo:

  Código de categoría ordenado (CR, EN, VU, NT, DD).

- ds004_categoria:

  Descripción completa de la categoría de amenaza.

- clase:

  Clase taxonómica (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).

- genus:

  Género taxonómico.

- species:

  Epíteto específico.

- subspecies:

  Subespecie (si aplica).

- scientific_name:

  Nombre científico completo.

- common_name:

  Nombre(s) común(es) registrado(s).

- synonym_scientific_name:

  Sinónimo(s) registrado(s) en la norma.

- observacion:

  Notas sobre subespecies u observaciones taxonómicas.

## Source

Ministerio de Agricultura y Riego (MINAGRI, 2014).
