library(tidyverse)
library(patchwork)
library(broom)
theme_set(theme_bw()+theme(legend.key.height = unit(1.5, 'cm')))
cols <- c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", 
          "#4ab04a", "#ffd73e", "#eec73a", "#e29421", 
          "#e29421", "#f05336", "#ce472e", "black")
colors <- colorRampPalette(cols)

# Create general elliptical 2D Gaussian function (spherical if b=0)
Gauss2D <- function(x,y,x0=0,y0=0,A=1,a=1,b=.1,c=1) {
    stopifnot(length(x)==length(y), length(x0)==length(y0),
              length(x0)==length(A),length(x0)==length(a),
              length(x0)==length(b),length(x0)==length(c))
    z <- 0
    for(i in seq_along(x0)){
        z <- z + A[i]*exp(-(a[i]*(x-x0[i])^2+2*b[i]*(x-x0[i])*(y-y0[i])+c[i]*(y-y0[i])^2))
    }
    return(z)
}

# Create fake data
df <- tibble(expand.grid(x=seq(0,10,by=.1), 
                         y=seq(0,10,by=.1)),
             z = Gauss2D(x, y,
                        x0=c(5,3),  y0=c(5,6),
                         A=c(10,6),  a=c(2.2,1.5),
                         b=c(0.15,1),c=c(2.2,1.5)) + runif(length(x))
                 )

# Plot fake data
P1 <- df %>% 
    ggplot(aes(x = x, y = y, fill = z)) +
        geom_raster(interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             limits = c(-.2,11),
                             breaks = seq(0,12,2),
                             name = "Intensity\n[arb. units]")+
        labs(title="Plot data")
# Perform fit
fit <- nls(data=df,
    z ~ z0 + Gauss2D(x,y,x0,y0,A,a,b,c),
    start=list(z0 = 0.1,
               x0 = c(4.5, 3.2), 
               y0 = c(4.5, 5.5),
               A = c(8,8),     a = c(2,2), 
               b = c(0.1,0.1), c = c(2,2)),
    control = nls.control(maxiter = 1000)
    )

# Get fit parameters
tidy(fit)
centers <- tidy(fit) %>% 
    filter(str_detect(term, "x") | str_detect(term, "y")) %>% 
    select(term, estimate) %>% 
    pivot_wider(names_from = term, 
                values_from = estimate) %>% 
    pivot_longer(everything(),
                 cols_vary = "slowest",
                 names_to = c(".value"),
                 names_pattern = "(.)")

# Plot fit
P2 <- df %>% 
    ggplot(aes(x = x, y = y, fill = predict(fit))) +
        geom_raster(interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             limits = c(-.2,11),
                             breaks = seq(0,12,2),
                             name = "Intensity\n[arb. units]")+
        labs(title="Fit result")

# Plot data - fit
P3 <- df %>% 
    ggplot(aes(x = x, y = y, fill = z-predict(fit))) +
        geom_raster(interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             limits = c(-.2,11),
                             breaks = seq(0,12,2),
                             name = "Intensity\n[arb. units]")+
        labs(title="Data - fit")

# Plot data and overlay fit as contour plot
P4 <- df %>% 
    ggplot(aes(x = x, y = y)) +
        geom_raster(aes(fill = z), interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             limits = c(-.2,11),
                             breaks = seq(0,12,2),
                             name = "Intensity\n[arb. units]")+
        geom_contour(aes(z = predict(fit)), color = "black", bins = 5)+
        labs(title="Plot data and overlay fit as contour",
             subtitle="Fitted centers as grey points")+
        geom_point(data=centers, color="gray", size=2)


ggsave("data_and_fit.pdf", 
        P1+P2+P3+P4+plot_layout(guides="collect"),
        height = 6,
        width = 8)


