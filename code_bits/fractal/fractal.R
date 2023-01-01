library(tidyverse)
theme_set(theme_void()+
          theme(legend.position = "none",
                plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")))

fractal <- function(coord      = c(-.8, .2), 
                    delta      = .5, 
                    resolution = 400,
                    niter      = 500, 
                    power      = 2,
                    zmax       = 2,
                    cols       = c("black","red","orange","royalblue","white"),
                    fold       = TRUE,
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
        d$z[index] <- d$z[index]^power + d$c[index]
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

P <- fractal(coord      = c(0,0), 
             delta      = 1.5, 
             power      = 4,
             niter      = 200, 
             resolution = 1500, 
             plot       = TRUE)
ggsave("fractal.png",P)

counter <- 1
for(delta in .95^(seq(0,100,1))){
    P <- fractal(coord      = c(-.74,.18), 
                 delta      = delta, 
                 niter      = 200, 
                 resolution = 500, 
                 plot       = TRUE)
    ggsave(paste0("frac",str_pad(counter, 3, pad = "0"),".png"),P)
    counter <- counter+1
}
system("convert -delay 10 -loop 0 -duplicate 1,-2-1 *.png fractal.gif")