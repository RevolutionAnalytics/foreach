\name{makeIwrapper}
\alias{makeIwrapper}
\alias{isample}

\title{Iterator Maker Generator}
\description{
 The \code{makeIwrapper} function makes iterator makers.  The resulting iterator makers all take
 an optional \code{count} argument which specifies the number of times the
 resulting iterator should fire.  The iterators are wrappers around functions
 that return different values each time they are called. The \code{isample} function
 is an example of one such iterator maker (as are \code{irnorm}, \code{irunif}, etc.).
}
\usage{
makeIwrapper(FUN)
isample(..., count)

}
\arguments{
  \item{FUN}{a character string naming a function that generates 
    different values each time it is
    called; typically one of the
    standard random number generator functions.}
  \item{count}{number of times that the iterator will fire.
               If not specified, it will fire values forever.}
  \item{\dots}{arguments to pass to the underlying \code{FUN} function.}
}
\value{
  An iterator that is a wrapper around the corresponding function.
}
\examples{
  # create an iterator maker for the sample function
  mysample <- makeIwrapper('sample')
  # use this iterator maker to generate an iterator
  # that will generate three five member samples from the
  # sequence 1:100
  it <- mysample(1:100, 5, count=3)
  nextElem(it)
  nextElem(it)
  nextElem(it)
  try(nextElem(it))  # expect a StopIteration exception
}
\keyword{utilities}
