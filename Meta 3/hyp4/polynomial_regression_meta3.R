# Polynomial Regression with Interactions

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)
library(car)

w <- 620
h <- 360

root_directory <- "Polinomial_Regression_Meta3"

data <- read.csv("../new_results_paired.csv")

algorithms <- unique(data$algorithm)

plot_names <- c("residuals_vs_fitted_meta3", "normalqq_plot_meta3", "scale_location_meta3", "cooks_distance_meta3", "residuals_vs_leverage_meta3", "cooks_dist_vs_leverage_meta3")


for (algorithm in algorithms) {
  path <- paste(root_directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste(path, paste(algorithm, "txt", sep="."), sep="/")
  
  df <- data[data$algorithm==algorithm,]
  
  sink(file=filename)
  switch (algorithm,
          "Dinic" = fit <- lm(time ~ poly(vertices, 2, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df),
          
          "EK" = fit <- lm(time ~ poly(vertices, 2, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df),
          
          "MPM" = fit <- lm(time ~ poly(vertices, 3, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df)
  )
  
  switch (algorithm,
          "Dinic" = aov.out <- aov(time ~ poly(vertices, 2, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df),
          
          "EK" = aov.out <- aov(time ~ poly(vertices, 2, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df),
          
          "MPM" = aov.out <- aov(time ~ poly(vertices, 3, raw=TRUE) * poly(arcs, 2, raw=TRUE), data=df)
  )

  print(summary(fit))
  
  print(shapiro.test(residuals(aov.out)))
  
  sink(file=NULL)
  
  for (i in seq(length(plot_names))) {
    filename <- paste(plot_names[i], "png", sep=".")
    png(paste(path, filename, sep="/"), width=w, height=h)
    plot(fit, which=i)
    invisible(dev.off())
  }
}
