library(tidyverse)
library(ggplot2)
library(plotly)

Lor <- function(x, x0 = 0, FWHM = 1) {
    2 / (pi * FWHM) / (1 + ((x - x0) / (FWHM / 2))^2)
}

norm01 <- function(x) {
    (x - min(x)) / (max(x) - min(x))
}

Pruby <- function(w, laser = 568.189, dw = 2, P = -1, w0 = -1, l = FALSE) {
    # Pressure <-> Ruby Raman shift
    # Parameters from DOI: 10.1063/1.2135877
    A <- 1876
    dA <- 6.7
    B <- 10.71
    dB <- 0.14
    w_laser <- 1 / (laser) * 1e+07
    if (w0 > 0) {
        lambda0 <- 1 / (w_laser - w0) * 1e+07
    }
    else {
        lambda0 <- 694.24
    }
    if (P < 0) {
        lambda <- 1 / (w_laser - w) * 1e+07
        P <- A / B * ((lambda / lambda0)^B - 1)
        dP <- P * (dA / A + dB / B + 2 * B * dw / w)
        P
    }
    else {
        lambda <- lambda0 * (P * B / A + 1)^(1 / B)
        w <- w_laser - 1e7 / lambda
        if (l == FALSE) {
            w
        }
        else {
            lambda
        }
    }
}
