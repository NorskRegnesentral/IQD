##############################################################
# Calculate integrated quadratic distance (IQD) between the
# empirical cumulative distribution functions of two data
# vectors with the crps_sample function.
##############################################################

IQD_crps <- function(modelVec,obsVec){

  IQD <- NA

  # Vectors have values (not only NA's)
  if(any(!is.na(modelVec)) & any(!is.na(obsVec))){
    # Remove NA's
    modelVec <- modelVec[!is.na(modelVec)]
    obsVec <- obsVec[!is.na(obsVec)]
    # IQD of ecdf difference
    scoreModel <- 0
    scoreObs <- 0
    for(i in 1:length(obsVec)){
      # method="edf" gives the empirical distribution function
      scoreModel <- scoreModel+crps_sample(y=obsVec[i],dat=modelVec,method="edf")
      scoreObs <- scoreObs+crps_sample(y=obsVec[i],dat=obsVec,method="edf")
    }
    IQD <- as.numeric((scoreModel-scoreObs)/length(obsVec))
  }
  
  IQD
}


##############################################################
# Calculate integrated quadratic distance (IQD) between the 
# empirical cumulative distribution functions of two data
# vectors with the integrate function.
##############################################################

IQD_integrate<- function(modelVec,obsVec){

  IQD <- NA

  # Vectors have values (not only NA's)
  if(any(!is.na(modelVec)) & any(!is.na(obsVec))){
    # Remove NA's
    modelVec <- modelVec[!is.na(modelVec)]
    obsVec <- obsVec[!is.na(obsVec)]
    # Limits of integration
    lowerLimit <- range(c(modelVec,obsVec))[1]
    upperLimit <- range(c(modelVec,obsVec))[2]
    # IQD of ecdf difference
    IQD <- integrate(Diff_ecdf,lower=lowerLimit,upper=upperLimit,subdivisions=5000,modelData=modelVec,obsData=obsVec)$value    
  }
  
  IQD
}


#############################################
# Evaluate difference between two empirical
# cumulative distribution functions.
#############################################

Diff_ecdf <- function(x,modelData,obsData){
  F <- ecdf(modelData)
  G <- ecdf(obsData)
  (F(x)-G(x))^2
}


##############################################################
# Calculate weighted integrated quadratic distance (IQD) between  
# the empirical cumulative distribution functions of two data
# vectors with the integrate function.
##############################################################

wIQD_integrate<- function(modelVec,obsVec, wFct){

  IQD <- NA

  # Vectors have values (not only NA's)
  if(any(!is.na(modelVec)) & any(!is.na(obsVec))){
    # Remove NA's
    modelVec <- modelVec[!is.na(modelVec)]
    obsVec <- obsVec[!is.na(obsVec)]
    # Limits of integration
    lowerLimit <- range(c(modelVec,obsVec))[1]
    upperLimit <- range(c(modelVec,obsVec))[2]
    # IQD of ecdf difference
    IQD <- integrate(wDiff_ecdf,lower=lowerLimit,upper=upperLimit,subdivisions=5000,modelData=modelVec,obsData=obsVec,wFct=wFct)$value    
  }
  
  IQD
}


#############################################
# Evaluate weighted difference between two 
# empirical cumulative distribution functions.
#############################################

wDiff_ecdf <- function(x,modelData,obsData,wFct){
  F <- ecdf(modelData)
  G <- ecdf(obsData)
  (F(x)-G(x))^2 * wFct(x)
}


####################################################
# Print IQD values calculated with the crps_sample
# function and the integrate function.
####################################################

PrintIQD <- function(xVec,yVec){
  print(paste("IQD_crps      = ",round(IQD_crps(xVec,yVec),8),sep=""))
  print(paste("IQD_integrate = ",round(IQD_integrate(xVec,yVec),8),sep=""))
}
