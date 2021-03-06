% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rt_runAspatial.r
\name{rt_runAspatial}
\alias{rt_runAspatial}
\title{an a-spatial tsetse population simulation, a third test of phase1}
\usage{
rt_runAspatial(iDays = 30, iMaxAge = 120, iCarryCapF = 200,
  fMperF = 0.5, fStartPopPropCC = 1, iStartAdults = 200, iStartAges = 1,
  iStartPupae = 200, pMortF = 0.05, pMortM = 0.05,
  iMortMinAgeStart = 10, iMortMinAgeStop = 50, fMortMinProp = 0.2,
  fMortOldProp = 0.3, propMortAdultDD = 0.25, pMortPupa = 0.25,
  propMortPupaDD = 0.25, iPupDurF = 26, iPupDurM = 28, iFirstLarva = 16,
  iInterLarva = 10, pMortLarva = 0.05, propMortLarvaDD = 0.25,
  plot = FALSE, verbose = TRUE)
}
\arguments{
\item{iDays}{days to run simulation}

\item{iMaxAge}{max age of fly allowed in model (will warn if flies age past this)}

\item{iCarryCapF}{carrying capacity of adult females}

\item{fMperF}{numbers of males per female, default 0.5 for half as many M as F}

\item{fStartPopPropCC}{starting population as a proportion of carrying capacity, default = 1}

\item{iStartAdults}{number of adults to start simulation with}

\item{iStartAges}{spread start adults across the first n ages classes}

\item{iStartPupae}{number of pupae to start simulation with (they get spread across sex&age)}

\item{pMortF}{adult female mortality on day1, rates on later days are determined by following parameters.}

\item{pMortM}{adult male mortality on day1, rates on later days are determined by following parameters.}

\item{iMortMinAgeStart}{Age at which min death rates start.}

\item{iMortMinAgeStop}{Age at which min death rates stop.}

\item{fMortMinProp}{What proportion of the maximum death rate on day 0 is the minimum death rate.}

\item{fMortOldProp}{What proportion of the maximum death rate on day 0 is the death rate after iDeathMinAgeStop.}

\item{propMortAdultDD}{proportion of adult mortality that is density dependent}

\item{pMortPupa}{pupal mortality per period}

\item{propMortPupaDD}{proportion of pupal mortality that is density dependent}

\item{iPupDurF}{days it takes pupa(F) to develop}

\item{iPupDurM}{days it takes pupa(M) to develop}

\item{iFirstLarva}{Age that female produces first larva}

\item{iInterLarva}{Inter-larval period}

\item{pMortLarva}{larval mortality per period}

\item{propMortLarvaDD}{proportion of larval mortality that is density dependent}

\item{plot}{whether to plot graphs}

\item{verbose}{whether to output progress messages to console}
}
\value{
a list of lots: 
\cr dataframes of adult age structure over time dfRecordF & M
\cr dataframes of adult age structure over time dfRecordPupa F & M
}
\description{
\code{rt_runAspatial} runs an a-spatial popn simulation as a test of phase 1 model components.
This differs from previous tests in being closer to Hat-trick.
\cr ~ uses age-dependent mortalities.  
\cr ~ tries to start popn. at stable age structure.
\cr rt_runAspatial was developed from rtPhase1Test3
}
\examples{
tst <- rt_runAspatial()
rtPlotPopAndPupae(tst$dfRecordF, tst$dfRecordM, tst$dfRecordPupaF, tst$dfRecordPupaM)
}

