#' Create a new 'ddl' object and statement.
#'
#' `create_table()` initializes a `ddl` object. `dll` objects create valid DDL statements
#'  and print it cleanly to the console.
#'
#' @param x A data frame.
#' @param table_name Specify the table name. Defaults to object name.
#' @param if_not_exists Whether to include an IF NOT EXISTS statement.
#'
#' @return An object of class 'ddl'.
#' @export
#'
#' @examples
#' create_table(mtcars)
create_table <- function(x, table_name = NULL, if_not_exists = TRUE) {
  stopifnot(
    "'x' must be a data frame" = inherits(x, "data.frame")
  )
  .ddl <- list()
  .ddl <- as_ddl(.ddl)
  if (is.null(table_name)) {
    table_name <- deparse(substitute(x))
  }
  .ddl[ddl_constraints()] <- NA
  .ddl$table_name <- table_name
  .ddl$if_not_exists <- if_not_exists
  .ddl$col_names <- names(x)
  .ddl$col_types <- sapply(x, class)
  .ddl$col_types <- gsub("factor|character", "text", .ddl$col_types)
  .ddl$add_insert <- FALSE
  .ddl$data <- x
  .ddl
}

#' If printed, include an 'INSERT INTO ... VALUES' statement
#'
#' @param .ddl An object of class 'ddl'
#'
#' @export
add_insert_statement <- function(.ddl) {
  stopifnot(
    "'.ddl' must be of object type 'ddl'" = is_ddl(.ddl)
  )
  modifyList(.ddl, list(add_insert = TRUE))
}

#' Create table scheme and insert values ddl statements.
#'
#' @param x A data frame.
#'
#' @return An object of class 'ddl'.
#' @export
#'
#' @examples
#' dputsql(mtcars)
dputsql <- function(x) {
  add_insert_statement(create_table(x))
}

