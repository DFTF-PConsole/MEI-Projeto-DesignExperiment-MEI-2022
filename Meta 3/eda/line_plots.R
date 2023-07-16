# 2D Line Plots

# Set Working Directory
setwd("~/MEI/2_Ano/MEI/Pratica/MEI-Trabalhos-2022/r")

# Libraries
library(ggplot2)
library(stringr)
library(viridis)

w <- 620
h <- 360

root_directory <- "Line_Plots"

data <- read.csv("../results2.csv")
data_mean <- aggregate(time ~ algorithm + vertices + probability, data=data, FUN=mean)
data_mean <- data_mean[data_mean$vertices>=100&data_mean$vertices<=300,]

algorithms <- unique(data_mean$algorithm)
probabilities <- unique(data_mean$probability)
vertices <- unique(data_mean$vertices)

# Mean of the 30 instances
parent_directory <- "Mean"
directory <- "Vertices_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (vertice in vertices) {
    filename <- paste(algorithm, paste(paste("line_plot", vertice, sep="_v_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data_mean[data_mean$algorithm==algorithm&data_mean$vertices==vertice, c("probability", "time")]
    p <- ggplot(aux, aes(x=probability, y=time)) + geom_line() + geom_point() + 
      labs(title=paste(algorithm, paste("when vertices=", vertice, sep=""), sep=" "), x="Probability", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}

path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), "All", sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (vertice in vertices) {
  filename <- paste("All", paste(paste("line_plot", vertice, sep="_v_"), "png", sep="."), sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data_mean[data_mean$vertices==vertice, c("algorithm", "probability", "time")]
  p <- ggplot(aux, aes(x=probability, y=time, group=algorithm)) + 
    geom_line(aes(color=algorithm)) + geom_point(aes(color=algorithm)) + 
    scale_colour_viridis_d() +
    labs(title=paste("When vertices=", vertice, sep=""), x="Probability", y = "Execution Time (s)")
  print(p)
  invisible(dev.off())
}


directory <- "Probabilities_Fixed"

for (algorithm in algorithms) {
  path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), algorithm, sep="/")
  if (!dir.exists(path)) {
    dir.create(path, recursive=TRUE)
  }
  for (probability in probabilities) {
    filename <- paste(algorithm, paste(paste("line_plot", probability, sep="_p_"), "png", sep="."), sep="_")
    png(paste(path, filename, sep="/"), width=w, height=h)
    aux <- data_mean[data_mean$algorithm==algorithm&data_mean$probability==probability, c("vertices", "time")]
    p <- ggplot(aux, aes(x=vertices, y=time)) + geom_point() + 
      labs(title=paste(algorithm, paste("when p=", probability, sep=""), sep=" "), x="Number of Vertices", y = "Execution Time (s)")
    print(p)
    invisible(dev.off())
  }
}

path <- paste(paste(paste(root_directory, parent_directory, sep="/"), directory, sep="/"), "All", sep="/")
if (!dir.exists(path)) {
  dir.create(path, recursive=TRUE)
}
for (probability in probabilities) {
  filename <- paste(algorithm, paste(paste("line_plot", probability, sep="_p_"), "png", sep="."), sep="_")
  png(paste(path, filename, sep="/"), width=w, height=h)
  aux <- data_mean[data_mean$probability==probability, c("algorithm", "vertices", "time")]
  p <- ggplot(aux, aes(x=vertices, y=time, group=algorithm)) + 
    geom_line(aes(color=algorithm)) + geom_point(aes(color=algorithm)) + 
    scale_colour_viridis_d() +
    labs(title=paste("When p=", probability, sep=""), x="Number of Vertices", y = "Execution Time (s)")
  print(p)
  invisible(dev.off())
}

