# Normal QQ Plots

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2, quietly=TRUE)
library(viridis, quietly=TRUE)
library(plotly, quietly=TRUE)
library(stringr, quietly=TRUE)

w <- 620
h <- 360

root_directory <- "NormalQQ_Plots"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)

algorithms <- unique(data$algorithm)
probabilities <- unique(data$probability)
vertices <- unique(data$vertices)
arcs <- unique(data$arcs)


directory <- "No_Mean"

path <- paste(root_directory, directory, sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}

filename <- "All_normalqq_plot.png"
png(paste(path, filename, sep="/"), width=w, height=h)
aux <- data[, c("time")]

qqnorm(aux)
qqline(aux)

invisible(dev.off())

for (algorithm in algorithms) {
  path <- paste(root_directory, directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  
  filename <- paste(algorithm, "normalqq_plot.png", sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data[data$algorithm==algorithm, c("time")]
  
  qqnorm(aux)
  qqline(aux)
  
  invisible(dev.off())
  
  for (vertice in vertices) {
    path <- paste(root_directory, directory, algorithm, vertice, sep="/")
    if (!dir.exists(path)) {
      dir.create(path, recursive=TRUE)
    }
    for (probability in probabilities) {
      filename <- paste(paste(algorithm, "_normalqq_plot_v_", vertice, "_p_", probability, sep=""), "png", sep=".")
      png(paste(path, filename, sep="/"), width=w, height=h)
      aux <- data[data$algorithm==algorithm&data$vertices==vertice&data$probability==probability, c("time")]
      
      qqnorm(aux)
      qqline(aux)
      
      invisible(dev.off())
    }
  }
}

directory <- "Mean"

path <- paste(root_directory, directory, sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}

filename <- "All_normalqq_plot.png"
png(paste(path, filename, sep="/"), width=w, height=h)
aux <- data_mean[, c("time")]

qqnorm(aux)
qqline(aux)

invisible(dev.off())

for (algorithm in algorithms) {
  path <- paste(root_directory, directory, algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  
  filename <- paste(algorithm, "normalqq_plot.png", sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data_mean[data_mean$algorithm==algorithm, c("time")]
  
  qqnorm(aux)
  qqline(aux)
  
  invisible(dev.off())
}

