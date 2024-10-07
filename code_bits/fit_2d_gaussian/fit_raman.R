library(tidyverse)
library(broom)
library(readxl)
library(ggrepel)
library(glue)
theme_set(theme_bw()+theme(legend.position = "none"))

cols <- c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", 
          "#4ab04a", "#ffd73e", "#eec73a", "#e29421", 
          "#e29421", "#f05336", "#ce472e", "black")
colors <- colorRampPalette(cols)

df <- read_excel("data65.xlsx") %>% rename(w=...1)

# Create general elliptical 2D Gaussian function (spherical if b=0)
Gauss2D <- function(x,y,x0=0,y0=0,A=1,FWx=1,FWy=1) {
    stopifnot(length(x)==length(y), length(x0)==length(y0),
              length(x0)==length(A),length(x0)==length(FWx),
              length(x0)==length(FWy))
    sigx <- FWx/2/sqrt(2*log(2))
    sigy <- FWy/2/sqrt(2*log(2))
    z <- 0
    for(i in seq_along(x0)){
        z <- z + A[i]*exp(-( (x-x0[i])^2/2/sigx[i]^2 + (y-y0[i])^2/2/sigy[i]^2 ))
    }
    return(z)
}

# Read data
dftidy <- df %>% 
        pivot_longer(cols=-w, 
                     names_to = "laser",
                     values_to = "int", 
                     names_transform = list(laser=as.numeric)) %>% 
        mutate(int=ifelse(int==0, NA, int)) %>% 
        drop_na() %>% 
        mutate(int = int-min(int),
               lint = log10(int)) %>% 
        filter(w>200, w<400, laser>600)

# Guess centers "by hand"
centers_by_hand <- tribble(
~w,    ~laser,
233.7, 792.5,
306.3, 689.4,
300.0, 663.3,
371.6, 825.1)

# Perform fit
fit <- nls(data = dftidy,
    int ~ int0 + Gauss2D(w,laser,w0,laser0,A,FWw,FWlaser),
    start=list(int0    = 0.1,
               w0      = centers_by_hand$w, 
               laser0  = centers_by_hand$laser,
               A       = rep(10, nrow(centers_by_hand)), 
               FWw     = rep(10, nrow(centers_by_hand)), 
               FWlaser = rep(10, nrow(centers_by_hand))),
    control = nls.control(maxiter = 1000)
    )

# Retrieve fit parameters
tidy(fit)
centers <- tidy(fit) %>% 
    filter(str_detect(term, "w0") | str_detect(term, "laser0")) %>% 
    select(term, estimate) %>% 
    pivot_wider(names_from = term, 
                values_from = estimate) %>% 
    pivot_longer(everything(),
                 cols_vary = "slowest",
                 names_to = c(".value"),
                 names_pattern = "(.)") %>% 
    rename(laser=l) %>% 
    round(2)

# Make plot
colors <- colorRampPalette(c("white","royalblue","seagreen","orange","red"))
P <- dftidy %>% 
    ggplot(aes(x = w, y = laser)) +
        geom_contour_filled(aes(z = lint), bins=500)+
        geom_contour(aes(z = predict(fit)), color = "black", bins = 5)+
        scale_fill_manual(values = colors(500))+
        geom_point(data=centers, color="gray", size=2)+
        labs(x="Raman Shift [1/Å]", y="Laser Excitation [nm]")+
        theme(legend.position="none")+
        scale_x_continuous(breaks = seq(200, 400, 20))+
        coord_cartesian(xlim=c(225, 375), ylim=c(650, 850))+
        geom_label_repel(data=centers,
                         aes(label = glue("𝝎 = {w} /Å\n𝝺 = {laser} nm")), 
                         nudge_x = -20, nudge_y = 50)
ggsave("raman_map.png", P, height = 6, width = 8)
