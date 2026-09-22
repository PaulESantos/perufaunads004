# Obtener fichas técnicas del Libro Rojo de la Fauna Silvestre Amenazada

Recupera la información monográfica detallada de las especies amenazadas
que cuentan con ficha técnica en el Libro Rojo de la Fauna Silvestre
Amenazada del Perú (SERFOR, 2018), incluyendo justificación de
categorización, distribución geográfica, principales amenazas, estado de
conservación y autores.

## Usage

``` r
get_ficha(species, print_details = FALSE)
```

## Arguments

- species:

  Vector de caracteres con uno o más nombres científicos de especies.

- print_details:

  Lógico. Si es `TRUE`, imprime la ficha formateada en consola
  utilizando `cli`. Por defecto es `FALSE`.

## Value

Un [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) con
los campos de la ficha técnica:

- species_name:

  Nombre científico completo con autoría original.

- canonical_name:

  Nombre binomial o trinomial normalizado.

- common_name:

  Nombres comunes.

- class_name:

  Clase taxonómica.

- order_name:

  Orden taxonómico.

- family_name:

  Familia taxonómica.

- ficha_categoria:

  Categoría y criterios UICN asignados.

- justificacion:

  Justificación técnica del estado de amenaza.

- distribucion:

  Distribución geográfica, altitudinal y localidades.

- amenazas:

  Principales presiones antrópicas y ambientales.

- conservacion:

  Presencia en Áreas Naturales Protegidas y medidas.

- autores:

  Especialistas autores de la ficha.

## Examples

``` r
# \donttest{
# Recuperar ficha del oso de anteojos
fc <- get_ficha("Tremarctos ornatus")

# Imprimir en formato amigable en consola
get_ficha("Tremarctos ornatus", print_details = TRUE)
#> ── FICHA TÉCNICA • Tremarctos ornatus ──────────────────────────────────────────
#> • Especie: Tremarctos ornatus Cuvier, 1825
#> • Nombre común: Oso de anteojos, oso andino, oso vaquero, oso achupallero, oso
#>   negro, oso bestiero, ucumari
#> • Categoría Libro Rojo: [VU] VU / A4cd
#> • Jerarquía taxonómica: Mamíferos (Clase Mammalia) → Carnivora → Ursidae
#> 
#> ℹ Justificación Técnica de la Categorización
#> Se estima que, en un rango de tiempo de 30 años, incluyendo el antes y después
#> del presente, se perderá un porcentaje del hábitat del oso andino equivalente a
#> más del 30 % si las condiciones actuales de degradación continúan.
#> 
#> ℹ Distribución Geográfica y Localidades
#> Actualmente, el oso andino está distribuido a lo largo de la cordillera de los
#> Andes, en Venezuela, Colombia, Ecuador, Perú y Bolivia. Asimismo, existen
#> reportes de su presencia al sudeste de Panamá (Goldstein et al., 2008) y al
#> norte de Argentina (Del Moral y Bracho, 2009). En el Perú se encuentra
#> distribuido en las tres cadenas de los Andes. Su presencia en cada una de ellas
#> es dependiente de la latitud. Se distribuye desde aproximadamente los 4° S, en
#> la cordillera del Cóndor; Condorcanqui, departamento de Amazonas, hasta los
#> 14.4° S; en Sandia, departamento de Puno, y se le ha registrado entre los 210 y
#> los 4750 m de altitud (Peyton, 1980, 1999). Esta especie vive en una gran
#> variedad de ambientes y altitudes, habiéndosele registrado en los departamentos
#> de Piura, Cajamarca, Amazonas, San Martín, Lambayeque, La Libertad, Áncash,
#> Huánuco, Ucayali, Cerro de Pasco, Junín, Huancavelica, Ayacucho, Cusco,
#> Apurímac, Madre de Dios y Puno.
#> 
#> ✖ Principales Amenazas y Presiones Antrópicas
#> La pérdida y deterioro de hábitat es la principal causa de la disminución de
#> las poblaciones de oso andino. Las actividades agropecuarias en las áreas
#> silvestres se han incrementado notablemente en los últimos 40 años a causa de
#> la colonización. Asimismo, el incremento de vías de acceso ha facilitado la
#> expansión de la frontera agropecuaria, y la explotación selectiva de árboles
#> como Podocarpus y Cedrella, presentes en el hábitat del oso. Por otro lado, en
#> las últimas dos décadas se han incrementado los proyectos de minería,
#> hidrocarburos e infraestructura vial en áreas silvestres (Young y León, 1999;
#> Amanzo, 2007) ocasionando los mismos problemas. La fragmentación de hábitat ha
#> ocasionado la separación de poblaciones antes unidas y la potencial reducción o
#> eliminación del intercambio genético entre estas, especialmente en los sectores
#> centro y norte de su distribución (Amanzo, 2008). Las actividades ganaderas
#> causan el deterioro de los bosques andinos, páramo y puna. Para el caso de los
#> bosques, se reduce la oferta de alimento en el estrato inferior debido al
#> pisoteo y consumo por parte del ganado y, en otros casos, estos son quemados
#> para crear pastizales. El páramo y puna, al ser quemados para proveer de brotes
#> nuevos al ganado, ven reducida la oferta alimenticia de bromelias y ericáceas
#> que conforman parte importante de la dieta del oso (Peyton, 1999; Amanzo, 2008;
#> Figueroa y Stucchi, 2009). En el desierto costero y bosque seco, la expansión
#> agropecuaria, la extracción forestal y la urbanización son las más importantes
#> causas del deterioro de hábitat. La cacería es también una amenaza importante
#> para el oso andino. No es rara la caza de osos por considerárseles dañinos para
#> el ganado y los cultivos (Figueroa y Stucchi, 2005; Peyton, 1980). En muchos
#> casos, la cacería tiene como objetivo principal o secundario la venta de partes
#> de oso para ser usadas en medicina tradicional y chamanería (Figueroa, 2008:
#> Peyton, 1998). Algunas comunidades consumen la carne, vísceras y patas de oso,
#> sin embargo, este hecho está relacionado con la eventualidad de cazarlo y no
#> por motivación directa. Comúnmente, las crías son atrapadas después de la
#> cacería de la madre. En algunos casos, estas son mantenidas como mascotas por
#> los mismos cazadores o son vendidas a circos, coleccionistas particulares y
#> zoológicos (Figueroa y Stucchi, 2005). Con base en las tendencias de densidad
#> poblacional humana y sus demandas sobre los hábitats naturales y sus especies,
#> Cardillo et al., (2004) han incluido al oso andino entre los carnívoros con
#> mayor probabilidad de extinción. Hacia el 2030, se predice que esta especie
#> podría ingresar a la categoría de En Peligro de la IUCN (Goldstein et al.,
#> 2008).
#> 
#> ✔ Medidas de Conservación y Representatividad en el SINANPE
#> El oso andino se encuentra protegido por la legislación peruana con la
#> prohibición de la cacería, captura y comercialización. Sin embargo, la
#> capacidad de control del Estado en las áreas silvestres o contiguas a estas es
#> muy poca (Peyton, 1999; Amanzo, 2008). El convenio internacional Cites lo
#> incluye en el apéndice I, protegiéndolo de la comercialización dentro los
#> países miembros. El hábitat del oso andino se encuentra protegido en 30 áreas
#> naturales por el Estado peruano. El área protegida legalmente incluiría cerca
#> del 30 % de hábitat disponible para el oso (Secada et al., 2008), sin embargo,
#> se requiere incrementar el tamaño y conectividad de las áreas protegidas más
#> pequeñas y aisladas para permitir la conservación a largo plazo de la especie
#> (Peyton et al., 1998; Peyton, 1999; Amanzo, 2008; Secada et al., 2008).
#> Numerosas instituciones, gubernamentales y no gubernamentales, realizan
#> acciones directamente orientadas a la conservación del oso andino en el Perú,
#> incluyendo investigación, educación ambiental, protección de hábitat, apoyo al
#> financiamiento y gestión para la conservación.
#> 
#> ℹ Especialistas autores: J. Amanzo y D. Cossíos
#> ───────── SERFOR (2018) • Libro Rojo de la Fauna Silvestre Amenazada del Perú ──
#> # A tibble: 1 × 17
#>   genus      species subespecie species_autor class_name order_name family_name
#>   <chr>      <chr>   <chr>      <chr>         <chr>      <chr>      <chr>      
#> 1 Tremarctos ornatus NA         Cuvier, 1825  Mammalia   Carnivora  Ursidae    
#> # ℹ 10 more variables: species_name <chr>, ficha_categoria <chr>,
#> #   ficha_grupo <chr>, common_name <chr>, justificacion <chr>,
#> #   distribucion <chr>, amenazas <chr>, conservacion <chr>, autores <chr>,
#> #   canonical_name <chr>
# }
```
