% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_modules.R
\name{add_module_dir}
\alias{add_module_dir}
\title{Create a module directory}
\usage{
add_module_dir(...)
}
\arguments{
\item{...}{Single character values to construct the path to your module directory
(see \code{fs::path}, but \code{ext} argument can and must be ignored).
The directory will be created underneath the main module directory created with \code{box.shiny::add_main_dir}.}
}
\description{
Create a module directory
}
