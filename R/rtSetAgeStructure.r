#' setting an age structure, the abundance in each age class
#'
#' \code{rtSetAgeStructure} 
#' fills an age structure based on population at age1 and age-specific mortality rates.
#' Needs to be called separately for males & females.

#' @param vpMort a vector of age specific mortality rates, number of age classes is also got from this.
#' @param fPopAge0 population at age 0
#' 
#' @return a vector of abundance by age
#' @export

rtSetAgeStructure <- function( vpMort = rep(0.1,10), #seq(0.1,1,0.1), 
                               fPopAge0 = 100 )
{
  
  
  #create a vector of ages
  #vAges <- seq(vPop)
  
  #create a vector filled with NAs
  vPop <- rep(NA,length(vpMort))
  
  #set age1 pop from argument
  #vPop[1] <- fPopAge0
  #!BEWARE tricky
  #seems that pop[age] is after the mortality is applied
  vPop[1] <- fPopAge0 - (fPopAge0 * vpMort[1]) 

  #set subsequent age pops by iteratively applying mortalities
  for( age in 2:length(vPop))
  {
    #n[age]=n[age-1]-(n[age-1]*mort)
    #vPop[age] <- vPop[age-1] - ( vPop[age-1] * vpMort[age-1] )
    #BEWARE! which of these is right
    vPop[age] <- vPop[age-1] - ( vPop[age-1] * vpMort[age] )
  }
  
  
  #invisible(vPop)
  vPop
}