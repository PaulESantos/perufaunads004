test_that("fauna_matching handles exact matches accurately", {
  res <- fauna_matching(c("Tremarctos ornatus", "Telmatobius culeus"))
  expect_equal(res$match_type, c("exact", "exact"))
  expect_equal(res$match_status, c("matched", "matched"))
  expect_equal(res$distance, c(0, 0))
  expect_equal(res$similarity, c(1, 1))
  expect_equal(res$clase, c("Mamíferos", "Anfibios"))
  expect_true(all(res$in_ds004))
  expect_true(all(res$has_technical_sheet))
})

test_that("fauna_matching resolves synonyms", {
  # Oreonax flavicauda vs Lagothrix flavicauda
  res <- fauna_matching("Oreonax flavicauda")
  expect_equal(res$match_status, "matched")
  expect_true(res$match_type %in% c("exact", "synonym"))
  expect_true(grepl("flavicauda", res$matched_name, ignore.case = TRUE))
})

test_that("fauna_matching performs fuzzy matching on typos", {
  # Typo in specific epithet or genus
  res <- fauna_matching("Tremarctus ornatus", max_distance = 1)
  expect_equal(res$matched_name, "Tremarctos ornatus")
  expect_equal(res$match_type, "fuzzy")
  expect_equal(res$match_status, "matched")
  expect_equal(res$distance, 1)
})

test_that("fauna_matching supports genus level matching", {
  res <- fauna_matching("Tremarctos sp.", genus_match = TRUE)
  expect_equal(res$match_type, "genus")
  expect_true(grepl("Tremarctos", res$matched_name))
})

test_that("fauna_matching flags non-threatened species as no_match", {
  res <- fauna_matching("Panthera leo")
  expect_equal(res$match_type, "no_match")
  expect_equal(res$match_status, "unmatched")
  expect_true(is.na(res$matched_name))
  expect_false(res$in_ds004)
})

test_that("is_threatened correctly identifies threatened status", {
  threats <- is_threatened(c("Tremarctos ornatus", "Panthera leo"))
  expect_equal(threats, c(TRUE, FALSE))
})
