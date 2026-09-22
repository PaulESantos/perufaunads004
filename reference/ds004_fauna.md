# Lista de Fauna Silvestre Legalmente Protegida (DS 004-2014-MINAGRI)

Dataset con las 535 especies de fauna silvestre de Perú categorizadas y
legalmente protegidas por el Estado peruano mediante el Decreto Supremo
N° 004-2014-MINAGRI, publicado en el diario oficial \*El Peruano\* el 8
de abril de 2014.

## Usage

``` r
ds004_fauna
```

## Format

Un tibble con 535 filas y 11 variables:

- ds004_id:

  Identificador correlativo oficial en el DS 004 (1 a 535).

- ds004_categoria_codigo:

  Código de categoría ordenado jerárquicamente (CR, EN, VU, NT, DD).

- ds004_categoria:

  Descripción oficial completa de la categoría de amenaza.

- clase:

  Clase o grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos,
  Reptiles).

- genus:

  Género taxonómico.

- species:

  Epíteto específico.

- subspecies:

  Subespecie (si aplica en la norma).

- scientific_name:

  Nombre científico completo consignado en el decreto.

- common_name:

  Nombre(s) común(es) oficial(es) registrado(s) en la norma.

- synonym_scientific_name:

  Sinónimo(s) científico(s) anotado(s) en el texto legal.

- observacion:

  Notas técnicas sobre subespecies, poblaciones o estatus taxonómico.

## Source

Ministerio de Agricultura y Riego (MINAGRI, 2014). Decreto Supremo N°
004-2014-MINAGRI. Diario Oficial El Peruano, 8 de abril de 2014.

## Details

La actualización del D.S. N° 004-2014-MINAGRI representó un hito
histórico en la legislación ambiental peruana al sustituir el marco del
D.S. N° 034-2004-AG. Entre sus principales avances destacan:

- \*\*Inclusión histórica de invertebrados terrestres\*\*: Por primera
  vez en el Perú se reconoció formalmente a 21 especies de invertebrados
  (17 artrópodos, 1 molusco y 3 onicóforos) dentro de una norma nacional
  de fauna amenazada.

- \*\*Adopción estandarizada de categorías UICN\*\*: Se emplean las
  categorías En Peligro Crítico (CR), En Peligro (EN), Vulnerable (VU),
  Casi Amenazado (NT) y Datos Insuficientes (DD).

- \*\*Principio precautorio\*\*: A diferencia de las listas globales
  donde NT y DD no son categorías de amenaza en sentido estricto, la
  normativa peruana las incluyó en el régimen de protección legal para
  salvaguardar taxones con vacíos de información o en umbrales de
  declive poblacional.

- \*\*Composición taxonómica\*\*: Comprende 190 aves, 146 anfibios, 124
  mamíferos, 54 reptiles y 21 invertebrados terrestres.

## See also

[`libro_rojo_especies`](https://paulesantos.github.io/perufaunads004/reference/libro_rojo_especies.md),
[`libro_rojo_fichas`](https://paulesantos.github.io/perufaunads004/reference/libro_rojo_fichas.md),
[`fauna_backbone`](https://paulesantos.github.io/perufaunads004/reference/fauna_backbone.md)
