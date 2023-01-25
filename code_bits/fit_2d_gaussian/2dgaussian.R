library(tidyverse)
library(patchwork)
library(broom)
theme_set(theme_bw())
colors <- colorRampPalette(c("white","royalblue","seagreen","orange","red", "brown"))

# Create general elliptical 2D Gaussian function (spherical if b=0)
gauss2 <- function(x,y,x0=0,y0=0,A=1,a=1,b=.1,c=1) {
    A*exp(-(a*(x-x0)^2+2*b*(x-x0)*(y-y0)+c*(y-y0)^2))
}

# Create fake data
df <- tibble(expand.grid(x=seq(0,10,by=.1), 
                         y=seq(0,10,by=.1)),
             z = gauss2(x,y,x0=5,y0=5,A=10,a=2.2,b=0.15,c=2.2)+ 
                 gauss2(x,y,x0=3,y0=4,A=5,a=1.5,b=0.15,c=1.5)+ 
                 runif(length(x))
                 )
# Look at it
df

# Plot fake data
P1 <- df %>% 
    ggplot(aes(x = x, y = y, fill = z)) +
        geom_raster(interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             name = "Intensity\n[arb. units]")+
        labs(title="Plot data")

# Perform fit
fit <- nls(data=df,
    z ~ gauss2(x,y,x0_1,y0_1,A_1,a_1,b_1,c_1)+ 
        gauss2(x,y,x0_2,y0_2,A_2,a_2,b_2,c_2),
    start=list(x0_1 = 4.5, y0_1 = 4.5,
               x0_2 = 2.5, y0_2 = 3.8,
               A_1 = 8, a_1 = 2, b_1 = 0.1, c_1 = 2,
               A_2 = 4, a_2 = 1, b_2 = 0.1, c_2 = 1),
    control = nls.control(maxiter = 1000)
    )

# Get fit parameters
tidy(fit)
centers <- tidy(fit) %>% 
    filter(str_detect(term, "0_")) %>% 
    select(term, estimate) %>% 
    pivot_wider(names_from = term, 
                values_from = estimate) %>% 
    pivot_longer(everything(),
                 cols_vary = "slowest",
                 names_to = c(".value"),
                 names_pattern = "(.)")

# Plot fit
P2 <- augment(fit)%>% 
    ggplot(aes(x = x, y = y, fill = .fitted)) +
        geom_raster(interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             name = "Intensity\n[arb. units]")+
        labs(title="Plot fit")

# Plot data and overlay fit as contour plot
P3 <- df %>% 
    ggplot(aes(x = x, y = y)) +
        geom_raster(aes(fill = z), interpolate=TRUE)+
        scale_fill_gradientn(colors = colors(10), 
                             name = "Intensity\n[arb. units]")+
        geom_contour(data=augment(fit), 
                     aes(z = .fitted), color = "black", bins = 5)+
        labs(title="Plot data and overlay fit as contour plot",
             subtitle="Fitted centers as grey points")+
        geom_point(data=centers, color="gray", size=2)


ggsave("data_and_fit.pdf", 
        P1/P2/P3,
        height = 8,
        width = 6)
