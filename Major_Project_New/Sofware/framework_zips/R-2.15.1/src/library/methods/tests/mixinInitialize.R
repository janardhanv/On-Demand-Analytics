setClass("A", representation(a="numeric"))

a1 <- new("A", a=1.5)
m1 <- as.matrix(1)

setClass("M", contains = "matrix", representation(fuzz = "numeric"))

set.seed(113)
f1 <- runif(3)

stopifnot(identical(as(new("M", 1:12, nrow = 3, fuzz = f1), "matrix"),
		    matrix(1:12, nrow=3)),
	  identical(as(new("M", 1:12, 3, fuzz = f1), "matrix"),
		    matrix(1:12, 3)),
	  identical(as(new("M", 1:12, ncol = 3, fuzz = f1), "matrix"),
		    matrix(1:12, ncol=3)))

setClass("B", contains = c("matrix", "A"))

stopifnot(## a new "B" element mixing two superclass objects
	  identical(new("B", m1, a1)@a, a1@a),
	  ## or not
	  identical(as(new("B", m1),"matrix"), m1),
	  ## or supplying a slot to override
	  identical(new("B", matrix(m1, nrow = 2), a1, a=pi)@a, pi))

## an extra level of inheritance
setClass("C", contains = "B", representation(c = "character"))
new("C", m1, c = "Testing")

## verify that validity tests work (PR#14284)
setValidity("B", function(object) {
    if(all(is.na(object@a) | (object@a > 0)))
      TRUE
    else
      "elements of slot \"a\" must be positive"
})

a2 <- new("A", a= c(NA,3, -1, 2))

## from the SoDA package on CRAN
muststop <- function(expr, silent = TRUE) {
    tryExpr <- substitute(tryCatch(expr, error=function(cond)cond))
    value <- eval.parent(tryExpr)
    if(inherits(value, "error")) {
        if(!silent)
          message("muststop reports: ", value)
        invisible(value)
    }
    else
      stop(gettextf("The expression  %s should have thrown an error, but instead returned an object of class \"%s\"",
           deparse(substitute(expr))[[1]], class(value)))
}

muststop(new("B", m1, a2))

removeClass("B")
removeClass("C")
removeClass("M")

## TODO:  make versions of above inheriting from "array" and "ts"

removeClass("A")


