#' to return an array of grids used internally to represent movement across vegetation boundaries 
#' 
#' Used to represent effect of vegetation differences between cells.  
#' Can be used to reduce movement into less preferred vegetation in \code{\link{rtMove}}.  
#' 
#' Returns an array of movement multiplier grids labelled N,S,E,W,SN,WE,NS,EW. Those labelled SN,WE,NS,EW are needed for calculating stayers
#' for each cell they are the difference in preference with the 4 neighbours that act as sinks.
#' They are calculated by going back the other way from the initial neighbour calculation.
#' This is tricky because of the way it is coded to make it run faster.

#' @param mVegCats a matrix of vegetation categories
#' @param iBestVeg the index of the preferred vegetation for this species
#' @param verbose print what it's doing T/F
#' 
#' @return an array of movement multiplier grids labelled N,S,E,W,SN,WE,NS,EW
#' 
#' @seealso \code{\link{rtSetVegMoveGrids}} which sets up similar grids for influencing movement by the vegetation within a cell.\cr
#' \code{\link{rtMove}} uses the grids created.\cr\cr
#' The movement vignette contains more details about how movement can be represented, type this in the R console : 
#' \code{vignette("vignette-movement", package="rtsetse")}

rtSetVegDifGrids <- function(mVegCats = array(c("O","O","O","O","S","O","O","O","O","O","O","O"),dim=c(3,4)),
                           iBestVeg = 4,
                           verbose=FALSE) {

  
  #to add a decrease in movement from 'better' to 'poorer' vegetation types as in Hat-trick
  
  #calculate change associated with each move, once based on the vegmap and save results as an array
  #aVegChange[y,x,(N,E,S,W)]
  
  #vegetation types are ordered by decreasing density 1 to 5
  #movement that results in a change away from preferred density is reduced
  #by the number of categories of the change
  
  #algorithm :
  #qualityChange = abs(from-best) - abs(to-best)
  #if (qualityChange) >= 0 move=100%
  #else if (qualityChange < 0) decrease movement
  #default decrease in movement from Hat-trick is
  #1, 0.3, 0.1, 0.03, 0.01, 0.001 
  
  
  nY <- dim(mVegCats)[1]
  nX <- dim(mVegCats)[2]
  dimnames1 <- list( y=paste0('y',1:nY), x=paste0('x',1:nX), grid=c("N","E","S","W","SN","WE","NS","EW"))

  #dim of array got from dimnames above
  aVegDifMult <- array(dim=sapply(dimnames1,length), dimnames=dimnames1)
   
  
  #convert veg characters to numeric, note nogo "N" to NA
  mVegNum <- rtSetGridFromVeg( mVegCats, dfLookup=data.frame(from=c("D","T","O","S","B","G","N"),to=c(1,2,3,4,5,6,NA),stringsAsFactors = FALSE ))
  
  #matrix of difference of veg in cell from best
  mVegDifPref <- abs(iBestVeg-mVegNum)
  
  #remember
  #in the code below matrices with NESW on end are source cells
  #matrices without are destination cells
  #~~~~~~~~~~~~~~~~~~~~~~~~~~
  #so I need to create NESW matrices that represent the change in veg preference associated with that move
  #first create copies
  mVegDifPrefN <- shiftGridReflectN(mVegDifPref)
  mVegDifPrefE <- shiftGridReflectE(mVegDifPref)
  mVegDifPrefS <- shiftGridReflectS(mVegDifPref)   
  mVegDifPrefW <- shiftGridReflectW(mVegDifPref)      
  #then do calculation, source-destination
  mVegDifPrefN <- mVegDifPrefN - mVegDifPref
  mVegDifPrefE <- mVegDifPrefE - mVegDifPref
  mVegDifPrefS <- mVegDifPrefS - mVegDifPref
  mVegDifPrefW <- mVegDifPrefW - mVegDifPref
  #seems to work
  #unique(as.vector(mVegDifPrefN))
  #now convert the change associated with the move to a modifier of the movement rate
  #convert 0:5 to   1, 0.3, 0.1, 0.03, 0.01, 0.001 
  #dfLookup <- data.frame(from=c(-5:5),to=c(0.001, 0.01, 0.03, 0.1, 0.3, 1, 1, 1, 1, 1, 1))
  #include converting any NAs to 0 so no flies move to or from
  dfLookup <- data.frame(from=c(NA,-5:5),to=c(0, 0.001, 0.01, 0.03, 0.1, 0.3, 1, 1, 1, 1, 1, 1))
  #mVegbmult mVeg boundary multiplier
  #these are used for calculating arrivers
  #for each cell they are the difference in preference with 4 neighbours that act as sources
  aVegDifMult[,,"N"] <- rtSetGridFromVeg( mVegDifPrefN, dfLookup=dfLookup )
  aVegDifMult[,,"E"] <- rtSetGridFromVeg( mVegDifPrefE, dfLookup=dfLookup )
  aVegDifMult[,,"S"] <- rtSetGridFromVeg( mVegDifPrefS, dfLookup=dfLookup )
  aVegDifMult[,,"W"] <- rtSetGridFromVeg( mVegDifPrefW, dfLookup=dfLookup )
  
  #BEWARE 5/3/15 THIS IS THE TRICKIEST BIT IN THE WHOLE OF RTSETSE
  #I've tested that it does do what is expected, e.g. see movement vignette
  #but how the mechanism is coded to be time efficient is very tricky
  
  #the below are needed for calculating stayers
  #for each cell they are the difference in preference with the 4 neighbours that act as sinks
  #they are calculated by going back the other way from the initial neighbour calculation
  #all boundary values are replaced with 1 because for reflecting boundaries there will be no change 
  #in vegetation associated with movements in and out of the grid    
  aVegDifMult[,,"SN"] <- shiftGridIslandN( aVegDifMult[,,"S"], fill=1 )
  aVegDifMult[,,"WE"] <- shiftGridIslandE( aVegDifMult[,,"W"], fill=1 )
  aVegDifMult[,,"NS"] <- shiftGridIslandS( aVegDifMult[,,"N"], fill=1 )   
  aVegDifMult[,,"EW"] <- shiftGridIslandW( aVegDifMult[,,"E"], fill=1 )   

  invisible(aVegDifMult)
}