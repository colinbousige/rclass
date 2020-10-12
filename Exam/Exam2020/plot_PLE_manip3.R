setwd("~/Travail/Data/PostdocILM/PLE/2015-07-22") # set working directory


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# SIMULATIONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Some functions
Rt     <- function(n,m){0.142/2/pi*sqrt(3*(n*n + m*m + n*m))} # nanotube radius in nm
Dt     <- function(n,m){0.142/pi*sqrt(3*(n*n + m*m + n*m))}   # nanotube diameter in nm
alpha  <- function(n,m){atan(sqrt(3)*m/(2*n+m)) }             # nanotube chiral angle in radian
RBMw   <- function(n,m,C=0){227/Dt(n,m)*sqrt(1+C*Dt(n,m)^2)}  # RBM in cm-1
linear <- function(x,a,b){a*x+b}

# Transition energies, taken from Cambre et al., Angew. Chem. Int. Ed. 50 (2011), 2764-2768
mu11 <- function(n,m,in_nm=TRUE){ # emission freq in nm or cm-1
  if( (n - m) %% 3 == 0){A <- NA;   B <- NA} # metallic tubes -> no gap
  if( (n - m) %% 3 == 1){A <- -674; B <- 1;}
  if( (n - m) %% 3 == 2){A <- 285;  B <- 1;}
  in_cm <- B*( 1e7 / ( 151.4 + 1090.9*Dt(n,m)) + A * cos(3*alpha(n,m)) / (Dt(n,m))^2 )
  if(in_nm){1/in_cm*1e7}
  else{in_cm}
}
mu22 <- function(n,m,in_nm=TRUE){ # absorption freq in nm or cm-1
  if( (n - m) %% 3 == 0) {A <- NA;    B <- NA} # metallic tubes -> no gap
  if( (n - m) %% 3 == 1) {A <- 1261;  B <- 1;}
  if( (n - m) %% 3 == 2) {A <- -1345; B <- 1;}
  in_cm <- B*( 1e7 / ( 145.7 + 581.9*Dt(n,m) ) + A * cos(3*alpha(n,m)) / (Dt(n,m))^2 )
  if(in_nm){1/in_cm*1e7}
  else{in_cm}
}
mu_lim_30 <- function(x,transition,in_nm=TRUE){ # line of 30 degrees for alpha, in nm or cm-1
  if(transition == 1) {in_cm <- 1e7 / ( 151.4 + 1090.9*x)}
  if(transition == 2) {in_cm <- 1e7 / ( 145.7 + 581.9*x)}
  if(in_nm){1/in_cm*1e7}
  else{in_cm}
}
mu_lim_0 <- function(x,transition,mod,in_nm=TRUE){ # theoric limit of 0 degrees for alpha, in nm or cm-1
  if(transition == 1) {
    if(mod == 1){A <- -674};if(mod == 2){A <- 285};
    in_cm <- 1e7 / ( 151.4 + 1090.9*x) + A * cos(0) / x^2 
  }
  if(transition == 2) {
    if(mod == 1){A <- 1261};if(mod == 2){A <- -1345};
    in_cm <- 1e7 / ( 145.7 + 581.9*x) + A * cos(0) / x^2
  }
  if(in_nm){1/in_cm*1e7}
  else{in_cm}
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# MESURES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

d <- read.table("Data/stock_30s.dat",header=FALSE,row.names=1,skip=1,dec=",")
lambda_ex <- as.numeric(read.table("Data/stock_30s.dat",header=FALSE,row.names=1,nrows=1,dec=",")[1,])
x <- as.numeric(rownames(d))

laserP <- read.table("laser_power.txt",header=TRUE)
laserP[,2] <- laserP[,2]/max(laserP[,2])
plot(laserP)
laserP <- approxfun(laserP[,"lambda"], laserP[,"P"])
DetEff <- read.table("InGaAs_efficiency.txt",header=TRUE,col.names=c("lambda","eff"))
DetEff[,1] <- DetEff[,1]*1000 # lambda in nm
DetEff <- approxfun(DetEff[,"lambda"], DetEff[,"eff"])

files  <- list.files(path="Data/", full.names=FALSE)
acqtime <- substr(files, start=nchar(files)-6, stop=nchar(files))
acqtime <- as.numeric(substr(acqtime, 1,2))

bg <- vector("list",length=max(acqtime))
for(t in acqtime){
  bg[[t]] <- read.table(paste("Backgrounds/bg_",t,"s.dat",sep=""),header=FALSE,dec=",")
  bg[[t]] <- rep(bg[[t]][,2],5)
}

size <- 200
PLE  <- vector("list",length=length(files))
for(i in 1:length(files)){
  PLE[[i]]  <- matrix(nrow=size,ncol=length(lambda_ex)) # x sur les lignes, y sur les colonnes
}

x1 <- 1:1024
x2 <- 1:1024+1024
x3 <- 1:1024+1024*2
x4 <- 1:1024+1024*3
x5 <- 1:1024+1024*4

for (file in files) {#file<-"stock_30s.dat"
  d <- read.table(paste("Data/",file,sep=""),header=FALSE,row.names=1,skip=1,dec=",")
  j <- which(file==files)
  for (i in 1:length(lambda_ex)){#i=9
    dd <- as.vector(d[,i] - bg[[acqtime[j]]] ) 
    dd <- dd - min(dd)
    plot(d[,i])
    plot(x,dd)

    y <- dd
    scales    <- seq(1,63,1)
    wCoefs    <- cwt(y, scales=scales, wavelet='mexh')
    localMax  <- getLocalMaximumCWT(wCoefs)
    ridgeList <- getRidge(localMax, iInit = ncol(localMax), step = -1, iFinal = 1, minWinSize= 5, gapTh = 3, skip = NULL)
    majorPeakInfo <- identifyMajorPeaks(y, ridgeList, wCoefs, SNR.Th=1.4,ridgeLength=1)
    peakWidth <- widthEstimationCWT(y,majorPeakInfo)
    backgr    <- baselineCorrectionCWT(y,peakWidth,threshold=10,lambda=7e4,differences=1)
    corrected <- y-backgr 
    plot(x,y,type='l',ylim=c(min(c(y,corrected)),max(c(y,corrected))),
    main=paste("run =",i),xlab=expression("Wavenumber / cm"^-1),ylab="Raman Intensity/Arbitr. Units")
    points(x[majorPeakInfo$peakIndex],y[majorPeakInfo$peakIndex])
    lines(x,backgr,lty=5,col="red")
    lines(x,corrected,lty=5,col="royalblue")

    dd <- corrected

    temp <- reb(data.frame(x,dd),size)
    PLE[[j]][,i] <- temp[,2]/DetEff(temp[,1])/laserP(lambda_ex[i])/acqtime[j]

    plot(PLE[[j]][,i])
  }
  lambda_em <- temp[,1]
  PLE[[j]][is.na(PLE[[j]])] <- 0
  PLE[[j]] <- PLE[[j]]/max(PLE[[j]])
}

for (i in 1:length(files) ) {#i<-2
  sample <- sub(paste("_",acqtime[i],"s.dat",sep=""), "", files[i])

  xmin <- 850 ; xmax <- 1250
  ymin <- 490 ; ymax <- 765
  temp <- PLE[[i]][which(lambda_em<xmax & lambda_em>xmin),which(lambda_ex>ymin & lambda_ex<ymax)]
  temp <- temp-min(temp)
  temp <- temp/max(temp)
  x <- lambda_em[which(lambda_em<xmax & lambda_em>xmin)]
  y <- lambda_ex[which(lambda_ex>ymin & lambda_ex<ymax)]
  xy <- expand.grid(x=1:length(x),y=1:length(y))
  xyz <- data.frame(expand.grid(x=x,y=y),z=NA)

  for (j in 1:length(xyz[,1])) {#j<-3
    xyz[j,"z"] <- temp[xy[j,"x"],xy[j,"y"]]/min(temp[which(temp>0)])
  }
  toplot <- expandRows(xyz, "z")

  # png(paste("PLE_",sample,".png",sep=""), width=8, height=6, units="in", res=500,type="cairo",antialias = "none", bg = "transparent")
  # pdf(paste("PLElog_",sample,".pdf",sep=""), width=8, height=6)
  pdf(paste("PLE_",sample,"_arial.pdf",sep=""), width=8, height=6)
  # pdf(paste("PLE_",sample,".pdf",sep=""), width=8, height=6)
  # par(family = "Times", cex.lab=1.7, cex.axis=1.7, mgp = c(2.5, .5, 0), tck=0.02, mar=c(4, 4, 1, 5.5), lwd=2)
  par(cex.lab=1.7, cex.axis=1.7, mgp = c(2.5, .5, 0), tck=0.02, mar=c(4, 4, 1, 5.5), lwd=2)
  smoothScatter(toplot,nbin = 200, bandwidth=3,
                     colramp = colorRampPalette(c("white","royalblue","seagreen","orange", "red", "brown4")),
                     nrpoints = 100, pch = ".", cex = 1, col = "black",
                     # transformation = function(x) log(x+1),
                     transformation = function(x) x,
                     postPlotHook = box,xaxs='i',yaxs='i',
                     xlab="Emission Wavelength [nm]",
                     ylab="Absorption Wavelength [nm]",
                     axes=FALSE)
  for (n in 0:12) {
     for (m in 0:n) {
        text(mu11(n,m),mu22(n,m),paste("(",n,",",m,")",sep=""),font=2 )
     }
  }
  nm<-seq(0,4,.001)
  lines(mu_lim_30(nm,1),mu_lim_30(nm,2),lwd=1,lty=2,col="black")
  lines(mu_lim_0(nm,1,1),mu_lim_0(nm,2,1),lwd=2,col="black")
  lines(mu_lim_0(nm,1,2),mu_lim_0(nm,2,2),lwd=2,col="black")
  box()
  axis(1)
  axis(3,labels=FALSE)
  axis(2)
  axis(4,labels=FALSE)

  image.plot(legend.only=TRUE, 
               nlevel = 500,
               col = colorRampPalette(c("white","royalblue","seagreen","orange", "red", "brown4"))(500),
               # axis.args=list( at=log(seq(0,1,.2)+1), labels=seq(0,1,.2) ),
               # zlim=log(c(0,1)+1)
               axis.args=list( at=seq(0,1,.2), labels=seq(0,1,.2) ),
               zlim=c(0,1)
               ) 
  dev.off()
}
