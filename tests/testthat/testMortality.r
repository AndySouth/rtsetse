library(rtsetse)

context("Mortality")


test_that("mortality on a grid with no density-dependence works", {
  
  #create a test grid array, y,x,sex,age
  nX <- 4
  nY <- 3
  iMaxAge <- 2
  #create an empty grid
  aGrid <- rtCreateGrid(nY=nY, nX=nX, nAge=iMaxAge, fill=0)  
  
  #put popn into grid
  aGrid[,,'F',1] <- array(c(1,0,0,0,0,0,0,0,0,0,0,0),dim=c(nY,nX))
  aGrid[,,'M',2] <- array(c(0,1,0,0,0,0,0,0,0,0,0,0),dim=c(nY,nX))
  #set mortality by age vectors
  vpMortF <- c(0.1,0)
  vpMortM <- c(0,0.2)
  
  #with no density dependence
  aGrid2 <- rtMortalityGrid( aGrid, 
                             vpMortF=vpMortF, 
                             vpMortM=vpMortM,
                             iCarryCap=1,
                             propDD=0)
  
  #check that the age classes for M & F have changed as expected 
  expect_equal( aGrid2[,,'F',1],
                 aGrid[,,'F',1] * (1-vpMortF[1]) )  
  expect_equal( aGrid2[,,'M',2],
                 aGrid[,,'M',2] * (1-vpMortM[2]) ) 
  

})  



