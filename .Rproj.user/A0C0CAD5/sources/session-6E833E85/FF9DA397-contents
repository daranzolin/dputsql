as_ddl <- function(x) {
  UseMethod("as_ddl")
}

#' @export
as_ddl.default <- function(x) x

#' @export
as_ddl.list <- function(x) {
  structure(x, class = c("ddl", "list"))
}

ddl_constraints <- function() {
  c(
    "PRIMARY KEY",
    "FOREIGN KEY",
    "NOT NULL",
    "UNIQUE",
    "CHECK",
    "DEFAULT"
    )
}

ddl_constraints1 <- function() {
  c(
    "PRIMARY KEY",
    "FOREIGN KEY",
    "NOT NULL",
    "UNIQUE"
  )
}

ddl_constraints2 <- function() {
  c(
    "CHECK",
    "DEFAULT"
  )
}

is_ddl <- function(x) inherits(x, "ddl")

#' @export
print.ddl <- function(x, ...) {
  ddl_txt <- get_ddl_text(x)
  cat(ddl_txt, ...)
  invisible(x)
}

get_ddl_text <- function(x) {
  h <- glue::glue("CREATE TABLE {ifelse(x[['if_not_exists']], 'IF NOT EXISTS', '')} {x$table_name}")
  def_cols <- c()
  cn <- x$col_names
  ct <- x$col_types
  data <- lapply(x$data, function(x) {
    if (is.character(x)) {
      x <- paste0("'", x, "'")
      x <- gsub("[A-Za-z]'([A-Za-z])", "''\\1", x)
    }
    x
  })
  data <- as.data.frame(data)
  # Hoist PK
  if (!is.na(x[["PRIMARY KEY"]])) {
    cn <- c(x[["PRIMARY KEY"]], cn[cn != x[["PRIMARY KEY"]]])
    ct <- ct[order(match(names(ct),cn))]
    data <- data[cn]
  }
  for (i in seq_along(cn)) {
    col <- cn[i]
    constraints1 <- paste(names(which(vapply(x[ddl_constraints1()], function(x) col %in% x, TRUE))), collapse = " ")
    constraints2 <- ifelse(col %in% names(x$CHECK), glue::glue("CHECK({x$CHECK[[col]]})"), "")
    constraints3 <- ifelse(col %in% names(x$DEFAULT), glue::glue("DEFAULT {x$DEFAULT[[col]]}"), "")
    constraints <- paste(constraints1, constraints2, constraints3, collapse = "")
    def_cols[i] <- gsub(" {1,3}$", "", glue::glue("\t{col} {ct[i]} {constraints}"))
  }
  def_cols <- paste(def_cols, collapse = ",\n")
  create_statement <- glue::glue("{h} (\n{def_cols}\n);")
  if (!x$add_insert) {
    return(create_statement)
  }
  i <- glue::glue("INSERT INTO {x$table_name} (`{paste(cn, collapse = '`, `')}`) VALUES")
  r <- split(data, seq_along(1:nrow(data)))
  rc <- lapply(r, function(x) paste0("\t(", paste(x, collapse = ","), ")"))
  rc <- glue::glue_collapse(rc, ",\n")
  rc <- paste0(rc, ";")
  out <- glue::glue_collapse(c(create_statement, "", i, rc), sep = "\n")
  return(out)
}


