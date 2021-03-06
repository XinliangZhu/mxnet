is.MXDataIter <- function(x) {
  inherits(x, "Rcpp_MXNativeDataIter") ||
  inherits(x, "Rcpp_MXArrayDataIter")
}

#' Judge if an object is mx.dataiter
#'
#' @return Logical indicator
#'
#' @export
is.mx.dataiter <- is.MXDataIter

#' Extract a certain field from DataIter.
#'
#' @export
mx.io.extract <- function(iter, field) {
  packer <- mx.nd.arraypacker()
  iter$reset()
  while (iter$iter.next()) {
    dlist <- iter$value()
    padded <- iter$num.pad()
    data <- dlist[[field]]
    oshape <- dim(data)
    packer$push(mx.nd.slice(data, 0, oshape[[1]] - padded))
  }
  iter$reset()
  return(packer$get())
}

#
#' Create MXDataIter compatible iterator from R's array
#'
#' @param data The data array.
#' @param label The label array.
#' @param batch.size The batch size used to pack the array.
#' @param shuffle Whether shuffle the data
#'
#' @export
mx.io.arrayiter <- function(data, label,
                            batch.size=128,
                            shuffle=FALSE) {
  if (shuffle) {
    unif.rnds <- as.array(mx.runif(c(length(label)), ctx=mx.cpu()));
  } else {
    unif.rnds <- as.array(0)
  }
  mx.io.internal.arrayiter(as.array(data),
                           as.array(label),
                           unif.rnds,
                           batch.size,
                           shuffle)
}
