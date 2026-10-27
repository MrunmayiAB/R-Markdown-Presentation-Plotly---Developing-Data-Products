library(shiny)
library(plotly)

data("ToothGrowth", package = "datasets")
tooth <- ToothGrowth
tooth$supp <- factor(tooth$supp, levels = c("OJ", "VC"))

server <- function(input, output, session) {
  dose_data <- reactive({
    req(input$dose)
    subset(tooth, dose == as.numeric(input$dose))
  })

  selected_data <- reactive({
    subset(dose_data(), supp == input$supp)
  })

  output$selection_title <- renderText({
    paste(if (input$supp == "OJ") "Orange juice" else "Ascorbic acid",
          "at", input$dose, "mg/day")
  })

  output$summary_cards <- renderUI({
    x <- selected_data()$len
    z <- t.test(x, conf.level = 0.95)
    other <- if (input$supp == "OJ") "VC" else "OJ"
    other_x <- subset(dose_data(), supp == other)$len
    mean_label <- sprintf("%.2f", mean(x))
    ci_label <- sprintf("%.2f to %.2f", z$conf.int[1], z$conf.int[2])
    other_label <- sprintf("%.2f", mean(other_x))
    fluidRow(
      column(4, div(class = "value-box", strong("Selected-group mean"), h3(mean_label), p("tooth-length units"))),
      column(4, div(class = "value-box", strong("95% CI for mean"), h4(ci_label), p("t interval, n = 10"))),
      column(4, div(class = "value-box", strong(paste0(other, " mean")), h3(other_label), p("same dose, n = 10")))
    )
  })

  output$comparison <- renderPrint({
    d <- dose_data()
    d$supp <- droplevels(d$supp)
    fit <- t.test(len ~ supp, data = d, conf.level = 0.95)
    selected_mean <- mean(selected_data()$len)
    other <- if (input$supp == "OJ") "VC" else "OJ"
    other_mean <- mean(subset(d, supp == other)$len)
    comparison_ci <- if (input$supp == "OJ") {
      fit$conf.int
    } else {
      c(-fit$conf.int[2], -fit$conf.int[1])
    }
    cat(sprintf("At %.1f mg/day, the observed mean difference (%s minus %s) is %.2f units.\n",
                as.numeric(input$dose), input$supp, other, selected_mean - other_mean))
    cat(sprintf("Welch two-sample t-test: 95%% CI for %s - %s = [%.2f, %.2f], p = %.4f.\n",
                input$supp, other, comparison_ci[1], comparison_ci[2], fit$p.value))
    cat("Interpret the interval as uncertainty about the population mean difference under independent, approximately normal groups; it is not a measure of individual response.")
  })

  output$growth_plot <- renderPlotly({
    d <- tooth
    means <- aggregate(len ~ dose + supp, data = d, FUN = mean)
    selected_dose <- as.numeric(input$dose)
    plot_ly() |>
      add_trace(data = d, x = ~dose, y = ~len, type = "scatter", mode = "markers",
                color = ~supp, colors = c(OJ = "#087e8b", VC = "#f28f3b"),
                marker = list(size = 9, opacity = 0.58),
                text = ~paste("Supplement:", supp, "<br>Dose:", dose, "mg/day<br>Length:", len),
                hovertemplate = "%{text}<extra></extra>", name = "Animals") |>
      add_trace(data = means, x = ~dose, y = ~len, type = "scatter", mode = "lines+markers",
                color = ~supp, colors = c(OJ = "#087e8b", VC = "#f28f3b"),
                marker = list(size = 13, symbol = "diamond", line = list(width = 1, color = "white")),
                text = ~paste(supp, "mean:", round(len, 2)),
                hovertemplate = "%{text}<br>Dose: %{x} mg/day<extra></extra>",
                name = "Group means", showlegend = FALSE) |>
      layout(title = "Individual tooth lengths and group means",
             xaxis = list(title = "Dose (mg/day)", tickvals = c(0.5, 1, 2),
                          ticktext = c("0.5", "1", "2")),
             yaxis = list(title = "Tooth length (dataset units)"),
             shapes = list(list(type = "rect", xref = "x", yref = "paper",
                                x0 = selected_dose - 0.13, x1 = selected_dose + 0.13,
                                y0 = 0, y1 = 1, fillcolor = "#ffe08a", opacity = 0.18,
                                line = list(width = 0))),
             legend = list(title = list(text = "Supplement")), hovermode = "closest")
  })
}

