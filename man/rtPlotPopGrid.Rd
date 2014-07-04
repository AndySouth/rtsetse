\name{rtPlotPopGrid}
\alias{rtPlotPopGrid}
\title{plots popn of M&F over multiple days and grid cells}
\usage{
rtPlotPopGrid(mat, title = NULL)
}
\arguments{
  \item{mat}{matrix of day,x,y,sex,age}

  \item{title}{a title for the plot}
}
\value{
?ggplot2 object
}
\description{
\code{rtPlotPopGrid} plots change in M&F numbers over whole
grid from a passed matrix of day,x,y,sex,age. Uses a
different approach from rtPlotPopAndPupae using reshape2,
dplyr & ggplot2. EXPERIMENTAL
}
\examples{
tst <- rtPhase2Test2()
rtPlotPopGrid(tst)
}
