#' seeks day1 mortality rates for F&M that give popn stability
#'
#' \code{rtMortalityStableSeek} seeks a age1 mortality rate for F that leads to population stability
#' and for M that leads to the user supplied ratio of males to females.  
#' It does this by testing successive mortality rates, starting at very low values and increasing until 
#' target values are met.
#' In each case age1 mortality rates are converted into age dependent mortalities using other user inputs.
#' The resulting mortalities are used to fill an age structure from age1.  
#' For F, user supplied parameters are used to simulate larval production. 
#' The target is to produce the same number of larvae as age1 pupae - thus leading to a stable population.
#' Once a stable female age structure has been achieved, the function searches in the same way for 
#' the age1 male mortality rate that generates a male age structure to satisfy the to the user supplied 
#' ratio of males to females.


#' @param iMaxAge max age of fly allowed in model
#' @param iTargetPopAge0 target pop of both sexes at age 0
#' @param fInterval the interval between mortalities used to test
#' @param fHighestTestMort the highest mortality tested
#' @param fMperF desired numbers of males per female, default=0.5
#' @param pMortLarva larval mortality per period
#' 
#' @param iMortMinAgeStartF  Age at which min death rates start. 
#' @param iMortMinAgeStopF   Age at which min death rates stop.
#' @param fMortMinPropF  What proportion of the maximum death rate on day 0 is the minimum death rate.
#' @param fMortOldPropF  What proportion of the maximum death rate on day 0 is the death rate after iDeathMinAgeStop.
#'
#' @param iMortMinAgeStartM  Age at which min death rates start. 
#' @param iMortMinAgeStopM   Age at which min death rates stop.
#' @param fMortMinPropM  What proportion of the maximum death rate on day 0 is the minimum death rate.
#' @param fMortOldPropM  What proportion of the maximum death rate on day 0 is the death rate after iDeathMinAgeStop.
#' 
#' @param propMortAdultDD proportion of adult mortality that is density dependent
#' @param pMortPupa pupal mortality per period
#' @param iPupDurF days it takes pupa(F) to develop
#' @param iPupDurM days it takes pupa(M) to develop
#' @param iFirstLarva Age that female produces first larva
#' @param iInterLarva Inter-larval period 
#' 
#' @param plot whether to output plots
#' @param verbose whether to output progress text
#' 
#' #' @return float mortality probability
#' @export


rtMortalityStableSeek <- function( iMaxAge = 120,
                                  iTargetPopAge0 = 100,
                                  fInterval = 0.001,
                                  fHighestTestMort = 0.3,
                                  fMperF = 0.5,
                                  pMortLarva = 0.05,
                                  
                                 iMortMinAgeStartF = 10,
                                 iMortMinAgeStopF = 60,
                                 fMortMinPropF = 0.2,
                                 fMortOldPropF = 0.3,
                                 
                                 iMortMinAgeStartM = 10,
                                 iMortMinAgeStopM = 40,
                                 fMortMinPropM = 0.2,
                                 fMortOldPropM = 0.3,
                                 
                                 propMortAdultDD = 0.25,
                                 
                                 pMortPupa = 0.25,
                                 iPupDurF = 26,
                                 iPupDurM = 28,
                                 iFirstLarva = 16,
                                 iInterLarva = 10, 
    
                                  plot = TRUE,
                                  verbose = FALSE )
{
  #todo: add in some testing & error msg for if stability not found
  
  
  #create a vector of mortalities to test both M&F
  #starts low & increases
  #unlikely to ever go above mort 0.4 (or even get close to)
  #vMorts <- seq(fInterval, 0.4, fInterval) 
  #instead maybe I should start at higher mortalities
  #I want a popn that will persist, so better to have mortality that 
  #is a little too low rather than little too high
  vMorts <- seq(fHighestTestMort, fInterval, -fInterval)   
  
  #impose pupal mort to get adults age0 (division by 2 for both sexes)
  popAge0MorF <- iTargetPopAge0/2 * (1-pMortPupa) 
  #test with no pupal mort actually gave same results
  #popAge1MorF <- iTargetPopAge0/2  
  
  ########
  #Females
  
  #create a vector filled with NAs for results
  vLarvae <- rep(NA,length(vMorts))
  
#   #set trialLarvae high to start the while loop
#   numTrialLarvae <- popAge0MorF+1
#   trial <- 1
#   #try increasing mortalities while trial is above threshold
#   while( numTrialLarvae > popAge0MorF )

  #search by decreasing mortality until numTrialLarvae goes above a threshold
  #first set below that threshold
#   numTrialLarvae <- popAge0MorF-1
#   trial <- 1
#   while( numTrialLarvae < popAge0MorF )
  numTrialLarvae <- iTargetPopAge0-1
  trial <- 1
  while( numTrialLarvae < iTargetPopAge0 )
  {
    #set age1 mort for this trial
    fMort <- vMorts[trial]
    #set mortality by age (& determines num ages)
    #age independent
    #vpMort <- rep(fMort, iMaxAge)
    #age-dependent mortality
    vpMort <- rtSetMortRatesByAge(  iMaxAge = iMaxAge, 
                                    pMortAge1 = fMort,
                                    iMortMinAgeStart = iMortMinAgeStartF,
                                    iMortMinAgeStop = iMortMinAgeStopF,
                                    fMortMinProp = fMortMinPropF,
                                    fMortOldProp = fMortOldPropF )  
    
    
    #fill an age structure
    vPopF <- rtSetAgeStructure( vpMort=vpMort, fPopAge0=popAge0MorF )
    
    #setting age dependent deposition rates
    vpDeposit <- rtSetDepositionRatesByAgeDI( iMaxAge=iMaxAge, iFirstLarva=iFirstLarva, iInterLarva=iInterLarva, pMortLarva=pMortLarva )
    #calc M&F larvae using the deposition rates set above
    lLarvae <- rtLarvalDeposition( vPopF, vpDeposit )    
    #summing M&F
    numTrialLarvae  <- lLarvae$fLarvaeF + lLarvae$fLarvaeM  

    
    if (verbose) cat("trial MortF:",fMort,"totF:",sum(vPopF),"larvae:",numTrialLarvae,"\n")
    
    vLarvae[trial] <- numTrialLarvae
    trial <- trial+1
  }
  #set bestMort to the final trial (where larvae>=fPopAge)
  bestMortF <- vMorts[trial-1]
  cat("bestMortF:",bestMortF,"larvae:",numTrialLarvae,"\n")
  
  #calc tot F in best trial, used to calc num males below
  bestTotF <- sum(vPopF)
  
  
  
  ########
  #Males  
  
  #create a vector filled with NAs to save results
  vMales <- rep(NA,length(vMorts))
   
  #set males requested to total females * MFratio
  fMalesRequested <- bestTotF * fMperF
  
#   #set trialLarvae high to start the while loop
#   numTrialMales <- fMalesRequested + 1
#   trial <- 1
#   while( numTrialMales > fMalesRequested )
  #**TRYING NEW VERSION that searches by decreasing mortality  
  numTrialMales <- fMalesRequested - 1
  trial <- 1
  while( numTrialMales < fMalesRequested )
  {
    #set age1 mort for this trial
    fMort <- vMorts[trial]
    #set mortality by age (& determines num ages)
    #age independent
    #vpMort <- rep(fMort, iMaxAge)
    #age-dependent mortality
    vpMort <- rtSetMortRatesByAge( iMaxAge = iMaxAge, 
                                   pMortAge1 = fMort,
                                   iMortMinAgeStart = iMortMinAgeStartM,
                                   iMortMinAgeStop = iMortMinAgeStopM,
                                   fMortMinProp = fMortMinPropM,
                                   fMortOldProp = fMortOldPropM ) 

    #fill an age structure
    vPopM <- rtSetAgeStructure( vpMort=vpMort, fPopAge0=popAge0MorF )
    
    #sum num males in all age classes
    numTrialMales <- sum(vPopM)
    
    if (verbose) cat("trial MortM:",fMort,"totM:",numTrialMales,"\n")
    
    vMales[trial] <- numTrialMales
    trial <- trial+1
  }
  #set bestMort to the final trial (where larvae>=fPopAge)
  bestMortM <- vMorts[trial-1]
  cat("bestMort for males:",bestMortM,"males:",numTrialMales,"\n")
  
  if (plot)
  {
    plot( vMorts, vLarvae, type='l', ylab='larvae', xlab='female mortality age1' )
    #add starting pop age1
    abline(h=iTargetPopAge0, col='red')  
    mtext(paste("Sought mortalities F:",bestMortF,"  M:",bestMortM))
  }
  
  
  lBestMorts <- list(F=bestMortF, M=bestMortM)
  
  lBestMorts
}