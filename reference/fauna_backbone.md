# Backbone Consolidado de Fauna Amenazada del Perú

Base de datos taxonómica relacional unificada que integra el Decreto
Supremo N° 004-2014-MINAGRI y el Libro Rojo de la Fauna Silvestre
Amenazada del Perú (SERFOR, 2018).

## Usage

``` r
fauna_backbone
```

## Format

Un tibble con 536 filas y 16 variables:

- scientific_name:

  Nombre científico aceptado y normalizado.

- genus:

  Género taxonómico.

- species:

  Epíteto específico.

- subspecies:

  Subespecie (si aplica).

- clase:

  Clase o grupo faunístico.

- order_name:

  Orden taxonómico.

- family_name:

  Familia taxonómica.

- common_name:

  Nombre común más representativo.

- synonyms:

  Sinónimos históricos y alternativos consolidados.

- in_ds004:

  Lógico (\`TRUE\`/\`FALSE\`) indicando presencia en el D.S. N°
  004-2014-MINAGRI.

- ds004_code:

  Código en D.S. 004 (CR, EN, VU, NT, DD).

- ds004_categoria:

  Descripción completa de la categoría legal en D.S. 004.

- in_libro_rojo:

  Lógico (\`TRUE\`/\`FALSE\`) indicando presencia en el Libro Rojo 2018.

- libro_rojo_code:

  Código en Libro Rojo 2018 (CR, EN, VU, NT, DD).

- libro_rojo_categoria:

  Descripción de categoría en Libro Rojo 2018.

- has_ficha:

  Lógico (\`TRUE\`/\`FALSE\`) indicando si cuenta con ficha técnica
  monográfica.

## Source

Compilado y unificado a partir de MINAGRI (2014) y SERFOR (2018).

## Details

Este dataset constituye la columna vertebral (\*backbone\*) del motor de
reconciliación taxonómica \`fauna_matching()\`. Permite resolver
discrepancias entre ambas listas oficiales:

- Homogeneización de sinonimias históricas (ej. \*Oreonax flavicauda\* a
  \*Lagothrix flavicauda\*).

- Corrección de exclusiones o precisiones geográficas (ej. el anfibio
  \*Psychophrynella wettsteini\*, cuyos registros en Perú se
  determinaron erróneos y fue excluido del Libro Rojo).

- Indexación cruzada de estatus legal (DS 004) vs estatus técnico (Libro
  Rojo) y disponibilidad de monografía técnica (\`has_ficha\`).

## See also

[`fauna_matching`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md),
[`get_ficha`](https://paulesantos.github.io/perufaunads004/reference/get_ficha.md),
[`is_threatened`](https://paulesantos.github.io/perufaunads004/reference/is_threatened.md)
