library(tidyverse)
library(Rcpp)

theme_set(theme_void()+
          theme(legend.position = "none",
                plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")))

# # # # # # # # # # # # # # # # # # # # # # 
# Creating the Mandelbrot set using R code
# # # # # # # # # # # # # # # # # # # # # # 

fractal <- function(coord      = c(-.8, .2), 
                    delta      = .5, 
                    resolution = 400,
                    niter      = 500, 
                    p          = 2,
                    q          = 1,
                    zmax       = 2,
                    cols       = c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", 
                                   "#4ab04a", "#ffd73e", "#eec73a", "#e29421", 
                                   "#e29421", "#f05336", "#ce472e", "black"),
                    fold       = FALSE,
                    plot       = TRUE
                   ){
    colors <- cols
    if(fold){ colors <- c(cols, rev(cols))}
    colors <- colorRampPalette(colors)(niter)
    x <- seq(coord[1] - delta, coord[1] + delta, length.out=resolution)
    y <- seq(coord[2] - delta, coord[2] + delta, length.out=resolution)
    d <- expand.grid(x = x, y = y) %>% 
        tibble() %>% 
        mutate(c = x + y*1i, 
               z = 0, 
               k = 0)
    for (rep in 1:niter) { 
        index <- which(Mod(d$z) < zmax)
        d$z[index] <- d$z[index]^p + d$c[index]^q
        d$k[index] <- d$k[index] + 1
    }
    if(plot){
        d %>% ggplot(aes(x = x, y = y, fill = k)) +
        geom_raster(interpolate = TRUE)+
        scale_x_continuous(expand = c(0,0)) +
        scale_y_continuous(expand = c(0,0)) +
        scale_fill_gradientn(colors = colors)
    }else{
        d %>% select(x,y,k)
    }
}

fractal(coord      = c(0,0), 
        delta      = 1.5, 
        p          = 2,
        q          = 2,
        niter      = 200, 
        resolution = 500, 
        plot       = TRUE)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Creating the Mandelbrot set using Rcpp code for faster evaluation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

cppFunction('DataFrame fractalC(double x, double y, double delta, int resolution, int niter){
    int i, j, l;
    int N = resolution*resolution;
    double z[2], c[2], oldz[2];
    NumericVector xx(resolution), yy(resolution), xxx(N), yyy(N), k(N);
    
    // Creating the dataframe of x and y coordinates
    double by = 2*delta / (resolution-1);
    xx[0] = x - delta;
    yy[0] = y - delta;
    for(i=1; i < resolution; i++) { 
        xx[i] = xx[i-1] + by;
        yy[i] = yy[i-1] + by;
    }
    for(i=0; i < resolution; i++) { 
        for(j=0; j < resolution; j++) { 
            xxx[i*resolution+j] = xx[i];
            yyy[i*resolution+j] = yy[j];
        }
    }
    DataFrame df = DataFrame::create(Named("x") = xxx,
                                     Named("y") = yyy,
                                     Named("k") = k);
    
    // Looping to create the Mandelbrot set
    for(i = 0; i < N; i++) {
        z[0] = 0; z[1] = 0;
        for(l = 1; l < niter + 1; l++) {
            c[0]    = xxx[i];    c[1] = yyy[i];
            oldz[0] = z[0];   oldz[1] = z[1];
            z[0] = oldz[0]*oldz[0] - oldz[1]*oldz[1] + c[0];
            z[1] = 2*oldz[0]*oldz[1] + c[1];
            k(i) += 1;
            if((z[0]*z[0] + z[1]*z[1]) > 4) break;
        }
    }
   return df;
}')

# # # # # # # # # # # # # # #
# Benchmarking the 2 versions
# # # # # # # # # # # # # # #

library(microbenchmark)
microbenchmark(
    Rcode = fractal(coord      = c(-.74,.18), 
                    delta      = .01, 
                    p          = 2,
                    niter      = 200, 
                    resolution = 500, 
                    plot       = FALSE), 
    Rcpp  = tibble(fractalC(-.74,.18,.01,500,200)),
    times = 10L)

# There is a factor ~20 speed increase with the Rcpp version

# # # # # # # # # # #
# Making a nice plot
# # # # # # # # # # #

cols <- c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", 
          "#4ab04a", "#ffd73e", "#eec73a", "#e29421", 
          "#e29421", "#f05336", "#ce472e", "black")
colors <- colorRampPalette(cols)(200)

frac <- tibble(fractalC(-.74,.18,.001,5000,200))

P <- frac %>% ggplot(aes(x = x, y = y, fill = k)) +
    geom_raster(interpolate = TRUE)+
    scale_x_continuous(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_fill_gradientn(colors = colors)

ggsave("fractal.png", P, width=7, height=7)
