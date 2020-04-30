library(tidyverse)
library(FME)
library(plotly)
library(rmarkdown)
library(shiny)
library(plotly)
Sys.setlocale("LC_ALL", 'en_US.UTF-8')

options(device="quartz")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
sumLor <- function(x,params){
    # sum of Lorentzian functions
    y0   <- as.numeric(params[grep("y0",names(params))])
    A    <- as.numeric(params[grep("A",names(params))])
    x0   <- as.numeric(params[grep("x0",names(params))])
    FWHM <- as.numeric(params[grep("FWHM",names(params))])
    if(length(x0)!=length(FWHM)) FWHM <- rep(FWHM, length.out=length(x0))
    if(length(x0)!=length(A))    A <- rep(A, length.out=length(x0))
    if(length(x0)!=length(y0))   y0 <- rep(y0, length.out=length(x0))
    rowSums(sapply(1:length(x0), function(i) {
          y0[i] + 2*A[i]/(pi*FWHM[i])/( 1 + ((x-x0[i])/(FWHM[i]/2))^2 )
        }))
}

norm01 <- function(x) {(x-min(x))/(max(x)-min(x))}

Pruby <- function (w, laser = 568.189, dw = 2 , P=-1, w0=-1, l=FALSE) {
  # Pressure <-> Ruby Raman shift
  # Parameters from DOI: 10.1063/1.2135877
    A <- 1876
    dA <- 6.7
    B <- 10.71
    dB <- 0.14
    w_laser <- 1/(laser) * 1e+07
    if(w0>0){
      lambda0 <- 1/(w_laser - w0) * 1e+07
    }
    else{
      lambda0 <- 694.24
    }
    if(P<0){
      lambda <- 1/(w_laser - w) * 1e+07
      P <- A/B * ((lambda/lambda0)^B - 1)
      dP <- P * (dA/A + dB/B + 2 * B * dw/w)
      # c(P = P, dP = dP)
      P
    }
    else{
      lambda <- lambda0*(P*B/A + 1)^(1/B)
      w <- w_laser - 1e7/lambda
      if(l==FALSE){w}
      else{lambda}
    }
}

