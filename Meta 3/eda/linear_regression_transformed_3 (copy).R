# Transformed Uni variate Linear Regression

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(stringr, quietly=TRUE)
library(viridis, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "Linear_Regression_Transformed_4"

data <- read.csv("../results2.csv")

data$x <- rep(0, nrow(data))

data[data$algorithm=="Dinic",]$x <- data[data$algorithm=="Dinic",]$vertices^2 * data[data$algorithm=="Dinic",]$arcs
data[data$algorithm=="EK",]$x <- data[data$algorithm=="EK",]$arcs^2 * data[data$algorithm=="EK",]$vertices
data[data$algorithm=="MPM",]$x <- data[data$algorithm=="MPM",]$vertices^3

data[data$algorithm=="Dinic",]$time <- (data[data$algorithm=="Dinic",]$time - mean(data[data$algorithm=="Dinic",]$time)) / (sd(data[data$algorithm=="Dinic",]$time))
data[data$algorithm=="EK",]$time <- (data[data$algorithm=="EK",]$time - mean(data[data$algorithm=="EK",]$time)) / (sd(data[data$algorithm=="EK",]$time))
data[data$algorithm=="MPM",]$time <- (data[data$algorithm=="MPM",]$time - mean(data[data$algorithm=="MPM",]$time)) / (sd(data[data$algorithm=="MPM",]$time))

data[data$algorithm=="Dinic",]$x <- (data[data$algorithm=="Dinic",]$x - mean(data[data$algorithm=="Dinic",]$x)) / (sd(data[data$algorithm=="Dinic",]$x))
data[data$algorithm=="EK",]$x <- (data[data$algorithm=="EK",]$x - mean(data[data$algorithm=="EK",]$x)) / (sd(data[data$algorithm=="EK",]$x))
data[data$algorithm=="MPM",]$x <- (data[data$algorithm=="MPM",]$x - mean(data[data$algorithm=="MPM",]$x)) / (sd(data[data$algorithm=="MPM",]$x))


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
  fit <- lm(time ~ x, data=df)
  print(summary(fit))
  sink(file=NULL)
  
  for (i in seq(length(plot_names))) {
    filename <- paste(plot_names[i], "png", sep=".")
    png(paste(path, filename, sep="/"), width=w, height=h)
    plot(fit, which=i)
    invisible(dev.off())
  }
}
