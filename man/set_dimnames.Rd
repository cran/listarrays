% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dimnames.R
\name{set_dimnames}
\alias{set_dimnames}
\title{Set dimnames}
\usage{
set_dimnames(x, nm, which_dim = NULL)
}
\arguments{
\item{x}{an array}

\item{nm}{A list or character vector.}

\item{which_dim}{a character vector or numeric vector or \code{NULL}}
}
\value{
x, with modified dimnames and or axisnames
}
\description{
A more flexible and pipe-friendly version of \verb{dimnames<-}.
}
\details{
This function is quite flexible. See examples for the complete
picture.
}
\note{
The word "dimnames" is slightly overloaded. Most commonly it refers to
the names of entries along a particular axis (e.g., date1, date2, date3,
...), but occasionally it is also used to refer to the names of the array
axes themselves (e.g, dates, temperature, pressure, ...). To disambiguate,
in the examples 'dimnames' always refers to the first case, while 'axis
names' refers to the second. \code{set_dimnames()} can be used to set either or both
axis names and dimnames.
}
\examples{
x <- array(1:8, 2:4)

# to set axis names, leave which_dim=NULL and pass a character vector
dimnames(set_dimnames(x, c("a", "b", "c")))

# to set names along a single axis, specify which_dim
dimnames(set_dimnames(x, c("a", "b", "c"), 2))

# to set an axis name and names along the axis, pass a named list
dimnames(set_dimnames(x, list(axis2 = c("a", "b", "c")), 2))
dimnames(set_dimnames(x, list(axis2 = c("a", "b", "c"),
                              axis3 = 1:4), which_dim = 2:3))

# if the array already has axis names, those are used when possible
nx <- set_dimnames(x, paste0("axis", 1:3))
dimnames(nx)
dimnames(set_dimnames(nx, list(axis2 = c("x", "y", "z"))))
dimnames(set_dimnames(nx, c("x", "y", "z"), which_dim = "axis2"))


# pass NULL to drop all dimnames, or just names along a single dimension
nx2 <- set_dimnames(nx, c("x", "y", "z"), which_dim = "axis2")
nx2 <- set_dimnames(nx2, LETTERS[1:4], which_dim = "axis3")
dimnames(nx2)
dimnames(set_dimnames(nx2, NULL))
dimnames(set_dimnames(nx2, NULL, 2))
dimnames(set_dimnames(nx2, NULL, c(2, 3)))
# to preserve an axis name and only drop the dimnames, wrap the NULL in a list()
dimnames(set_dimnames(nx2, list(NULL)))
dimnames(set_dimnames(nx2, list(NULL), 2))
dimnames(set_dimnames(nx2, list(axis2 = NULL)))
dimnames(set_dimnames(nx2, list(axis2 = NULL, axis3 = NULL)))
dimnames(set_dimnames(nx2, list(NULL), 2:3))
}
