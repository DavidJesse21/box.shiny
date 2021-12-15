options("box.path" = fs::path_wd("app"))

# If in interactive/development mode run this:
box.shiny::detach_all_mods()
box.shiny::detach_all_pkgs()
rm(list = ls())

# Load app
box::use(
  run_app[run_app]
)

# Run app
run_app()
