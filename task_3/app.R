#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(bslib)
library(lubridate)
library(here)

coral <- readxl::read_excel(here('data', 'coral_data_244.xls')) %>% 
  mutate(date = ymd(date))

my_theme <- bs_theme(
  bg = '#B7D1DA',
  fg = '#465775', #color of font
  primary = 'white',
  base_font = font_google('Lexend')
)


# Define UI for application that draws a histogram
ui <- fluidPage(theme = my_theme,
                navbarPage("Coral Across Northshore Moorea",
                           tabPanel('About',
                                    mainPanel(
                                      h1('Overview of the Study'),
                                      h2('To visualize the spatial distribution of coral sizes across the northshore of Moorea based on genus and available settlement area'),
                                      h6('Alicia Canales, Kat Mackay, Danielle Hoekstra')
                                    )),
                           tabPanel('Map 1',
                                   sidebarLayout(
                                     sidebarPanel("Genus",
                                                  checkboxGroupInput(inputId = 'pick_species',
                                                                     label = 'Choose species',
                                                                     choices = unique(coral$genus)
                                                                     )
                                                  ),
                                     mainPanel("Output",
                                               plotOutput('coral_plot')
                                               )
                                   ) 
                                   ),
                           tabPanel('Date'),
                            tabPanel('map 2')
                )
)
    # Application title
  

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  coral_reactive <- reactive({
    coral %>%
      filter(genus %in% input$pick_species)
  })
  
  output$coral_plot <- renderPlot(
    ggplot(data = coral_reactive(), aes(x = length, y = width)) +
      geom_point(aes(color = genus))
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)
