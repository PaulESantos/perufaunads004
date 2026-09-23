# Changelog

## perufaunads004 0.1.0

- **Alineación con el ecosistema `perufauna` (Tidyverse Style):**
  - Se incorporaron alias canónicos con prefijo de dominio `ds004_*`:
    - [`ds004_match()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md):
      alias canónico de
      [`fauna_matching()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md).
    - [`ds004_is_threatened()`](https://paulesantos.github.io/perufaunads004/reference/is_threatened.md):
      alias canónico de
      [`is_threatened()`](https://paulesantos.github.io/perufaunads004/reference/is_threatened.md).
    - [`ds004_get_ficha()`](https://paulesantos.github.io/perufaunads004/reference/get_ficha.md):
      alias canónico de
      [`get_ficha()`](https://paulesantos.github.io/perufaunads004/reference/get_ficha.md).
    - [`ds004_classify_spnames()`](https://paulesantos.github.io/perufaunads004/reference/ds004_classify_spnames.md):
      clasificador canónico de fauna amenazada.
    - [`ds004_classify_names()`](https://paulesantos.github.io/perufaunads004/reference/ds004_classify_spnames.md):
      alias canónico de clasificación de nombres.
  - **Resolución de colisiones de namespace:** Se retiró la exportación
    de `classify_spnames()` del `NAMESPACE` público (manteniéndola
    internamente para llamadas de
    [`fauna_matching()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md)),
    canalizando su uso a través de
    [`ds004_classify_spnames()`](https://paulesantos.github.io/perufaunads004/reference/ds004_classify_spnames.md)
    para erradicar la colisión con `citesperu` al cargar `perufauna`.
  - Se mantiene el 100% de compatibilidad hacia atrás para
    [`fauna_matching()`](https://paulesantos.github.io/perufaunads004/reference/fauna_matching.md),
    [`is_threatened()`](https://paulesantos.github.io/perufaunads004/reference/is_threatened.md)
    y
    [`get_ficha()`](https://paulesantos.github.io/perufaunads004/reference/get_ficha.md).
