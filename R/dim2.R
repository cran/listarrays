#' Make or reshape an array with C-style (row-major) semantics
#'
#' These functions reshape or make an array using C-style, row-major semantics.
#' The returned array is still R's native F-style, (meaning, the underlying
#' vector has been reordered).
#'
#' Other than the C-style semantics, these functions behave identically to their
#' counterparts (`array2()` behaves identically to `array()`, \code{`dim2<-`()}
#' to \code{`dim<-`()}). `set_dim2()` is just a wrapper around `set_dim(...,
#' order = "C")`.
#'
#' See examples for a drop-in pure R replacement to `reticulate::array_reshape()`
#'
#' @param data what to fill the array with
#' @param dim numeric vector of dimensions
#' @param dimnames a list of dimnames, must be the same length as `dims`
#'
#' @export
#' @examples
#' array(1:4, c(2,2))
#' array2(1:4, c(2,2))
#'
#' # for a drop-in replacement to reticulate::array_reshape
#' array_reshape <- listarrays:::array_reshape
#' array_reshape(1:4, c(2,2))
array2 <- function(data, dim = length(data), dimnames = NULL) {
  pd <- prod(dim)
  if(length(data) != pd)
    data <- rep_len(data, pd)
  dim2(data) <- dim
  dimnames(data) <- dimnames
  data
}


#' @export
#' @rdname array2
matrix2 <- function(...)
  matrix(..., byrow = TRUE)

#' @export
#' @rdname array2
#' @param x object to set dimensions on (array or atomic vector)
#' @param value a numeric (integerish) vector of new dimensions
`dim2<-` <- function(x, value) {
  if (is.null(value)) {
    if (is.null(dim(x) -> dx))
      return(x)

    if(length(dx) > 1L)
      x <- t(x)

    dim(x) <- NULL

    return(x)
  }

  dim_x <- dim(x)
  if(identical(dim_x, as.integer(value)))
    return(x)

  if (!is.null(dim_x))
    x <- t(x)

  dim(x) <- rev(value)
  t(x)
}


#' @export
#' @rdname array2
#' @param ... passed on to `set_dim()`
set_dim2 <- function(...) {
  set_dim(..., order = "C")
}



# equivelant to reticulate::array_reshape(),
# but a pure R solution (and therefore usually faster)
array_reshape <- function(x, dim, order = c("C", "F")) {

  # rename to avoid possible recursive loop when calling dim()
  # arg is named `dim` for compatability with reticulate::array_reshape()
  new_dim <- dim; rm(dim)

  order <- match.arg(order)
  if (identical(order, "C"))
    dim2(x) <- new_dim
  else
    dim(x) <- new_dim

  # match reticulate behavior
  if(identical(storage.mode(x), "integer"))
    storage.mode(x) <- "double"

  x
}


#' transpose an array
#'
#' @param x an array
#'
#' This reverses the dimensions of an array
#'
#' #export
#' @noRd
#' @examples
#' x <- array(1:27, c(3,3,3))
#' tx <- t(x)
#' for (i in 1:3)
#'   for(j in 1:3)
#'     stopifnot(x[,j,i] == tx[i,j,])

# this is no longer exported because it is now invoked for 2d arrays (matrixes)
# too, and before dispatch to the primitive. This introduces substantial
# overhead in code that would otherwise not dispatch. Additionally, aperm() does
# not preserve attributes. This was discovered when utils::getParseData() was
# raising an error, because the expression `t(unclass(data))` was losing
# attributes(data) if listarrays was loaded.

# t.array <-
function(x) {
  if(is.matrix(x)) return(NextMethod()) # copies attrs already

  # handle bug in aperm(), R 4.3.2. aperm() docs say it copies over other attrs,
  # but in actuality, it doesn't.
  out <- aperm(x)
  attrs <- attributes(x)
  attrs$dim <- attrs$dimnames <- NULL
  attributes(out) <- a
  out
}
