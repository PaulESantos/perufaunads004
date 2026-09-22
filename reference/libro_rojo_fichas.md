# Fichas Técnicas del Libro Rojo de Fauna Silvestre (SERFOR, 2018)

Compendio de 381 fichas técnicas monográficas exhaustivas elaboradas por
especialistas e investigadores de campo para las especies en situación
de amenaza comprobada (categorías CR, EN y VU) según el Libro Rojo de
SERFOR (2018).

## Usage

``` r
libro_rojo_fichas
```

## Format

Un tibble con 381 filas y 16 variables:

- genus:

  Género taxonómico validado.

- species:

  Epíteto específico.

- subespecie:

  Subespecie (si aplica).

- species_autor:

  Autoría y año de descripción taxonómica.

- class_name:

  Clase taxonómica (Amphibia, Aves, Mammalia, Reptilia, Insecta,
  Arachnida, Diplopoda, Gastropoda, Onychophora).

- order_name:

  Orden taxonómico.

- family_name:

  Familia taxonómica.

- species_name:

  Nombre científico binomial o trinomial completo con autoría.

- ficha_categoria:

  Categoría de amenaza y código de criterios UICN asignados (ej. "CR /
  B1ab(iii)").

- ficha_grupo:

  Grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).

- common_name:

  Nombre común vernacular representativo.

- justificacion:

  Texto íntegro de la justificación técnica de la categorización.

- distribucion:

  Texto íntegro de la distribución geográfica y altitudinal conocida.

- amenazas:

  Texto íntegro describiendo las presiones antropogénicas e impactos.

- conservacion:

  Texto íntegro de las medidas de conservación y representatividad en
  ANPs.

- autores:

  Especialistas e investigadores autores de la ficha técnica.

- canonical_name:

  Nombre científico normalizado en formato binario/trinario para joins
  computacionales.

## Source

SERFOR (2018). \*Libro Rojo de la Fauna Silvestre Amenazada del Perú\*.
Servicio Nacional Forestal y de Fauna Silvestre, Lima, Perú.

## Details

Cada ficha técnica representa una síntesis exhaustiva de la evidencia
empírica disponible a la fecha de publicación, cubriendo:

- \*\*Criterios UICN asignados\*\*: Desglose cuantitativo del criterio o
  combinación de criterios (A, B, C, D) y subcriterios que justifican la
  categoría. En la fauna peruana destaca el predominio del Criterio B
  (distribución geográfica restringida: extensión de presencia B1 y área
  de ocupación B2) y la ausencia del Criterio E (análisis cuantitativo
  poblacional) debido a la escasez de series temporales.

- \*\*Justificación\*\*: Argumentación biológica, demográfica y
  biogeográfica.

- \*\*Distribución geográfica y altitudinal\*\*: Localidades tipo,
  rangos de elevación y ecorregiones peruanas de presencia.

- \*\*Amenazas principales\*\*: Factores antropogénicos directos e
  indirectos, incluyendo agricultura/ganadería, deforestación, minería
  aurífera y metálica, contaminación por metales pesados,
  quitridiomicosis (\*Batrachochytrium dendrobatidis\*), caza para
  consumo, tráfico ilegal de mascotas y cambio climático.

- \*\*Conservación y vacíos en el SINANPE\*\*: Presencia en Áreas
  Naturales Protegidas nacionales (SINANPE), áreas de conservación
  regional (ACR) o privadas (ACP), evidenciando las brechas espaciales
  de protección (ej. 32% de anfibios fuera de ANPs).

- \*\*Autores\*\*: Nombres de los investigadores y taxónomos
  responsables de la ficha.

Composición por grupo taxonómico (381 fichas en total):

- Aves: 122 fichas (todas las especies en CR, EN y VU).

- Anfibios: 117 fichas.

- Mamíferos: 92 fichas (todas las especies en CR, EN y VU).

- Reptiles: 31 fichas.

- Invertebrados: 19 fichas.

## See also

[`get_ficha`](https://paulesantos.github.io/perufaunads004/reference/get_ficha.md),
[`ds004_fauna`](https://paulesantos.github.io/perufaunads004/reference/ds004_fauna.md),
[`libro_rojo_especies`](https://paulesantos.github.io/perufaunads004/reference/libro_rojo_especies.md)
