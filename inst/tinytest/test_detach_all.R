# Test `detach_all_mods()` function ----

# Load some modules via `box`
box::use(
  utils[head, tail],
  magrittr[`%>%`],
  data.table[setDT]
)

# Now they should be attached and ready to use
expect_true(
  any(startsWith(search(), "mod:"))
)
expect_equal(1:3 %>% mean(), 2)
# Detach them
box.shiny::detach_all_mods()
# Now we should not find any of the modules/functions and cannot use them
expect_false(
  any(startsWith(search(), "mod:"))
)
expect_error(1:3 %>% mean())


# Test `detach_all_pkgs` ---
library(tibble)
# Just some placeholder test to show that one can use `tibble()` now
expect_equivalent(
  tibble(a = 1:3, b = letters[1:3]),
  data.frame(a = 1:3, b = letters[1:3])
)
# Now detach all packages
box.shiny::detach_all_pkgs()
# We should not be able to use the `tibble()` function anymore
expect_error(tibble(a = 1:3, b = letters[1:3]))

