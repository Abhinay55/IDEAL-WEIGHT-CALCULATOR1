library(shiny)
library(shinythemes)
library(markdown)
ui = fluidPage(theme=shinytheme("darkly"),
               h2(textOutput("currentTime"),
                  navbarPage("Ideal Weight Calculator",
                             tabPanel("Home",
                                      titlePanel("About the concept"),
                                      mainPanel(
                                        div(includeMarkdown("Home.txt"))
                                      )
                             ),
                             tabPanel("Calculator",
                                      titlePanel("Calculator"),
                                      sidebarLayout(
                                        sidebarPanel(
                                          textInput(inputId = "name", label = "Enter your name."),
                                          textInput(inputId = "age",  label = "Enter your age"),
                                          numericInput("Height",
                                                       label="Enter your Height (in cm)",value=0),
                                          selectInput("Gender",label="Select your gender",choices = c("Male","Female"),selected="Male"),
                                          actionButton("submitbutton",label="Submit")
                                        ),
                                        mainPanel(
                                          tableOutput("result")
                                        )
                                      )
                             )
                  )
               )
)
server <- function(input, output,session) {
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  inputdata <- reactive({
    MyHeight = input$Height
    MyGender = input$Gender
    if(MyGender == "Male") {
      idealWeight <- 50 + (0.9 * (MyHeight - 152))
    } else {
      idealWeight <-  45.5 +( 0.9 * (MyHeight - 152))
    }
    idealWeight <- data.frame(idealWeight)
    names(idealWeight) <- "Your idealWeight (in kg) is"
    print(idealWeight)
  })
  output$result <- renderTable({
    if(input$submitbutton>0){
      isolate(inputdata())
    }
  })
}
shinyApp(ui = ui, server = server)