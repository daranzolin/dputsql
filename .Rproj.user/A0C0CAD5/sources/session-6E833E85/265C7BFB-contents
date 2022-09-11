#' Apply constraints to a ddl object from create_table
#'
#' Apply constraints
#'
#' @param .ddl An object of type 'ddl'
#' @param v A vector or named list
#'
#' @return An object of type 'ddl'
#' @rdname constraints
#' @export
primary_key <- function(.ddl, v) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl),
    "'v' does not exist in table schema" = v %in% .ddl$col_names
    )
  modifyList(.ddl, list(`PRIMARY KEY` = v))
}

#' @rdname constraints
#' @export
not_null <- function(.ddl, v) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl),
    "'v' does not exist in table schema" = all(v %in% .ddl$col_names)
    )
  modifyList(.ddl, list(`NOT NULL` = v))
}

#' @rdname constraints
#' @export
default_vals <- function(.ddl, v) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl),
    "'v' must have names" = length(attr(v, "names")) > 0,
    "'v' must be a list" = is.list(v),
    "'v' does not exist in table schema" = all(names(v) %in% .ddl$col_names)
  )
  modifyList(.ddl, list(DEFAULT = v))
}

#' @rdname constraints
#' @export
unique_vals <- function(.ddl, v) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl),
    "'v' does not exist in table schema" = all(v %in% .ddl$col_names)
  )
  modifyList(.ddl, list(UNIQUE = v))
}

#' @rdname constraints
#' @export
check_vals <- function(.ddl, v) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl),
    "'v' must have names" = length(attr(v, "names")) > 0,
    "'v' must be a list" = is.list(v),
    "'v' does not exist in table schema" = all(names(v) %in% .ddl$col_names)
  )
  modifyList(.ddl, list(CHECK = v))
}
