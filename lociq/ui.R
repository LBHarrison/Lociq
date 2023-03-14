library(shiny)
library(shinythemes)
library(DT)



ui <- fluidPage(theme = shinytheme("sandstone"),
  titlePanel("Plasmid Analysis"),
  sidebarLayout(
sidebarPanel(
#
  
  list(selectInput("dataset", "Select plasmid 1:", 
              choices = levels(factor(df.annotation[,8]))
  ),
  selectInput("dataset1", "Select plasmid 2:", 
              choices = levels(factor(df.annotation[,8]))
  )
  ), width = 12
  
#
  ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Plasmid 1 Structure", dataTableOutput("summary")),
                  tabPanel("Plasmid 1 AMR", dataTableOutput("table")),
                  tabPanel("Plasmid 2 Structure", dataTableOutput("summary2")),
                  tabPanel("Plasmid 2 AMR", dataTableOutput("table2")),
                  tabPanel("AMR Plasmid db", dataTableOutput("tableAMR"))
      ), width = 12
#   The below line corresponds to the opening bracket of mainPanel   
    )
#   The below line corresponds to the opening bracket of sidebarLayout
  )
#   The below line corresponds to the opening bracket of fluidpage
)



