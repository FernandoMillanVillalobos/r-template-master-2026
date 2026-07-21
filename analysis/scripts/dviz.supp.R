#' dviz.supp
#'
#' Supporting materials for Claus Wilke's data visualization book.
#' @name dviz.supp
#' @docType package
#' @import dplyr
#' @import cowplot
#' @import colorspace
#' @import colorblindr
#' @import extrafont
NULL


# *************************************************
#                     Setup 
# *************************************************

.onAttach <- function(libname, pkgname) {
  # switch the cowplot null device
  cowplot::set_null_device("png")
}

#' @noRd
#' @usage NULL
#' @export
dviz_font_family <- "IBM Plex Sans"

#' @noRd
#' @usage NULL
#' @export
dviz_font_family_bold <- "IBM Plex Sans Semibold"

#' @noRd
#' @usage NULL
#' @export
dviz_font_family_condensed <- "IBM Plex Sans Condensed"

#' @noRd
#' @usage NULL
#' @export
dviz_font_family_bold_condensed <- "IBM Plex Sans Condensed Semibold"
