# lseq.R

#' \code{lseq} output a sequence of logarithmically spaced numbers.
#'
#' \code{lseq} works like \code{seq} in that it returns a vector of numbers with \code{from} as the first element, \code{to} as the last elelemnt, and \code{length.out} as the length of the vector, but the values are logarithmically spaced.
#'
#' @param from first number in the sequence.
#' @param to last number in the sequence.
#' @param length.out length of the sequence, a positive integer > 1. Default is 10.
#' @return A numeric vector.
#' @seealso \code{\link{seq}}
#' @examples
#' lseq(0.1, 10, length.out = 20)   # 20 log-spaced values between 0.1 and 10
#' # plot a log-spaced grid
#' lim <- c(0.1, 10)
#' plot(1, 1, xlim=lim, ylim=lim, type="n", axes=FALSE, xlab="", ylab="")
#' x <- lseq(0.1, 10, length.out = 10)
#' abline(v = x, col="#3366FF66")
#' abline(h = x, col="#3366FF66")
#' @export
lseq <- function(from, to, length.out = 10) {
  x <- seq(log(from), log(to), length.out = length.out)
  return(exp(x))
}

# [END]
