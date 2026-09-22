# Especies de Fauna Silvestre del Libro Rojo (SERFOR, 2018)

Lista de 528 especies de fauna silvestre amenazada analizadas
técnicamente en el \*Libro Rojo de la Fauna Silvestre Amenazada del
Perú\* (SERFOR, 2018).

## Usage

``` r
libro_rojo_especies
```

## Format

Un tibble con 528 filas y 7 variables:

- libro_rojo_id:

  Número correlativo en el catálogo del Libro Rojo.

- libro_rojo_categoria:

  Nombre completo de la categoría de amenaza asignada.

- libro_rojo_codigo:

  Código de categoría ordenado (CR, EN, VU, NT, DD).

- grupo_taxonomico:

  Grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).

- scientific_name_raw:

  Nombre científico original tal como fue impreso en el libro.

- sinonimo:

  Sinónimos o combinaciones previas registradas.

- scientific_name:

  Nombre científico validado y normalizado para matching computacional.

## Source

SERFOR (2018). \*Libro Rojo de la Fauna Silvestre Amenazada del Perú\*.
Primera edición. Servicio Nacional Forestal y de Fauna Silvestre, Lima,
Perú. 548 pp.

## Details

El Libro Rojo es el primer documento técnico y científico comprehensivo
elaborado en el Perú siguiendo formalmente los criterios y categorías de
la Lista Roja de la Unión Internacional para la Conservación de la
Naturaleza (UICN, versión 3.1).

Fue coordinado por la Dirección General de Gestión Sostenible del
Patrimonio Forestal y de Fauna Silvestre del Servicio Nacional Forestal
y de Fauna Silvestre (SERFOR) con la participación activa de más de 50
especialistas nacionales e internacionales divididos en comités
científicos temáticos:

- \*\*Anfibios\*\*: Coordinado por Alessandro Catenazzi y Rudolf von
  May.

- \*\*Aves\*\*: Coordinado por Fernando Angulo Pratolongo.

- \*\*Mamíferos\*\*: Coordinado por E. Daniel Cossios Meza.

- \*\*Reptiles\*\*: Coordinado por José Pérez Z.

- \*\*Invertebrados terrestres\*\*: Coordinado por José Antonio Ochoa y
  Diana Silva.

De las 528 especies analizadas en el libro, 389 están en categorías de
amenaza real (64 CR, 122 EN, 203 VU), 103 en Casi Amenazado (NT) y 43 en
Datos Insuficientes (DD). Las especies en CR, EN y VU cuentan con fichas
técnicas monográficas detalladas compiladas en
[`libro_rojo_fichas`](https://paulesantos.github.io/perufaunads004/reference/libro_rojo_fichas.md).

## See also

[`ds004_fauna`](https://paulesantos.github.io/perufaunads004/reference/ds004_fauna.md),
[`libro_rojo_fichas`](https://paulesantos.github.io/perufaunads004/reference/libro_rojo_fichas.md),
[`fauna_backbone`](https://paulesantos.github.io/perufaunads004/reference/fauna_backbone.md)
