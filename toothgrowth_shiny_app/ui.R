library(shiny)
library(plotly)

ui <- fluidPage(
  titlePanel("ToothGrowth Explorer"),
  tags$head(tags$style(HTML("body { background: #f4f8fb; } .well { background:#eaf3f6; } .value-box {padding:14px; background:white; border-radius:10px; margin-bottom:12px; box-shadow:0 1px 5px #ccd6dc;}"))),
  p("Explore how vitamin C dose and supplement type relate to tooth length in the built-in ToothGrowth experiment."),
  sidebarLayout(
    sidebarPanel(
      radioButtons("supp", "Supplement to inspect", choices = c("Orange juice (OJ)" = "OJ", "Ascorbic acid (VC)" = "VC"), selected = "OJ"),
      selectInput("dose", "Dose (mg/day)", choices = c("0.5", "1", "2"), selected = "0.5"),
      helpText("Choose a supplement and dose. The summary and comparison update automatically."),
      tags$hr(),
      tags$details(
        tags$summary("How to use this app"),
        tags$p("1. Select the supplement and dose in the controls."),
        tags$p("2. Read the selected-group mean and 95% confidence interval."),
        tags$p("3. Compare it with the other supplement at the same dose. The reported interval and Welch two-sample t-test describe uncertainty in the difference of group means."),
        tags$p("4. Hover over points in the chart to see individual measurements. Larger markers indicate group means."),
        tags$p("Tooth length is measured in the dataset's original units. There are 10 guinea pigs in each supplement-by-dose group."),
        tags$p("These are data from a small experiment; the intervals rely on independent observations and approximately normal within-group measurements. The chart is descriptive and does not establish a general causal effect.")
      )
    ),
    mainPanel(
      h3(textOutput("selection_title")),
      uiOutput("summary_cards"),
      plotlyOutput("growth_plot", height = "470px"),
      verbatimTextOutput("comparison")
    )
  )
)

