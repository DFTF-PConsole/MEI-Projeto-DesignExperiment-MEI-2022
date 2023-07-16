# Polynomial Regression with Interactions

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Polinomial_Regression"

data <- read.csv("../results2.csv")

algorithms <- unique(data$algorithm)

plot_names <- c("residuals_vs_fitted", "normalqq_plot", "scale_location", "cooks_distance", "residuals_vs_leverage", "cooks_dist_vs_leverage")


for (algorithm in algorithms) {
  path <- paste(root_directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste(path, paste(algorithm, "txt", sep="."), sep="/")
  
  df <- data[data$algorithm==algorithm,]
  
  sink(file=filename)
  switch (algorithm,
          "Dinic" = fit <- lm(time ~ poly(vertices, 2, raw=TRUE) * poly(arcs, 1, raw=TRUE), data=df),
          "EK" = fit <- lm(time ~ poly(arcs, 2, raw=TRUE) * poly(vertices, 1, raw=TRUE), data=df),
          "MPM" = fit <- lm(time ~ poly(vertices, 3, raw=TRUE) + poly(vertices, 2, raw=TRUE):poly(arcs, 1, raw=TRUE) + poly(arcs, 1, raw=TRUE), data=df)
  )
  print(summary(fit))
  sink(file=NULL)
  
  for (i in seq(length(plot_names))) {
    filename <- paste(plot_names[i], "png", sep=".")
    png(paste(path, filename, sep="/"), width=w, height=h)
    plot(fit, which=i)
    invisible(dev.off())
  }
}
