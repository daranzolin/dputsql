#' Copy DDL statement to your clipboard or write to a new SQL file
#'
#' @param .ddl An object of type 'ddl'
#' @param path Path to target file.
#' @param quiet Whether to message about what is happening.
#'
#' @rdname use-ddl
#' @export
write_ddl_file <- function(.ddl, path, quiet = FALSE) {
  stopifnot(
    "'.ddl' must be a '.ddl' object" = is_ddl(.ddl)
  )
  ddl_text <- get_ddl_text(.ddl)
  usethis::write_over(path, ddl_text, quiet = quiet)
}

#' @rdname use-ddl
#' @export
ddl_to_clipboard <- function(.ddl) {
  clipr::write_clip(get_ddl_text(.ddl))
}

