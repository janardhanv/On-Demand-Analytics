#  File src/library/base/R/tabulate.R
#  Part of the R package, http://www.R-project.org
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/

tabulate <- function(bin, nbins = max(1L, bin, na.rm = TRUE))
{
    if(!is.numeric(bin) && !is.factor(bin))
	stop("'bin' must be numeric or a factor")
    ## avoid a copy for factors, since as.integer strips attributes
    if (typeof(bin) != "integer") bin <- as.integer(bin)
    nb <- as.integer(length(bin))
    if (is.na(nb)) stop("invalid value of length(bin)")
    nbins <- as.integer(nbins)
    if (is.na(nbins)) stop("invalid value of nbins")
    ## could remove once we have long vectors ....
    if (nbins > .Machine$integer.max)
        stop("attempt to make a table with >= 2^31 elements")
    ## DUP = FALSE avoids 'bin' being duplicated.
    .C("R_tabulate",
       bin, nb, nbins, ans = integer(nbins),
       NAOK = TRUE, PACKAGE = "base", DUP = FALSE)$ans
}
