# Introducción a perufaunads004

## 1. Presentación del Paquete

El paquete **`perufaunads004`** proporciona un conjunto integrado de
herramientas computacionales en R para la **validación taxonómica,
reconciliación nomenclatural y consulta del estado de conservación** de
las especies de fauna silvestre amenazada y legalmente protegida en el
Perú.

Integra de forma unificada los dos instrumentos rectores en la
materia: 1. **Decreto Supremo N° 004-2014-MINAGRI**: La norma jurídica
oficial que aprueba la lista de clasificación y categorización de las
especies amenazadas de fauna silvestre legalmente protegidas en el país
(535 taxones). 2. **Libro Rojo de la Fauna Silvestre Amenazada del Perú
(SERFOR, 2018)**: Publicación científica y técnica comprehensiva
elaborada por el Servicio Nacional Forestal y de Fauna Silvestre
(SERFOR) con comités de especialistas nacionales e internacionales,
evaluando 528 taxones y proporcionando **381 fichas técnicas
monográficas** con justificaciones, mapas de distribución, presiones
antrópicas y medidas de conservación.

``` r

library(perufaunads004)
library(dplyr)
```

------------------------------------------------------------------------

## 2. Flujo de Trabajo Típico en Estudios de Biodiversidad y Consultoría Ambiental

El paquete está diseñado para resolver las tareas cotidianas que
enfrentan biólogos, consultores ambientales (elaboración de EIA, DIA,
PMA), investigadores académicos y gestores del SINANPE (SERNANP).

### Paso 1: Parsing y Clasificación de Nombres (`classify_spnames`)

A menudo los inventarios de campo o bases de datos históricas contienen
nombres científicos con autorías, años, comillas o epítetos
subespecíficos.
[`classify_spnames()`](https://paulesantos.github.io/perufaunads004/reference/classify_spnames.md)
descompone y estandariza cada componente:

``` r

nombres_inventario <- c(
  "Tremarctos ornatus (F. Cuvier, 1825)",
  "Telmatobius culeus (Garman, 1876)",
  "Lama guanicoe cacsilensis Lönnberg, 1913",
  "Penelope albipennis Taczanowski 1878",
  "Tingomaria hydrophila"
)

clasificacion <- classify_spnames(nombres_inventario)
clasificacion |>
  select(submitted_name, genus, species, subspecies, authorship)
#> # A tibble: 5 × 5
#>   submitted_name                           genus   species subspecies authorship
#>   <chr>                                    <chr>   <chr>   <chr>      <chr>     
#> 1 Tremarctos ornatus (F. Cuvier, 1825)     Tremar… ornatus NA         (F. Cuvie…
#> 2 Telmatobius culeus (Garman, 1876)        Telmat… culeus  NA         (Garman, …
#> 3 Lama guanicoe cacsilensis Lönnberg, 1913 Lama    guanic… cacsilens… Lönnberg,…
#> 4 Penelope albipennis Taczanowski 1878     Penelo… albipe… NA         Taczanows…
#> 5 Tingomaria hydrophila                    Tingom… hydrop… NA         NA
```

------------------------------------------------------------------------

### Paso 2: Reconciliación y Matching Jerárquico (`fauna_matching`)

El núcleo del paquete es
[`fauna_matching()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md),
un motor relacional inspirado en la lógica de `wcvpmatch`. Realiza una
búsqueda por niveles: 1. **Exact match**: Coincidencia directa con el
nombre aceptado. 2. **Synonym match**: Resuelve sinónimos históricos o
reubicaciones taxonómicas (por ejemplo, *Oreonax flavicauda* se resuelve
a *Lagothrix flavicauda*). 3. **Fuzzy match**: Corrige errores
ortográficos y variantes tipográficas menores mediante distancia de
Levenshtein optimizada. 4. **Genus match**: Alerta si el taxón fue
consignado solo a nivel de género (ej. *Telmatobius sp.*) e informa
cuántas especies de dicho género están amenazadas.

``` r

lista_campo <- c(
  "Tremarctos ornatus",    # Exacto (Oso de anteojos - VU)
  "Oreonax flavicauda",    # Sinónimo de Lagothrix flavicauda (Mono choro de cola amarilla - CR)
  "Vultor gryphus",        # Error tipográfico por Vultur gryphus (Cóndor andino - EN)
  "Telmatobius culeus",    # Rana gigante del Titicaca (CR)
  "Sulcophanaeus actaeon", # Escarabajo pelotero (CR)
  "Panthera leo"           # Especie no listada en la fauna amenazada peruana
)

resultado_matching <- fauna_matching(lista_campo)

resultado_matching |>
  select(
    submitted_name,
    matched_name,
    match_type,
    ds004_code,
    libro_rojo_code,
    clase,
    common_name
  )
#> # A tibble: 6 × 7
#>   submitted_name        matched_name match_type ds004_code libro_rojo_code clase
#>   <chr>                 <chr>        <chr>      <chr>      <chr>           <chr>
#> 1 Tremarctos ornatus    Tremarctos … exact      VU         VU              Mamí…
#> 2 Oreonax flavicauda    Oreonax fla… exact      CR         NA              Mamí…
#> 3 Vultor gryphus        Vultur gryp… fuzzy      EN         EN              Aves 
#> 4 Telmatobius culeus    Telmatobius… exact      CR         CR              Anfi…
#> 5 Sulcophanaeus actaeon Sulcophanae… exact      CR         CR              Inve…
#> 6 Panthera leo          NA           no_match   NA         NA              NA   
#> # ℹ 1 more variable: common_name <chr>
```

------------------------------------------------------------------------

### Paso 3: Verificación Rápida de Amenaza (`is_threatened`)

Para flujos de filtrado rápido en tablas con miles de registros:

``` r

especies_prueba <- c("Tremarctos ornatus", "Panthera leo", "Penelope albipennis", "Columba livia")

is_threatened(especies_prueba)
#> [1]  TRUE FALSE  TRUE FALSE
```

------------------------------------------------------------------------

### Paso 4: Acceso a Monografías Oficiales del Libro Rojo (`get_ficha`)

Para las 381 especies en categorías de amenaza comprobada (**CR**,
**EN**, **VU**), el paquete incluye el texto completo de las fichas
técnicas redactadas por especialistas de campo:

``` r

# Consulta de la monografía de la Pava aliblanca (Penelope albipennis)
ficha_pava <- get_ficha("Penelope albipennis")

cat("Especie:", ficha_pava$species_name, "\n")
#> Especie: Penelope albipennis Taczanowski, 1878
cat("Categoría y Criterios UICN:", ficha_pava$ficha_categoria, "\n")
#> Categoría y Criterios UICN: CR / C2a, D
cat("Autores:", ficha_pava$autores, "\n\n")
#> Autores: V. R. Díaz, F. Angulo
cat("Distribución:\n", ficha_pava$distribucion, "\n\n")
#> Distribución:
#>  Endémica peruana. Entre los 5º 25’ S - 79º 55’ W al norte y los 6º 39’ 25” S - 79º 22’ 30” W al sur, dentro del bosque seco ecuatorial de la región tumbesina, en la vertiente occidental de la cadena principal de los Andes, en los departamentos de Piura, Lambayeque y Cajamarca. Altitudinalmente, se le encuentra principalmente entre los 300 y 1100 m, aunque ha sido reportada hasta los 1400 m.
cat("Principales Amenazas:\n", ficha_pava$amenazas, "\n")
#> Principales Amenazas:
#>  De acuerdo con el Plan Nacional para la Conservación de la Pava Aliblanca (Serfor, 2016), la problemática de la especie incluye caza y captura ilegal por parte de cazadores foráneos y comuneros, deforestación por actividades antrópicas y fragmentación de hábitat. La deforestación se produce por expansión de la frontera agrícola, mala práctica ganadera, tala del bosque natural para leña, carbón, o elaboración de artesanías, concesiones mineras, reducción de los ojos de agua o “jagueyes” debido a sobreexplotación agrícola. La fragmentación de hábitat proviene de la construcción de carreteras e incremento de tránsito vehicular, que generan barreras que afectan la dispersión y promueven el asentamiento de poblaciones humanas. Por otro lado, esta pava posee una serie de características biológicas que incrementan su sensibilidad frente a amenazas externas, como un ciclo que incluye una sola reproducción al año, monogamia y comportamiento territorial, nidada pequeña (uno a tres huevos o polluelos por pareja al año), madurez sexual tardía y una conducta evasiva y susceptible al estrés.
```

También es posible imprimir un reporte formateado directamente en la
consola de R mediante `get_ficha(..., print_details = TRUE)`.

------------------------------------------------------------------------

## 3. Datasets Incluidos en el Paquete

- **`ds004_fauna`**: Los 535 taxones protegidos bajo el D.S. N°
  004-2014-MINAGRI, con categorías legales, nombres comunes oficiales y
  notas normativas.
- **`libro_rojo_especies`**: Las 528 especies evaluadas en la
  publicación técnica del SERFOR (2018).
- **`libro_rojo_fichas`**: Compendio íntegro de 381 fichas técnicas
  monográficas elaboradas por especialistas con texto de justificación,
  distribución, amenazas y conservación.
- **`fauna_backbone`**: Base relacional unificada y optimizada para
  búsquedas y joins de alta velocidad.

------------------------------------------------------------------------

## 4. Guía de Viñetas del Paquete

Para profundizar en los aspectos biológicos, metodológicos y normativos,
consulte las viñetas especializadas:

1.  **[Fundamentos de Conservación, Criterios UICN y Marco Legal del
    Libro
    Rojo](https://paulesantos.github.io/perufaunads004/articles/fundamentos_y_criterios_uicn.md)**:
    Explica la evolución normativa en el Perú (1977 a 2018), los 5
    criterios de la UICN (A-E), el predominio del Criterio B en la fauna
    peruana, la ausencia del Criterio E por falta de datos
    cuantitativos, y la dinámica taxonómica.
2.  **[Diagnóstico por Grupos Taxonómicos, Ecorregiones y
    Amenazas](https://paulesantos.github.io/perufaunads004/articles/diagnostico_grupos_taxonomicos.md)**:
    Síntesis exhaustiva de la situación de Anfibios (crisis del hongo Bd
    y brechas en el SINANPE), Aves (endemismos críticos y bosques
    secos), Mamíferos (matriz de presiones agropecuarias y forestería),
    Reptiles (sesgos de muestreo por EIA y endemismo costero) e
    Invertebrados terrestres (primer hito de protección legal).
3.  **[Comparación de Listas de Fauna Amenazada del Perú (2014
    vs. 2018)](https://paulesantos.github.io/perufaunads004/articles/comparacion_fauna_2014_2018.md)**:
    Análisis relacional sistemático entre el D.S. N° 004-2014-MINAGRI y
    el Libro Rojo SERFOR (2018), detallando concordancias, especies
    retiradas, adiciones y matrices de transición de categorías.
