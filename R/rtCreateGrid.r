#' create a grid array to represent a spatial, sex & age structured popn
#' 
#' \code{rtCreateGrid} creates a named array with dimensions, y,x,sex,age.  
#' The dimensions are named e.g. x1,x2..., y1,y2... to reduce potential for confusion.

#' @param nY number of y cells
#' @param nX number of x cells
#' @param sexes vector of sex names default=c("F","M")
#' @param nAge number of ages
#' @param fill what value to fill array with
#' 
#' @return a named array with the specified dimensions
#' @examples
#' aGrid <- rtCreateGrid( nY=3, nX=4,nAge=2, fill=0 )
#' @export

#todo : before release I may want to remove the defaults (can leave sexes)
rtCreateGrid <- function( nY = 3,
                          nX = 4,
                          sexes = c("F","M"),
                          nAge = 2,
                          fill = 0 )
{
  
  #set dimension names
  dimnames1 <- list( y=paste0('y',1:nY), x=paste0('x',1:nX), sex=sexes, age=paste0('age',1:nAge))
  
  #create and fill the array
  aGrid <- array(fill, dim=c(nY,nX,2,nAge), dimnames=dimnames1)
  
  #if you wanted to fill with sequential values later you could use
  #aGrid[] <- 1:length(aGrid)
  
  invisible(aGrid)
  
}



