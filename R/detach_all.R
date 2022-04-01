#' Detach all loaded modules
#' @export
detach_all_mods = function() {
  loaded_modules = search()[startsWith(search(), "mod:")]
  invisible(lapply(
    loaded_modules, detach, character.only = TRUE
  ))
}


#' Detach all loaded packages
#' @export
detach_all_pkgs = function() {
  loaded_pkgs = names(utils::sessionInfo()$otherPkgs)
  if (!is.null(loaded_pkgs)) {
    invisible(lapply(
      paste0("package:", loaded_pkgs), detach, character.only = TRUE
    ))
  }
}

