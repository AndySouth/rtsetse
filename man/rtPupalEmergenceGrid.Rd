% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rtPupalEmergenceGrid.r
\name{rtPupalEmergenceGrid}
\alias{rtPupalEmergenceGrid}
\title{tsetse pupal emergence on a grid}
\usage{
rtPupalEmergenceGrid(aGrid, aGridPup, iPupDurF = 26, iPupDurM = 28)
}
\arguments{
\item{aGrid}{an array with the age distributions of males & females [y,x,sex,age]}

\item{aGridPup}{an array with the age distributions of pupal males & females [y,x,sex,age]}

\item{iPupDurF}{days it takes pupa(F) to develop}

\item{iPupDurM}{days it takes pupa(M) to develop}
}
\value{
a list containing aGrid, aGridPup
}
\description{
\code{rtPupalEmergenceGrid} moves pupae of both sexes from the oldest pupal age class to the youngest adult age class.
}
\details{
pupal emergence needs to come from the number of pupae in the ground of the appropriate age

Initially just gets the number of pupae from the final
age class of the passed vector.
Sets the number in that final age class to 0 at the same time
Would be less code if not in a function ...
Want to allow for it being more complex in future ...
Can get it to return vectors of both pupae & adults
}

