#' plots map(s) of populations
#' 
#' \code{rtPlotMapPop} plots map(s) of populations from simulation outputs 
#' i.e. a passed array of day,y,x,sex,age.  
#' Can plot a maximum of 16 days, will display the first 16 if you select more than this.
#' For adults to start with but could be used for pupae too. 

#' @param aRecord array of day,y,x,sex,age
#' @param days which days to plot, options 'all', 'final', 
#'    a number >0 and <days in the simulation, or a series e.g. c(1,2) or c(4:7)
#' @param ifManyDays days to plot if days='all' and num days > 16, Options: 
#'    'first' first 16 days, 'last' 16 days, 'firstlast' first8 and last8, 
#'    'spread' try to spread out days, e.g. if 32 it would plot 2,4,6, etc. can lead to uneven intervals.
#' @param sex which sex to plot, 'both' or 'MF' for both in same plot, 'M' males, 'F' females, 'M&F' for separate MF plots (only available for a single day)
#' @param title a title for the plot 
#' @param age allows selection of an age range, e.g. c(1:19), c(20:120) 
#' @param fMaxCellVal allow setting max value across multiple plots to keep colours constant
#' @param ext allow zooming in on a region by ext=c(w,e,s,n), e.g. ext=c(10,40,10,40) ext=c(20,30,20,30)
#' @param verbose print what it's doing 
#' 
#' @return raster brick used for plotting
#' @examples
#' tst <- rt_runGridTestSpread()
#' rtPlotMapPop(tst) 
#' @export
rtPlotMapPop <- function( aRecord, 
                          days = 'all',
                          ifManyDays = 'spread',
                          sex = 'MF',
                          age = 'sum',
                          title = NULL,
                          fMaxCellVal = NULL,
                          ext = NULL,
                          verbose = FALSE)
{
  #to sum the age structures in each cell on each day
  #and give result as [days,y,x]
 
  #subsetting of days
  #be careful that day0 is element1
  #Maybe I should drop the day0 thing before it bites me ?? I could set day1 to be the starting conditions. 
  numDays <- dim(aRecord)[1]
  if (days=='all') days <- TRUE
  else if (days=='final') days <- numDays
  #else check whether it is numeric and within the bounds of array[1]
  else if ( !is.numeric(days) | days<1 | days>numDays ){
    stop("days should be numeric and >0 and <=",numDays," or 'all' or 'final', yours is ",days)  
  }
  #else days is just left as it is
  
  #what to do if days=='all' and sim longer than 16 days
  if( identical(days,TRUE) & numDays>16 ) {
    if (ifManyDays=='last') days <- (numDays-15):numDays
    else if (ifManyDays=='first') days <- 1:16
    else if (ifManyDays=='firstlast') days <- c(1:8, (numDays-7):numDays)
    else if (ifManyDays=='spread') days <- as.integer(seq(from=1, to=numDays, by=numDays/16))
    else stop("ifManyDays should be 'last','first' or 'spread' yours is ",ifManyDays)
  }
  
  
  sexTitle <- sex
  if (sex=='both' | sex=='MF'){
    sex='sum' #TRUE worked when apply was used below
    sexTitle='MF'
  } else if (sex=='M&F')
  {
    if (length(days) > 1) {
      warning("M&F plot option only available for a single day, plotting final day")
      days <- numDays
      }
    #sex 'all' returns both sexes separately
    sex <- 'all'
    sexTitle <- paste('day', days, c('M','F'))
  }
  else if (sex != 'M' & sex != 'F') 
    stop("sex should be 'M','F','MF' or 'both', yours is ",sex)
  
  #to give an array of [days,y,x]
  #this works when sex=TRUE from above
  #aDays <- apply(aRecord[days,,,sex, ,drop=FALSE],MARGIN=c(1,2,3),sum) 
  #this works when sex='sum' from above
  aDays <- rtGetFromRecord(aRecord, days=days, sex=sex, age=age, drop=FALSE, verbose=verbose)
  #the drop=FALSE is to cope with nRow or nCol == 1
  
  
  #I might not need this with the new ,drop=FALSE above
  #if ( input$nRow == 1 || input$nCol == 1 )
  #  dim(aDays) <- dim(aGrid)[-length(dim(aGrid))]
  
  #set the color scale constant for all plots between 0 & max cell val
  #find the maximum cell value on any day
  if (is.null(fMaxCellVal)) 
    fMaxCellVal <- max( aDays )
  
  #breaks <- seq(0, fMaxCellVal, length.out=10)
  breaks <- pretty(c(0,fMaxCellVal), n=6) #n is how many intervals
  #can I add on a low cat of 0-1 flies
  #it does make the legend look a bit weird coz it overplots 0&1
  #but does make results clearer to me in test phase at least
  breaks <- c(0,1,breaks[-1])
  #to avoid error of 'breaks' are not unique
  breaks <- unique(breaks)  
  
  nb <- length(breaks)-1 
  colourP <- rev(terrain.colors(nb)) 
  #colourP <- topo.colors(nb) 
  
  #rearranging dimensions for raster brick
  #needs to be y,x,z
  if (length(dim(aDays))==3)
  {
    #for new 'M&F' option dims already in correct order
    if (names(dimnames(aDays)[1])!='y')
       aDays <- aperm(aDays, c(2, 3, 1))   
       
  }   else if (length(dim(aDays))==2) {
    
    #this adds a single z dimension if it has been lost
    #need to sort dimnames too, gets annoyingly fiddly
    #BUGFIX 7/1/15 y before x
    tmpnames <- list(y=dimnames(aDays)$y, x=dimnames(aDays)$x, day=days)
    aDays2 <- array(aDays, dim=c(dim(aDays),1), dimnames=tmpnames)
    aDays <- aDays2
    
#     dimnames(aDays2)[-3] <- dimnames(aDays)
#     names(dimnames(aDays2))[-3] <- names(dimnames(aDays))
#     #dimnames(aDays2)$x <- dimnames(aDays)$x
#     #dimnames(aDays2)$y <- dimnames(aDays)$y
#     dimnames(aDays2)[3] <- days
#     names(dimnames(aDays2))[3] <- 'day'

  } else
    stop("aDays should have 2 or 3 dimensions, it has ",length(dim(aDays)))
  
  # create raster brick (a collection of raster maps)
  #brick1 <- brick(aDays) 
  
  #BEWARE! trying to sort that dimensions y,x don't get transposed
  #brick1 <- brick(aDays, transpose=TRUE)
  brick1 <- brick(aDays)

  #the day titles for each subplot (otherwise they get lost when subsetted)
  if ( length(age)==1 && age=="sum")
    titles <- paste(dimnames(aDays)$day, sexTitle) 
  else
    titles <- paste0(dimnames(aDays)$day," ", sexTitle, " age",min(age),"-",max(age))
  
  #set extents for plotting (otherwise they go from 0-1)
  #this also ensures that cells maintain square aspect ratio 
  extent(brick1) <- extent(c(0, ncol(brick1), 0, nrow(brick1)))

  #allow zooming in on a region by ext=c(w,e,s,n) ext=c(10,40,10,40) ext=c(20,30,20,30)
  if (is.null(ext)) ext <- extent(brick1) 
    
  #plot(brick1, main=titles, breaks=breaks, col=colourP, ext=ext)  

  #todo I could replace this or offer an option to plot using spplot that auto creates just one legend
  #and it uses space better not having gaps between plots
  #spplot( raster::brick(a), names.attr=c(paste0("day",1:nDays)), col.regions=c("white",colorRampPalette(brewer.pal(9,"Blues"))(99)) )
  plot( spplot( brick1, names.attr=titles, col.regions=c("white",colorRampPalette(RColorBrewer::brewer.pal(9,"PuBu"))(99)), scales=list(draw=TRUE) ))
  #use cuts=10 to change number of classes from default of 100

  invisible(brick1)
  
}