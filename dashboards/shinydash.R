#install.packages("shinydashboard")


## app.R

library(shiny)

ui <- dashboardPage(
  dashboardHeader(title = "Hackathon 2022"),
  dashboardSidebar(
    sidebarMenu(id = 'tabs',
                sidebarMenuOutput('menu'))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "m1", p("Explore Audio Anomalies") ),
      tabItem(tabName = "m2", p("Library of Anomalies") )
    ),
    
    fluidRow(
      box(plotOutput("plot1", height = 250)),
      
      
      box(
        title = "Segment Length",
        sliderInput("slider", "Number of Seconds:", 1, 30, 5)
      )
    )
   
      
        
  )
)



server <- function(input, output, session) {
  
  output$menu <- renderMenu({
    sidebarMenu(
      menuItem("Analyze", tabName="m1", icon = icon("folder-music")),
      menuItem("Library", tabName="m2", icon = icon("boombox"))
    )
  })
  
  output$plot1 <- renderPlot({
 
   
  get_wav("KDGE_149_noise_atten0.1.wav") -> df
  
    df <- df[1:which(input$slider==df$Time),]
      
    df %>%
    ggplot(mapping = aes(x = seq_len(Time), y = Amplitude)) +
      geom_line(color = 'blue') +
      labs(x = "Sample Number", y = "amplitude", title = 'Noise Sample Amplitude') +
      theme(plot.title = element_text(hjust = 0.5))
  
  })
  
  isolate({updateTabItems(session, "tabs", "m1")})
  
  
  
}


shinyApp(ui, server)