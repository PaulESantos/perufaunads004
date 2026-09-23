# perufaunads004 0.1.0

* **Alineación con el ecosistema `perufauna` (Tidyverse Style):**
  * Se incorporaron alias canónicos con prefijo de dominio `ds004_*`:
    * `ds004_match()`: alias canónico de `fauna_matching()`.
    * `ds004_is_threatened()`: alias canónico de `is_threatened()`.
    * `ds004_get_ficha()`: alias canónico de `get_ficha()`.
    * `ds004_classify_spnames()`: clasificador canónico de fauna amenazada.
    * `ds004_classify_names()`: alias canónico de clasificación de nombres.
  * **Resolución de colisiones de namespace:** Se retiró la exportación de `classify_spnames()` del `NAMESPACE` público (manteniéndola internamente para llamadas de `fauna_matching()`), canalizando su uso a través de `ds004_classify_spnames()` para erradicar la colisión con `citesperu` al cargar `perufauna`.
  * Se mantiene el 100% de compatibilidad hacia atrás para `fauna_matching()`, `is_threatened()` y `get_ficha()`.
