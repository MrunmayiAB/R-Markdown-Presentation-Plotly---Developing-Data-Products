# ToothGrowth Explorer

**By Mrunmayi A Bhave**

An interactive guide to the built-in R `ToothGrowth` data. Pick a supplement and dose to view the mean tooth length, a 95% confidence interval, a comparison with the other supplement at the same dose, and an interactive plot of all animal measurements.

## Use the application

1. Choose Orange juice (OJ) or Ascorbic acid (VC).
2. Select a dose: 0.5, 1, or 2 mg/day.
3. Read the updated mean and confidence interval, then review the Welch t-test comparison below.
4. Hover over chart points for the individual measurements. The larger diamond markers show group means; the shaded vertical band highlights the selected dose.

Help is also built into the app: open **How to use this app** in the left panel.

## Run locally

Install R and the `shiny` and `plotly` packages, then run `shiny::runApp("toothgrowth_shiny_app")` from the parent folder. The data are included with R, so no data download is needed.

## Statistical note

Each supplement-by-dose group contains 10 animals. Confidence intervals and Welch tests assume independent observations and rely on approximate normality of measurements within each group. Treat comparisons as results from this experiment rather than broad claims about all animals.

