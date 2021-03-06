#' plotting age specific mortality rates for Tsetse
#'
#' \code{rtPlotMortRatesByAge} 
#' plots mortality rates by Age.
#' Needs to be called separately for males & females.


#' @param vpMort a vector of age specific mortality rates
#' @param title a title for the plot 
#' @param col line colour 
#' 
#' @return ? nothing
#' @examples
#' vpMorts <- rtSetMortRatesByAge(iMaxAge = 100)
#' rtPlotMortRatesByAge(vpMorts,"males") 
#' @export

rtPlotMortRatesByAge <- function( vpMort,
                                  title="",
                                  col="red" )
{
  
  
  plot(vpMort, type='l', xlab='age in days', ylab='mortality rate', col=col,  main=title )
  
  
}
  