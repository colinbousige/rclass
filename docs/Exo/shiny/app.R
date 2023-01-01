library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)
library(ggrepel)
library(patchwork)
theme_set(theme_bw()+
          theme(strip.background = element_blank(),
                strip.text=element_text(face="bold"))
          )

urlConfirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
urlDeaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
confirmed_raw <- read_csv(urlConfirmed)
deaths_raw    <- read_csv(urlDeaths)
tidyfy_jhh <- function(df, name) {
    df %>% 
        rename(state   = `Province/State`,
               country = `Country/Region`) %>%
        filter(country != "Diamond Princess") %>%
        select(-c(state, Lat, Long)) %>%
        pivot_longer(cols      = -country,
                     names_to  = "date",
                     values_to = "count") %>% 
        mutate(date = mdy(date)) %>% 
        group_by(country, date) %>% 
        summarize(!!sym(name):=sum(count)) %>% 
        ungroup()
}
confirmed <- tidyfy_jhh(confirmed_raw, 'confirmed')
deaths    <- tidyfy_jhh(deaths_raw, 'deaths')
MIN <- min(confirmed$confirmed[confirmed$country == "China"])
alldata <- confirmed %>% 
            full_join(deaths) %>% 
            group_by(country) %>% 
            mutate(newcases  = confirmed - lag(confirmed),
                   newdeaths = deaths - lag(deaths)) %>% 
            filter(confirmed >= MIN) %>% 
            mutate(day=1:n()) %>% 
            filter(n() >= 7) %>% 
            ungroup()

alldata <- alldata %>% 
    rename(`New Confirmed Cases`="newcases",
           `New Confirmed Deaths`="newdeaths",
           `Total Confirmed Cases`="confirmed",
           `Total Confirmed Deaths`="deaths"
           ) %>% 
    pivot_longer(cols=-c(country,date,day),
                 names_to="type",
                 values_to="count")

# # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # 


ui <- fluidPage(

    titlePanel("COVID19 Example Dashboard"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("country", "Select Countries", 
                choices  = unique(alldata$country), 
                selected = c("France","US","India"),
                multiple = TRUE
            ),
            sliderInput("span","Smoothing span", min=0, max=1, step=.01, value=.15)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("New Cases", 
                    plotlyOutput("plot_newcases")
                    ),
                tabPanel("Total Cases", 
                    plotlyOutput("plot_totalcases")
                    )
                )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$plot_newcases <- renderPlotly({
        if(length(input$country)>0){
            P <- alldata %>% 
                filter(country %in% input$country) %>%
                filter(type %in% c("New Confirmed Cases",
                                   "New Confirmed Deaths")) %>% 
                filter(count > 0) %>% 
                ggplot(aes(x=date, y=count, fill=country))+
                    geom_bar(stat = 'identity', position = 'dodge', alpha=.7)+
                    geom_smooth(span=input$span, se=FALSE, 
                                aes(color=country), show.legend = FALSE)+
                    ggtitle("New Cases Per Day")+
                    labs(x="Date",
                         y="Count",
                         fill="")+
                    facet_wrap(~type, scale="free_y")
            ggplotly(P, dynamicTicks = TRUE)
        }
    })
    
    output$plot_totalcases <- renderPlotly({
        if(length(input$country)>0){
            P <- alldata %>% 
                filter(country %in% input$country) %>%
                filter(type %in% c("Total Confirmed Cases",
                                   "Total Confirmed Deaths")) %>% 
                ggplot(aes(x=date, y=count, color=country))+
                    geom_line(size=1)+
                    xlab("Days")+
                    ylab("Total Count")+
                    theme(legend.position = 'top')+
                    facet_wrap(~type, scale="free_y")
            ggplotly(P, dynamicTicks = TRUE)
        }
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
