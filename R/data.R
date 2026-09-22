#' Lista de Fauna Silvestre Legalmente Protegida (DS 004-2014-MINAGRI)
#'
#' Dataset con las 535 especies de fauna silvestre de Perú categorizadas y
#' legalmente protegidas por el Estado peruano mediante el Decreto Supremo
#' N° 004-2014-MINAGRI, publicado en el diario oficial *El Peruano* el 8 de abril de 2014.
#'
#' @details
#' La actualización del D.S. N° 004-2014-MINAGRI representó un hito histórico
#' en la legislación ambiental peruana al sustituir el marco del D.S. N° 034-2004-AG.
#' Entre sus principales avances destacan:
#' \itemize{
#'   \item **Inclusión histórica de invertebrados terrestres**: Por primera vez en el Perú
#'     se reconoció formalmente a 21 especies de invertebrados (17 artrópodos, 1 molusco y
#'     3 onicóforos) dentro de una norma nacional de fauna amenazada.
#'   \item **Adopción estandarizada de categorías UICN**: Se emplean las categorías
#'     En Peligro Crítico (CR), En Peligro (EN), Vulnerable (VU), Casi Amenazado (NT)
#'     y Datos Insuficientes (DD).
#'   \item **Principio precautorio**: A diferencia de las listas globales donde NT y DD
#'     no son categorías de amenaza en sentido estricto, la normativa peruana las incluyó
#'     en el régimen de protección legal para salvaguardar taxones con vacíos de información
#'     o en umbrales de declive poblacional.
#'   \item **Composición taxonómica**: Comprende 190 aves, 146 anfibios, 124 mamíferos,
#'     54 reptiles y 21 invertebrados terrestres.
#' }
#'
#' @format Un tibble con 535 filas y 11 variables:
#' \describe{
#'   \item{ds004_id}{Identificador correlativo oficial en el DS 004 (1 a 535).}
#'   \item{ds004_categoria_codigo}{Código de categoría ordenado jerárquicamente (CR, EN, VU, NT, DD).}
#'   \item{ds004_categoria}{Descripción oficial completa de la categoría de amenaza.}
#'   \item{clase}{Clase o grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).}
#'   \item{genus}{Género taxonómico.}
#'   \item{species}{Epíteto específico.}
#'   \item{subspecies}{Subespecie (si aplica en la norma).}
#'   \item{scientific_name}{Nombre científico completo consignado en el decreto.}
#'   \item{common_name}{Nombre(s) común(es) oficial(es) registrado(s) en la norma.}
#'   \item{synonym_scientific_name}{Sinónimo(s) científico(s) anotado(s) en el texto legal.}
#'   \item{observacion}{Notas técnicas sobre subespecies, poblaciones o estatus taxonómico.}
#' }
#' @source Ministerio de Agricultura y Riego (MINAGRI, 2014). Decreto Supremo N° 004-2014-MINAGRI.
#' Diario Oficial El Peruano, 8 de abril de 2014.
#' @seealso \code{\link{libro_rojo_especies}}, \code{\link{libro_rojo_fichas}}, \code{\link{fauna_backbone}}
"ds004_fauna"

#' Especies de Fauna Silvestre del Libro Rojo (SERFOR, 2018)
#'
#' Lista de 528 especies de fauna silvestre amenazada analizadas técnicamente en el
#' *Libro Rojo de la Fauna Silvestre Amenazada del Perú* (SERFOR, 2018).
#'
#' @details
#' El Libro Rojo es el primer documento técnico y científico comprehensivo elaborado
#' en el Perú siguiendo formalmente los criterios y categorías de la Lista Roja de la
#' Unión Internacional para la Conservación de la Naturaleza (UICN, versión 3.1).
#'
#' Fue coordinado por la Dirección General de Gestión Sostenible del Patrimonio Forestal
#' y de Fauna Silvestre del Servicio Nacional Forestal y de Fauna Silvestre (SERFOR)
#' con la participación activa de más de 50 especialistas nacionales e internacionales
#' divididos en comités científicos temáticos:
#' \itemize{
#'   \item **Anfibios**: Coordinado por Alessandro Catenazzi y Rudolf von May.
#'   \item **Aves**: Coordinado por Fernando Angulo Pratolongo.
#'   \item **Mamíferos**: Coordinado por E. Daniel Cossios Meza.
#'   \item **Reptiles**: Coordinado por José Pérez Z.
#'   \item **Invertebrados terrestres**: Coordinado por José Antonio Ochoa y Diana Silva.
#' }
#'
#' De las 528 especies analizadas en el libro, 389 están en categorías de amenaza real
#' (64 CR, 122 EN, 203 VU), 103 en Casi Amenazado (NT) y 43 en Datos Insuficientes (DD).
#' Las especies en CR, EN y VU cuentan con fichas técnicas monográficas detalladas
#' compiladas en \code{\link{libro_rojo_fichas}}.
#'
#' @format Un tibble con 528 filas y 7 variables:
#' \describe{
#'   \item{libro_rojo_id}{Número correlativo en el catálogo del Libro Rojo.}
#'   \item{libro_rojo_categoria}{Nombre completo de la categoría de amenaza asignada.}
#'   \item{libro_rojo_codigo}{Código de categoría ordenado (CR, EN, VU, NT, DD).}
#'   \item{grupo_taxonomico}{Grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).}
#'   \item{scientific_name_raw}{Nombre científico original tal como fue impreso en el libro.}
#'   \item{sinonimo}{Sinónimos o combinaciones previas registradas.}
#'   \item{scientific_name}{Nombre científico validado y normalizado para matching computacional.}
#' }
#' @source SERFOR (2018). *Libro Rojo de la Fauna Silvestre Amenazada del Perú*.
#' Primera edición. Servicio Nacional Forestal y de Fauna Silvestre, Lima, Perú. 548 pp.
#' @seealso \code{\link{ds004_fauna}}, \code{\link{libro_rojo_fichas}}, \code{\link{fauna_backbone}}
"libro_rojo_especies"

#' Fichas Técnicas del Libro Rojo de Fauna Silvestre (SERFOR, 2018)
#'
#' Compendio de 381 fichas técnicas monográficas exhaustivas elaboradas por
#' especialistas e investigadores de campo para las especies en situación de amenaza
#' comprobada (categorías CR, EN y VU) según el Libro Rojo de SERFOR (2018).
#'
#' @details
#' Cada ficha técnica representa una síntesis exhaustiva de la evidencia empírica
#' disponible a la fecha de publicación, cubriendo:
#' \itemize{
#'   \item **Criterios UICN asignados**: Desglose cuantitativo del criterio o combinación
#'     de criterios (A, B, C, D) y subcriterios que justifican la categoría. En la fauna
#'     peruana destaca el predominio del Criterio B (distribución geográfica restringida:
#'     extensión de presencia B1 y área de ocupación B2) y la ausencia del Criterio E
#'     (análisis cuantitativo poblacional) debido a la escasez de series temporales.
#'   \item **Justificación**: Argumentación biológica, demográfica y biogeográfica.
#'   \item **Distribución geográfica y altitudinal**: Localidades tipo, rangos de elevación
#'     y ecorregiones peruanas de presencia.
#'   \item **Amenazas principales**: Factores antropogénicos directos e indirectos,
#'     incluyendo agricultura/ganadería, deforestación, minería aurífera y metálica,
#'     contaminación por metales pesados, quitridiomicosis (*Batrachochytrium dendrobatidis*),
#'     caza para consumo, tráfico ilegal de mascotas y cambio climático.
#'   \item **Conservación y vacíos en el SINANPE**: Presencia en Áreas Naturales Protegidas
#'     nacionales (SINANPE), áreas de conservación regional (ACR) o privadas (ACP),
#'     evidenciando las brechas espaciales de protección (ej. 32\% de anfibios fuera de ANPs).
#'   \item **Autores**: Nombres de los investigadores y taxónomos responsables de la ficha.
#' }
#'
#' Composición por grupo taxonómico (381 fichas en total):
#' \itemize{
#'   \item Aves: 122 fichas (todas las especies en CR, EN y VU).
#'   \item Anfibios: 117 fichas.
#'   \item Mamíferos: 92 fichas (todas las especies en CR, EN y VU).
#'   \item Reptiles: 31 fichas.
#'   \item Invertebrados: 19 fichas.
#' }
#'
#' @format Un tibble con 381 filas y 16 variables:
#' \describe{
#'   \item{genus}{Género taxonómico validado.}
#'   \item{species}{Epíteto específico.}
#'   \item{subespecie}{Subespecie (si aplica).}
#'   \item{species_autor}{Autoría y año de descripción taxonómica.}
#'   \item{class_name}{Clase taxonómica (Amphibia, Aves, Mammalia, Reptilia, Insecta, Arachnida, Diplopoda, Gastropoda, Onychophora).}
#'   \item{order_name}{Orden taxonómico.}
#'   \item{family_name}{Familia taxonómica.}
#'   \item{species_name}{Nombre científico binomial o trinomial completo con autoría.}
#'   \item{ficha_categoria}{Categoría de amenaza y código de criterios UICN asignados (ej. "CR / B1ab(iii)").}
#'   \item{ficha_grupo}{Grupo taxonómico (Anfibios, Aves, Invertebrados, Mamíferos, Reptiles).}
#'   \item{common_name}{Nombre común vernacular representativo.}
#'   \item{justificacion}{Texto íntegro de la justificación técnica de la categorización.}
#'   \item{distribucion}{Texto íntegro de la distribución geográfica y altitudinal conocida.}
#'   \item{amenazas}{Texto íntegro describiendo las presiones antropogénicas e impactos.}
#'   \item{conservacion}{Texto íntegro de las medidas de conservación y representatividad en ANPs.}
#'   \item{autores}{Especialistas e investigadores autores de la ficha técnica.}
#'   \item{canonical_name}{Nombre científico normalizado en formato binario/trinario para joins computacionales.}
#' }
#' @source SERFOR (2018). *Libro Rojo de la Fauna Silvestre Amenazada del Perú*.
#' Servicio Nacional Forestal y de Fauna Silvestre, Lima, Perú.
#' @seealso \code{\link{get_ficha}}, \code{\link{ds004_fauna}}, \code{\link{libro_rojo_especies}}
"libro_rojo_fichas"

#' Backbone Consolidado de Fauna Amenazada del Perú
#'
#' Base de datos taxonómica relacional unificada que integra el Decreto Supremo
#' N° 004-2014-MINAGRI y el Libro Rojo de la Fauna Silvestre Amenazada del Perú (SERFOR, 2018).
#'
#' @details
#' Este dataset constituye la columna vertebral (*backbone*) del motor de reconciliación
#' taxonómica `fauna_matching()`. Permite resolver discrepancias entre ambas listas oficiales:
#' \itemize{
#'   \item Homogeneización de sinonimias históricas (ej. *Oreonax flavicauda* a *Lagothrix flavicauda*).
#'   \item Corrección de exclusiones o precisiones geográficas (ej. el anfibio *Psychophrynella wettsteini*,
#'     cuyos registros en Perú se determinaron erróneos y fue excluido del Libro Rojo).
#'   \item Indexación cruzada de estatus legal (DS 004) vs estatus técnico (Libro Rojo)
#'     y disponibilidad de monografía técnica (`has_ficha`).
#' }
#'
#' @format Un tibble con 536 filas y 16 variables:
#' \describe{
#'   \item{scientific_name}{Nombre científico aceptado y normalizado.}
#'   \item{genus}{Género taxonómico.}
#'   \item{species}{Epíteto específico.}
#'   \item{subspecies}{Subespecie (si aplica).}
#'   \item{clase}{Clase o grupo faunístico.}
#'   \item{order_name}{Orden taxonómico.}
#'   \item{family_name}{Familia taxonómica.}
#'   \item{common_name}{Nombre común más representativo.}
#'   \item{synonyms}{Sinónimos históricos y alternativos consolidados.}
#'   \item{in_ds004}{Lógico (`TRUE`/`FALSE`) indicando presencia en el D.S. N° 004-2014-MINAGRI.}
#'   \item{ds004_code}{Código en D.S. 004 (CR, EN, VU, NT, DD).}
#'   \item{ds004_categoria}{Descripción completa de la categoría legal en D.S. 004.}
#'   \item{in_libro_rojo}{Lógico (`TRUE`/`FALSE`) indicando presencia en el Libro Rojo 2018.}
#'   \item{libro_rojo_code}{Código en Libro Rojo 2018 (CR, EN, VU, NT, DD).}
#'   \item{libro_rojo_categoria}{Descripción de categoría en Libro Rojo 2018.}
#'   \item{has_ficha}{Lógico (`TRUE`/`FALSE`) indicando si cuenta con ficha técnica monográfica.}
#' }
#' @source Compilado y unificado a partir de MINAGRI (2014) y SERFOR (2018).
#' @seealso \code{\link{fauna_matching}}, \code{\link{get_ficha}}, \code{\link{is_threatened}}
"fauna_backbone"
