test_that("classify_spnames parses simple binomials correctly", {
  res <- classify_spnames("Tremarctos ornatus")
  expect_equal(res$submitted_name, "Tremarctos ornatus")
  expect_equal(res$clean_name, "Tremarctos ornatus")
  expect_equal(res$genus, "Tremarctos")
  expect_equal(res$species, "ornatus")
  expect_true(is.na(res$subspecies))
  expect_true(is.na(res$authorship))
})

test_that("classify_spnames extracts author and year", {
  res <- classify_spnames("Tremarctos ornatus (Cuvier, 1825)")
  expect_equal(res$genus, "Tremarctos")
  expect_equal(res$species, "ornatus")
  expect_equal(res$clean_name, "Tremarctos ornatus")
  expect_true(grepl("Cuvier", res$authorship))
})

test_that("classify_spnames handles trinomials / subspecies", {
  res <- classify_spnames("Lama guanicoe cacsilensis Lönnberg, 1913")
  expect_equal(res$genus, "Lama")
  expect_equal(res$species, "guanicoe")
  expect_equal(res$subspecies, "cacsilensis")
  expect_equal(res$clean_name, "Lama guanicoe cacsilensis")
})

test_that("classify_spnames works with data.frame input and tidy pipe", {
  df <- tibble::tibble(species_name = c("Vultur gryphus", "Telmatobius culeus"))
  res <- classify_spnames(df, species_col = "species_name")
  expect_equal(nrow(res), 2)
  expect_equal(res$genus, c("Vultur", "Telmatobius"))
})
