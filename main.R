# Install shiny if you haven't already: install.packages("shiny")
library(shiny)

ui <- fluidPage(
  titlePanel("Product Price Analyzer"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File", accept = c(".csv")),
      helpText("Ensure your CSV contains: Product, Price, and Discount columns.")
    ),
    
    mainPanel(
      tableOutput("summaryTable")
    )
  )
)

server <- function(input, output, session) {
  output$summaryTable <- renderTable({
    req(input$file1)
    
    # Read the uploaded dataset
    data <- read.csv(input$file1$datapath)
    
    # Calculate metrics
    summary_df <- data.frame(
      Product          = data$Product,
      Original_Price   = data$Price,
      Discounted_Price = round(data$Price - (data$Price * data$Discount / 100), 2),
      Diff_From_500    = abs(data$Price - 500)
    )
    
    return(summary_df)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
