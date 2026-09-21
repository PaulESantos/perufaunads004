test_that("get_ficha retrieves technical sheets correctly", {
  fc <- get_ficha("Tremarctos ornatus")
  expect_true(nrow(fc) >= 1)
  expect_equal(fc$genus[1], "Tremarctos")
  expect_equal(fc$species[1], "ornatus")
  expect_true(grepl("Vulnerable|VU", fc$ficha_categoria[1]))
  expect_true(!is.na(fc$justificacion[1]))
  expect_true(!is.na(fc$amenazas[1]))
  expect_true(!is.na(fc$distribucion[1]))
})

test_that("get_ficha handles species without ficha gracefully", {
  expect_warning(fc <- get_ficha("Especie inexistente 123"))
  expect_equal(nrow(fc), 0)
})
