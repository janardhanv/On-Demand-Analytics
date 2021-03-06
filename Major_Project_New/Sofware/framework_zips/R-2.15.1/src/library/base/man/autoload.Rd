% File src/library/base/man/autoload.Rd
% Part of the R package, http://www.R-project.org
% Copyright 1995-2007 R Core Team
% Distributed under GPL 2 or later

\name{autoload}
\title{On-demand Loading of Packages}
\usage{
autoload(name, package, reset = FALSE, \dots)
autoloader(name, package, \dots)

.AutoloadEnv
.Autoloaded
}
\alias{autoload}
\alias{autoloader}
\alias{.AutoloadEnv}
\alias{.Autoloaded}
\alias{Autoloads}
\arguments{
  \item{name}{string giving the name of an object.}
  \item{package}{string giving the name of a package containing the object.}
  \item{reset}{logical: for internal use by \code{autoloader}.}
  \item{\dots}{other arguments to \code{\link{library}}.}
}
\description{
  \code{autoload} creates a promise-to-evaluate \code{autoloader} and
  stores it with name \code{name} in \code{.AutoloadEnv} environment.
  When \R attempts to evaluate \code{name}, \code{autoloader} is run,
  the package is loaded and \code{name} is re-evaluated in the new
  package's environment.  The result is that \R behaves as if
  \code{file} was loaded but it does not occupy memory.

  \code{.Autoloaded} contains the names of the packages for
  which autoloading has been promised.
}
\value{
  This function is invoked for its side-effect.  It has no return value.
}
\seealso{
  \code{\link{delayedAssign}}, \code{\link{library}}
}
\examples{
require(stats)
autoload("interpSpline", "splines")
search()
ls("Autoloads")
.Autoloaded

x <- sort(stats::rnorm(12))
y <- x^2
is <- interpSpline(x,y)
search() ## now has splines
detach("package:splines")
search()
is2 <- interpSpline(x,y+x)
search() ## and again
detach("package:splines")
}
\keyword{data}
\keyword{programming}

