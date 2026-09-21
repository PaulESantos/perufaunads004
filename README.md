# perufaunads004

<!-- badges: start -->
<!-- badges: end -->

**perufaunads004** es un paquete de R diseñado para validar, reconciliar y consultar el estado de conservación de especies de **fauna silvestre amenazada y legalmente protegida en el Perú**. Integra de forma unificada:

1. El **Decreto Supremo N° 004-2014-MINAGRI** (lista oficial de categorización de especies amenazadas de fauna silvestre del Perú).
2. El **Libro Rojo de la Fauna Silvestre Amenazada del Perú** (SERFOR, 2018), incluyendo su listado integral y **381 fichas técnicas monográficas** con justificaciones, mapas/distribución, presiones antrópicas y medidas de conservación.

El motor de reconciliación taxonómica está inspirado en la lógica de [`wcvpmatch`](https://github.com/PaulESantos/wcvpmatch), permitiendo resolver listas provenientes de evaluaciones de campo, inventarios biológicos o consultorías ambientales mediante coincidencia exacta, resolución de sinónimos, matching difuso (*fuzzy*) y resolución a nivel de género.

---

## Instalación

Puedes cargar y probar el paquete localmente usando `devtools`:

```r
# Instalar dependencias si no las tienes:
install.packages(c("dplyr", "tibble", "stringdist", "stringr", "cli"))

# Cargar el paquete localmente:
devtools::load_all("perufaunads004")
```

---

## Flujo de Trabajo Principal

### 1. Clasificación y Parsing de Nombres (`classify_spnames`)
Descompone nombres en género, epíteto específico, subespecie y autoría taxonómica:

```r
library(perufaunads004)

nombres <- c(
  "Tremarctos ornatus (Cuvier, 1825)",
  "Telmatobius culeus",
  "Lama guanicoe cacsilensis",
  "Vultur gryphus Linnaeus 1758"
)

classify_spnames(nombres)
```

### 2. Reconciliación Taxonómica y Categoría de Conservación (`fauna_matching`)
Compara una lista de nombres de campo contra la base oficial peruana:

```r
lista_campo <- c(
  "Tremarctos ornatus",    # Exact match (Oso de anteojos - VU)
  "Oreonax flavicauda",    # Sinónimo de Lagothrix flavicauda (Mono choro de cola amarilla - CR)
  "Vultor gryphus",        # Typo para Vultur gryphus (Cóndor andino - EN)
  "Telmatobius sp.",       # Género con múltiples especies amenazadas
  "Panthera leo"           # Especie exótica (no amenazada en Perú)
)

resultado <- fauna_matching(lista_campo)
resultado |>
  dplyr::select(submitted_name, matched_name, match_type, ds004_code, libro_rojo_code, common_name)
```

### 3. Consulta de Fichas Técnicas (`get_ficha`)
Permite acceder a los textos monográficos oficiales del SERFOR (2018):

```r
# Obtener como tibble
ficha_oso <- get_ficha("Tremarctos ornatus")

# O imprimir en formato de consola enriquecido con 'cli':
get_ficha("Tremarctos ornatus", print_details = TRUE)
```

### 4. Verificación Rápida de Amenaza (`is_threatened`)

```r
is_threatened(c("Tremarctos ornatus", "Panthera leo"))
# [1]  TRUE FALSE
```

---

## Datasets Incluidos

- `ds004_fauna`: 535 especies categorizadas bajo DS 004-2014-MINAGRI.
- `libro_rojo_especies`: 528 especies listadas en el Libro Rojo (SERFOR, 2018).
- `libro_rojo_fichas`: 381 fichas técnicas con amenazas, distribución geográfica y justificación.
- `fauna_backbone`: Backbone integrado para reconciliación y matching de alta velocidad.
