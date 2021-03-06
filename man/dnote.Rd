% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/comments.R
\name{dnote}
\alias{dnote}
\title{dnote Function}
\usage{
dnote(x, index, confirm)
}
\arguments{
\item{x}{R object to remove the comment from}

\item{index}{the index of the comment to remove}

\item{confirm}{TRUE = require confirmation before deleting, FALSE = delete without confirmation}
}
\value{
Original R object with selected comment removed from comments attribute
}
\description{
This function allows a comment to be removed from the list of comments associated with the supplied R object.
}
\examples{
 \dontrun{
df2 <- dnote(df2,2,T)
}
}
\keyword{comment}
\keyword{delete}
