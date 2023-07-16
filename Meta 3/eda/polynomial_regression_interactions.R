# Polynomial Regression with Interactions

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Polinomial_Regression_Interactions"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)
data_mean$arcs <- data_mean$probability * ((data_mean$vertices * (data_mean$vertices - 1)) / 2)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)

plot_names <- c("residuals_vs_fitted", "normalqq_plot", "scale_location", "cooks_distance", "residuals_vs_leverage", "cooks_dist_vs_leverage")


directory <- "No_Mean"

for (algorithm in algorithms) {
  path <- paste(root_directory, directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  filename <- paste(path, paste(algorithm, "txt", sep="."), sep="/")
  
  aux <- data[data$algorithm==algorithm,]
  
  sink(file=filename)
  switch (algorithm,
          "Dinic" = fit <- lm(time ~ poly(vertices, 2, raw=TRUE) * arcs, data=aux),
          "EK" = fit <- lm(time ~ sqrt(vertices) * poly(arcs, 2, raw=TRUE), data=aux),
          "MPM" = fit <- lm(time ~ poly(vertices, 3, raw=TRUE), data=aux)
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
