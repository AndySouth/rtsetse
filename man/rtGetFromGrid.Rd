% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rtGetFromGrid.r
\name{rtGetFromGrid}
\alias{rtGetFromGrid}
\title{to access population data from the grid of [x,y,sex,age]}
\usage{
rtGetFromGrid(aGrid, y = "all", x = "all", sex = "all", age = "all")
}
\arguments{
\item{aGrid}{an array with the age distributions of males & females [y,x,sex,age]}

\item{y}{grid row number}

\item{x}{grid column number}

\item{sex}{'all' returns both sexes separately,'M','F', 'sum' sums sexes}

\item{age}{'all' returns age distribution, 'sum' sums all ages, or an integer age
?or maybe an age range too}
}
\value{
an array, matrix or vector named with remaining dimensions of [y,x,sex,age]
}
\description{
NOT USED YET. I might not even need it. rtGetFromRecord() likely to be more useful.
\code{rtGetFromGrid} allows access to population data from a grid of sexes and ages. 
You can specify which [x,y,sex,age] you want to get data for.  
Each variable defaults to 'all' so \code{rtGetFromGrid(aGrid)} would return the whole grid.   
='sum' can be used to sum across dimensions, 
thus \code{rtGetFromGrid(aGrid,x='sum',y='sum',sex='sum',age='sum')} 
would produce a single value of the total population on the grid.
}
\examples{
tst <- rt_runGrid()
aGrid <- tst['day2',,,,]
rtGetFromGrid(aGrid,x='sum',y='sum',sex='sum') #age structure for whole pop
rtGetFromGrid(aGrid,x='sum',y='sum',age='sum') #sex ratio for whole pop
#slight anomally this gives 4 grids
rtGetFromGrid(aGrid,x='all',y='all',age=c(1,2),sex='all')
#this gives just 1
rtGetFromGrid(aGrid,x='all',y='all',age=c(1,2),sex='sum')
}

